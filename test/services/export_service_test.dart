import 'dart:convert';

import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/database/daos/quiz_dao.dart';
import 'package:docklands_dojo/database/daos/review_dao.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/user_progress.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/services/export_service.dart';
import 'package:docklands_dojo/services/import_summary.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ExportService exportService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    exportService = ExportService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ExportService - exportAllData', () {
    test('export empty DB produces valid JSON with empty arrays', () async {
      final result = await exportService.exportAllData();
      expect(result, isA<Success<String>>());

      final json = (result as Success<String>).data;
      final decoded = jsonDecode(json) as Map<String, dynamic>;

      expect(decoded['version'], 1);
      expect(decoded['appVersion'], '1.0.0');
      expect(decoded['exportDate'], isNotNull);
      expect(decoded['progress'], isNull);
      expect(decoded['advancements'], isEmpty);
      expect(decoded['sessions'], isEmpty);
      expect(decoded['cardStates'], isEmpty);
      expect(decoded['quizAttempts'], isEmpty);
    });

    test('export with data includes all fields', () async {
      // Seed progress.
      final progress = UserProgress(
        currentRank: BeltRank.kyu7,
        completedTechniques: {'mae_geri': true, 'seiken_tsuki': false},
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024, 1, 15),
      );
      await db.progressDao.saveProgress(progress);

      // Seed an advancement.
      final advancement = BeltAdvancement(
        fromRank: BeltRank.kyu10,
        toRank: BeltRank.kyu9,
        date: DateTime(2024, 3, 1),
        notes: 'First grading',
      );
      await db.progressDao.addBeltAdvancement(advancement);

      // Seed a training session.
      final session = TrainingSession(
        date: DateTime(2024, 6, 1),
        duration: const Duration(minutes: 90),
        notes: 'Kata focus',
      );
      await db.progressDao.addTrainingSession(session);

      // Seed a card review state.
      final cardState = CardReviewState(
        cardId: 'card_001',
        easeFactor: 2.6,
        interval: 5,
        repetitions: 3,
        nextReviewDate: DateTime(2024, 7, 1),
        lastReviewDate: DateTime(2024, 6, 26),
        totalReviews: 10,
        correctReviews: 8,
      );
      await db.reviewDao.saveReviewState(cardState);

      // Seed a quiz attempt.
      final quizAttempt = QuizAttemptData(
        timestamp: DateTime(2024, 5, 15),
        targetRank: BeltRank.kyu9,
        isMockExam: true,
        totalQuestions: 20,
        correctAnswers: 18,
        duration: const Duration(minutes: 10),
        categoryScores: {'terminology': 0.9, 'kihon': 0.85},
        weakAreas: ['kata_sequences'],
      );
      await db.quizDao.addQuizAttempt(quizAttempt);

      final result = await exportService.exportAllData();
      expect(result, isA<Success<String>>());

      final json = (result as Success<String>).data;
      final decoded = jsonDecode(json) as Map<String, dynamic>;

      // Verify progress.
      final progressMap = decoded['progress'] as Map<String, dynamic>;
      expect(progressMap['currentRank'], 'kyu7');
      expect(progressMap['completedTechniques'], {
        'mae_geri': true,
        'seiken_tsuki': false,
      });

      // Verify advancements.
      final advancementsList = decoded['advancements'] as List;
      expect(advancementsList, hasLength(1));
      expect(advancementsList[0]['fromRank'], 'kyu10');
      expect(advancementsList[0]['toRank'], 'kyu9');
      expect(advancementsList[0]['notes'], 'First grading');

      // Verify sessions.
      final sessionsList = decoded['sessions'] as List;
      expect(sessionsList, hasLength(1));
      expect(sessionsList[0]['durationSeconds'], 5400);
      expect(sessionsList[0]['notes'], 'Kata focus');

      // Verify card states.
      final cardStatesList = decoded['cardStates'] as List;
      expect(cardStatesList, hasLength(1));
      expect(cardStatesList[0]['cardId'], 'card_001');
      expect(cardStatesList[0]['easeFactor'], 2.6);
      expect(cardStatesList[0]['interval'], 5);

      // Verify quiz attempts.
      final quizList = decoded['quizAttempts'] as List;
      expect(quizList, hasLength(1));
      expect(quizList[0]['targetRank'], 'kyu9');
      expect(quizList[0]['isMockExam'], true);
      expect(quizList[0]['totalQuestions'], 20);
      expect(quizList[0]['correctAnswers'], 18);
      expect(quizList[0]['categoryScores']['terminology'], 0.9);
      expect(quizList[0]['weakAreas'], ['kata_sequences']);
    });
  });

  group('ExportService - importData', () {
    test('import valid JSON succeeds with correct counts', () async {
      final json = jsonEncode({
        'version': 1,
        'exportDate': DateTime.now().toUtc().toIso8601String(),
        'appVersion': '1.0.0',
        'progress': {
          'currentRank': 'kyu5',
          'startDate': DateTime(2023, 6, 1).toUtc().toIso8601String(),
          'completedTechniques': {'technique_a': true},
        },
        'advancements': [
          {
            'fromRank': 'kyu10',
            'toRank': 'kyu9',
            'date': DateTime(2023, 9, 1).toUtc().toIso8601String(),
            'notes': 'Passed',
          },
          {
            'fromRank': 'kyu9',
            'toRank': 'kyu8',
            'date': DateTime(2024, 1, 1).toUtc().toIso8601String(),
            'notes': null,
          },
        ],
        'sessions': [
          {
            'date': DateTime(2024, 2, 1).toUtc().toIso8601String(),
            'durationMinutes': 60,
            'notes': 'Basics',
          },
        ],
        'cardStates': [
          {
            'cardId': 'card_a',
            'easeFactor': 2.5,
            'interval': 3,
            'repetitions': 2,
            'nextReviewDate': DateTime(2024, 3, 1).toUtc().toIso8601String(),
            'lastReviewDate': DateTime(2024, 2, 26).toUtc().toIso8601String(),
            'totalReviews': 5,
            'correctReviews': 4,
          },
          {
            'cardId': 'card_b',
            'easeFactor': 1.5,
            'interval': 1,
            'repetitions': 1,
            'nextReviewDate': DateTime(2024, 3, 2).toUtc().toIso8601String(),
            'lastReviewDate': DateTime(2024, 3, 1).toUtc().toIso8601String(),
            'totalReviews': 3,
            'correctReviews': 1,
          },
        ],
        'quizAttempts': [
          {
            'timestamp': DateTime(2024, 2, 15).toUtc().toIso8601String(),
            'targetRank': 'kyu8',
            'isMockExam': false,
            'totalQuestions': 10,
            'correctAnswers': 7,
            'durationSeconds': 300,
            'categoryScores': {'terminology': 0.8},
            'weakAreas': ['blocks'],
          },
        ],
      });

      final result = await exportService.importData(json);
      expect(result, isA<Success<ImportSummary>>());

      final summary = (result as Success<ImportSummary>).data;
      expect(summary.progressRestored, isTrue);
      expect(summary.advancementsCount, 2);
      expect(summary.sessionsCount, 1);
      expect(summary.cardStatesCount, 2);
      expect(summary.quizAttemptsCount, 1);
      expect(summary.warnings, isEmpty);

      // Verify data was actually persisted.
      final progressResult = await db.progressDao.getProgress();
      final progress = (progressResult as Success<UserProgress?>).data!;
      expect(progress.currentRank, BeltRank.kyu5);

      final advancementsResult = await db.progressDao.getAdvancementHistory();
      final advancements =
          (advancementsResult as Success<List<BeltAdvancement>>).data;
      expect(advancements, hasLength(2));

      final cardStatesResult = await db.reviewDao.getAllReviewStates();
      final cardStates =
          (cardStatesResult as Success<List<CardReviewState>>).data;
      expect(cardStates, hasLength(2));
    });

    test('import invalid JSON returns Failure', () async {
      final result = await exportService.importData('not valid json{{{');
      expect(result, isA<Failure<ImportSummary>>());
      expect((result as Failure<ImportSummary>).message, 'Invalid JSON format');
    });

    test('import non-object JSON returns Failure', () async {
      final result = await exportService.importData('"just a string"');
      expect(result, isA<Failure<ImportSummary>>());
      expect(
        (result as Failure<ImportSummary>).message,
        contains('expected JSON object'),
      );
    });

    test('import wrong version returns Failure', () async {
      final json = jsonEncode({
        'version': 999,
        'exportDate': DateTime.now().toUtc().toIso8601String(),
        'appVersion': '99.0.0',
        'progress': null,
        'advancements': <dynamic>[],
        'sessions': <dynamic>[],
        'cardStates': <dynamic>[],
        'quizAttempts': <dynamic>[],
      });

      final result = await exportService.importData(json);
      expect(result, isA<Failure<ImportSummary>>());
      expect(
        (result as Failure<ImportSummary>).message,
        contains('version 999 is not supported'),
      );
    });

    test('import missing version returns Failure', () async {
      final json = jsonEncode({
        'exportDate': DateTime.now().toUtc().toIso8601String(),
        'appVersion': '1.0.0',
        'progress': null,
        'advancements': <dynamic>[],
        'sessions': <dynamic>[],
        'cardStates': <dynamic>[],
        'quizAttempts': <dynamic>[],
      });

      final result = await exportService.importData(json);
      expect(result, isA<Failure<ImportSummary>>());
      expect(
        (result as Failure<ImportSummary>).message,
        contains('missing or invalid version'),
      );
    });

    test('import invalid belt rank returns Failure', () async {
      final json = jsonEncode({
        'version': 1,
        'exportDate': DateTime.now().toUtc().toIso8601String(),
        'appVersion': '1.0.0',
        'progress': {
          'currentRank': 'invalid_rank',
          'startDate': DateTime(2024, 1, 1).toUtc().toIso8601String(),
          'completedTechniques': <String, dynamic>{},
        },
        'advancements': <dynamic>[],
        'sessions': <dynamic>[],
        'cardStates': <dynamic>[],
        'quizAttempts': <dynamic>[],
      });

      final result = await exportService.importData(json);
      expect(result, isA<Failure<ImportSummary>>());
      expect(
        (result as Failure<ImportSummary>).message,
        contains('unknown belt rank'),
      );
    });

    test('import future dates produces warnings', () async {
      final futureDate = DateTime.now()
          .add(const Duration(days: 30))
          .toUtc()
          .toIso8601String();

      final json = jsonEncode({
        'version': 1,
        'exportDate': DateTime.now().toUtc().toIso8601String(),
        'appVersion': '1.0.0',
        'progress': {
          'currentRank': 'kyu10',
          'startDate': futureDate,
          'completedTechniques': <String, dynamic>{},
        },
        'advancements': [
          {
            'fromRank': 'kyu10',
            'toRank': 'kyu9',
            'date': futureDate,
            'notes': null,
          },
        ],
        'sessions': [
          {'date': futureDate, 'durationMinutes': 60, 'notes': null},
        ],
        'cardStates': <dynamic>[],
        'quizAttempts': [
          {
            'timestamp': futureDate,
            'targetRank': 'kyu9',
            'isMockExam': false,
            'totalQuestions': 5,
            'correctAnswers': 3,
            'durationSeconds': 120,
            'categoryScores': <String, dynamic>{},
            'weakAreas': <String>[],
          },
        ],
      });

      final result = await exportService.importData(json);
      expect(result, isA<Success<ImportSummary>>());

      final summary = (result as Success<ImportSummary>).data;
      expect(summary.warnings, isNotEmpty);
      expect(summary.warnings.length, greaterThanOrEqualTo(3));
      expect(summary.warnings.any((w) => w.contains('future')), isTrue);
    });

    test('import with empty arrays succeeds', () async {
      final json = jsonEncode({
        'version': 1,
        'exportDate': DateTime.now().toUtc().toIso8601String(),
        'appVersion': '1.0.0',
        'progress': null,
        'advancements': <dynamic>[],
        'sessions': <dynamic>[],
        'cardStates': <dynamic>[],
        'quizAttempts': <dynamic>[],
      });

      final result = await exportService.importData(json);
      expect(result, isA<Success<ImportSummary>>());

      final summary = (result as Success<ImportSummary>).data;
      expect(summary.progressRestored, isFalse);
      expect(summary.advancementsCount, 0);
      expect(summary.sessionsCount, 0);
      expect(summary.cardStatesCount, 0);
      expect(summary.quizAttemptsCount, 0);
      expect(summary.totalRecords, 0);
    });

    test('import overwrites existing data', () async {
      // Pre-seed some data.
      await db.progressDao.saveProgress(
        UserProgress(
          currentRank: BeltRank.kyu10,
          completedTechniques: {'old_technique': true},
          advancementHistory: const [],
          trainingLog: const [],
          startDate: DateTime(2020, 1, 1),
        ),
      );

      // Import different data.
      final json = jsonEncode({
        'version': 1,
        'exportDate': DateTime.now().toUtc().toIso8601String(),
        'appVersion': '1.0.0',
        'progress': {
          'currentRank': 'kyu3',
          'startDate': DateTime(2022, 1, 1).toUtc().toIso8601String(),
          'completedTechniques': {'new_technique': true},
        },
        'advancements': <dynamic>[],
        'sessions': <dynamic>[],
        'cardStates': <dynamic>[],
        'quizAttempts': <dynamic>[],
      });

      final result = await exportService.importData(json);
      expect(result, isA<Success<ImportSummary>>());

      // Verify the old data was replaced.
      final progressResult = await db.progressDao.getProgress();
      final progress = (progressResult as Success<UserProgress?>).data!;
      expect(progress.currentRank, BeltRank.kyu3);
      expect(progress.completedTechniques, {'new_technique': true});
      expect(
        progress.completedTechniques.containsKey('old_technique'),
        isFalse,
      );
    });

    test('import clamps invalid ease factor to minimum 1.3', () async {
      final json = jsonEncode({
        'version': 1,
        'exportDate': DateTime.now().toUtc().toIso8601String(),
        'appVersion': '1.0.0',
        'progress': null,
        'advancements': <dynamic>[],
        'sessions': <dynamic>[],
        'cardStates': [
          {
            'cardId': 'low_ease',
            'easeFactor': 0.5,
            'interval': 1,
            'repetitions': 1,
            'nextReviewDate': DateTime(2024, 3, 1).toUtc().toIso8601String(),
            'lastReviewDate': DateTime(2024, 2, 28).toUtc().toIso8601String(),
            'totalReviews': 1,
            'correctReviews': 0,
          },
        ],
        'quizAttempts': <dynamic>[],
      });

      final result = await exportService.importData(json);
      expect(result, isA<Success<ImportSummary>>());

      final cardStatesResult = await db.reviewDao.getAllReviewStates();
      final cardStates =
          (cardStatesResult as Success<List<CardReviewState>>).data;
      expect(cardStates, hasLength(1));
      expect(cardStates[0].easeFactor, 1.3);
    });
  });

  group('ExportService - round-trip', () {
    test('export then import then export produces equivalent data', () async {
      // Seed comprehensive data.
      await db.progressDao.saveProgress(
        UserProgress(
          currentRank: BeltRank.kyu5,
          completedTechniques: {
            'mae_geri': true,
            'mawashi_geri': true,
            'ushiro_geri': false,
          },
          advancementHistory: const [],
          trainingLog: const [],
          startDate: DateTime(2023, 1, 1),
        ),
      );

      await db.progressDao.addBeltAdvancement(
        BeltAdvancement(
          fromRank: BeltRank.kyu10,
          toRank: BeltRank.kyu9,
          date: DateTime(2023, 3, 1),
          notes: 'First grading',
        ),
      );
      await db.progressDao.addBeltAdvancement(
        BeltAdvancement(
          fromRank: BeltRank.kyu9,
          toRank: BeltRank.kyu8,
          date: DateTime(2023, 6, 1),
        ),
      );

      await db.progressDao.addTrainingSession(
        TrainingSession(
          date: DateTime(2024, 1, 10),
          duration: const Duration(minutes: 120),
          notes: 'Sparring',
        ),
      );

      await db.reviewDao.saveReviewState(
        CardReviewState(
          cardId: 'card_rt_1',
          easeFactor: 2.8,
          interval: 10,
          repetitions: 5,
          nextReviewDate: DateTime(2024, 4, 1),
          lastReviewDate: DateTime(2024, 3, 22),
          totalReviews: 20,
          correctReviews: 18,
        ),
      );

      await db.quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: DateTime(2024, 2, 1),
          targetRank: BeltRank.kyu7,
          isMockExam: true,
          totalQuestions: 25,
          correctAnswers: 22,
          duration: const Duration(minutes: 12),
          categoryScores: {'terminology': 0.92, 'kata': 0.80},
          weakAreas: ['blocks'],
        ),
      );

      // First export.
      final export1Result = await exportService.exportAllData();
      expect(export1Result, isA<Success<String>>());
      final export1Json = (export1Result as Success<String>).data;

      // Parse the first export to compare later.
      final export1Data = jsonDecode(export1Json) as Map<String, dynamic>;

      // Import into a fresh DB (simulating a new device).
      final db2 = AppDatabase(NativeDatabase.memory());
      final exportService2 = ExportService(db2);

      final importResult = await exportService2.importData(export1Json);
      expect(importResult, isA<Success<ImportSummary>>());

      final summary = (importResult as Success<ImportSummary>).data;
      expect(summary.progressRestored, isTrue);
      expect(summary.advancementsCount, 2);
      expect(summary.sessionsCount, 1);
      expect(summary.cardStatesCount, 1);
      expect(summary.quizAttemptsCount, 1);

      // Second export from the imported DB.
      final export2Result = await exportService2.exportAllData();
      expect(export2Result, isA<Success<String>>());
      final export2Json = (export2Result as Success<String>).data;
      final export2Data = jsonDecode(export2Json) as Map<String, dynamic>;

      // Compare data fields (ignoring exportDate which will differ).
      expect(export2Data['version'], export1Data['version']);
      expect(export2Data['appVersion'], export1Data['appVersion']);

      // Progress should be equivalent.
      expect(
        export2Data['progress']?['currentRank'],
        export1Data['progress']?['currentRank'],
      );
      expect(
        export2Data['progress']?['completedTechniques'],
        export1Data['progress']?['completedTechniques'],
      );

      // Advancements should match.
      expect(
        (export2Data['advancements'] as List).length,
        (export1Data['advancements'] as List).length,
      );
      for (var i = 0; i < (export1Data['advancements'] as List).length; i++) {
        final a1 = (export1Data['advancements'] as List)[i];
        final a2 = (export2Data['advancements'] as List)[i];
        expect(a2['fromRank'], a1['fromRank']);
        expect(a2['toRank'], a1['toRank']);
        expect(a2['notes'], a1['notes']);
      }

      // Sessions should match.
      expect(
        (export2Data['sessions'] as List).length,
        (export1Data['sessions'] as List).length,
      );

      // Card states should match.
      expect(
        (export2Data['cardStates'] as List).length,
        (export1Data['cardStates'] as List).length,
      );
      final cs1 = (export1Data['cardStates'] as List)[0];
      final cs2 = (export2Data['cardStates'] as List)[0];
      expect(cs2['cardId'], cs1['cardId']);
      expect(cs2['easeFactor'], cs1['easeFactor']);
      expect(cs2['interval'], cs1['interval']);

      // Quiz attempts should match.
      expect(
        (export2Data['quizAttempts'] as List).length,
        (export1Data['quizAttempts'] as List).length,
      );
      final qa1 = (export1Data['quizAttempts'] as List)[0];
      final qa2 = (export2Data['quizAttempts'] as List)[0];
      expect(qa2['targetRank'], qa1['targetRank']);
      expect(qa2['totalQuestions'], qa1['totalQuestions']);
      expect(qa2['correctAnswers'], qa1['correctAnswers']);

      await db2.close();
    });
  });

  group('ImportSummary', () {
    test('totalRecords sums all counts', () {
      const summary = ImportSummary(
        progressRestored: true,
        advancementsCount: 3,
        sessionsCount: 10,
        cardStatesCount: 50,
        quizAttemptsCount: 5,
      );
      expect(summary.totalRecords, 68);
    });

    test('equality works correctly', () {
      const a = ImportSummary(
        progressRestored: true,
        advancementsCount: 1,
        sessionsCount: 2,
        cardStatesCount: 3,
        quizAttemptsCount: 4,
      );
      const b = ImportSummary(
        progressRestored: true,
        advancementsCount: 1,
        sessionsCount: 2,
        cardStatesCount: 3,
        quizAttemptsCount: 4,
        warnings: ['some warning'],
      );
      // Equality ignores warnings — checks structural counts.
      expect(a, equals(b));
    });

    test('toString is readable', () {
      const summary = ImportSummary(
        progressRestored: false,
        advancementsCount: 0,
        sessionsCount: 0,
        cardStatesCount: 0,
        quizAttemptsCount: 0,
      );
      expect(summary.toString(), contains('progress=false'));
    });
  });
}
