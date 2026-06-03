import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/database/daos/progress_dao.dart';
import 'package:docklands_dojo/database/daos/quiz_dao.dart';
import 'package:docklands_dojo/database/daos/review_dao.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/user_progress.dart';
import 'package:docklands_dojo/result.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ProgressDao progressDao;
  late ReviewDao reviewDao;
  late QuizDao quizDao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    progressDao = db.progressDao;
    reviewDao = db.reviewDao;
    quizDao = db.quizDao;
  });

  tearDown(() async {
    await db.close();
  });

  group('UserProgressTable', () {
    test('returns null when no progress exists', () async {
      final result = await progressDao.getProgress();
      expect(result, isA<Success<UserProgress?>>());
      final data = (result as Success<UserProgress?>).data;
      expect(data, isNull);
    });

    test('saves and retrieves progress', () async {
      final progress = UserProgress(
        currentRank: BeltRank.kyu10,
        completedTechniques: const {'seiken_chudan_tsuki': true},
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024, 1, 15),
      );

      final saveResult = await progressDao.saveProgress(progress);
      expect(saveResult, isA<Success<void>>());

      final loadResult = await progressDao.getProgress();
      expect(loadResult, isA<Success<UserProgress?>>());
      final loaded = (loadResult as Success<UserProgress?>).data;

      expect(loaded, isNotNull);
      expect(loaded!.currentRank, BeltRank.kyu10);
      expect(loaded.completedTechniques['seiken_chudan_tsuki'], true);
      expect(loaded.startDate, DateTime(2024, 1, 15));
    });

    test('updates existing progress', () async {
      final initial = UserProgress(
        currentRank: BeltRank.kyu10,
        completedTechniques: const {},
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024, 1, 15),
      );
      await progressDao.saveProgress(initial);

      final updated = UserProgress(
        currentRank: BeltRank.kyu9,
        completedTechniques: const {
          'seiken_chudan_tsuki': true,
          'mae_geri': true,
        },
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024, 1, 15),
      );
      await progressDao.saveProgress(updated);

      final result = await progressDao.getProgress();
      final loaded = (result as Success<UserProgress?>).data!;

      expect(loaded.currentRank, BeltRank.kyu9);
      expect(loaded.completedTechniques.length, 2);
    });

    test('preserves all belt ranks through save/load cycle', () async {
      for (final rank in BeltRank.values) {
        final progress = UserProgress(
          currentRank: rank,
          completedTechniques: const {},
          advancementHistory: const [],
          trainingLog: const [],
          startDate: DateTime(2024, 1, 1),
        );
        await progressDao.saveProgress(progress);
        final result = await progressDao.getProgress();
        final loaded = (result as Success<UserProgress?>).data!;
        expect(loaded.currentRank, rank);
      }
    });
  });

  group('BeltAdvancementTable', () {
    test('returns empty list when no advancements exist', () async {
      final result = await progressDao.getAdvancementHistory();
      expect(result, isA<Success<List<BeltAdvancement>>>());
      final data = (result as Success<List<BeltAdvancement>>).data;
      expect(data, isEmpty);
    });

    test('adds and retrieves advancement', () async {
      final advancement = BeltAdvancement(
        fromRank: BeltRank.kyu10,
        toRank: BeltRank.kyu9,
        date: DateTime(2024, 6, 15),
        notes: 'Passed first grading',
      );

      final addResult = await progressDao.addBeltAdvancement(advancement);
      expect(addResult, isA<Success<void>>());

      final loadResult = await progressDao.getAdvancementHistory();
      final history = (loadResult as Success<List<BeltAdvancement>>).data;

      expect(history.length, 1);
      expect(history.first.fromRank, BeltRank.kyu10);
      expect(history.first.toRank, BeltRank.kyu9);
      expect(history.first.notes, 'Passed first grading');
    });

    test('returns advancements ordered by date ascending', () async {
      await progressDao.addBeltAdvancement(
        BeltAdvancement(
          fromRank: BeltRank.kyu9,
          toRank: BeltRank.kyu8,
          date: DateTime(2024, 12, 15),
        ),
      );
      await progressDao.addBeltAdvancement(
        BeltAdvancement(
          fromRank: BeltRank.kyu10,
          toRank: BeltRank.kyu9,
          date: DateTime(2024, 6, 15),
        ),
      );

      final result = await progressDao.getAdvancementHistory();
      final history = (result as Success<List<BeltAdvancement>>).data;

      expect(history.length, 2);
      expect(history[0].fromRank, BeltRank.kyu10); // earlier date first
      expect(history[1].fromRank, BeltRank.kyu9);
    });

    test('handles null notes', () async {
      await progressDao.addBeltAdvancement(
        BeltAdvancement(
          fromRank: BeltRank.kyu10,
          toRank: BeltRank.kyu9,
          date: DateTime(2024, 6, 15),
        ),
      );

      final result = await progressDao.getAdvancementHistory();
      final history = (result as Success<List<BeltAdvancement>>).data;

      expect(history.first.notes, isNull);
    });
  });

  group('TrainingSessionTable', () {
    test('returns empty list when no sessions exist', () async {
      final result = await progressDao.getTrainingSessions();
      expect(result, isA<Success<List<TrainingSession>>>());
      final data = (result as Success<List<TrainingSession>>).data;
      expect(data, isEmpty);
    });

    test('adds and retrieves sessions', () async {
      final session = TrainingSession(
        date: DateTime(2024, 6, 10),
        duration: const Duration(minutes: 90),
        notes: 'Focused on kata',
      );

      final addResult = await progressDao.addTrainingSession(session);
      expect(addResult, isA<Success<void>>());

      final loadResult = await progressDao.getTrainingSessions();
      final sessions = (loadResult as Success<List<TrainingSession>>).data;

      expect(sessions.length, 1);
      expect(sessions.first.duration.inMinutes, 90);
      expect(sessions.first.notes, 'Focused on kata');
    });

    test('returns sessions ordered by date descending', () async {
      await progressDao.addTrainingSession(
        TrainingSession(
          date: DateTime(2024, 6, 10),
          duration: const Duration(minutes: 60),
        ),
      );
      await progressDao.addTrainingSession(
        TrainingSession(
          date: DateTime(2024, 6, 15),
          duration: const Duration(minutes: 90),
        ),
      );

      final result = await progressDao.getTrainingSessions();
      final sessions = (result as Success<List<TrainingSession>>).data;

      expect(sessions.length, 2);
      // Most recent first
      expect(sessions[0].duration.inMinutes, 90);
      expect(sessions[1].duration.inMinutes, 60);
    });
  });

  group('CardReviewStateTable', () {
    test('returns null for non-existent card', () async {
      final result = await reviewDao.getReviewState('nonexistent');
      expect(result, isA<Success<CardReviewState?>>());
      final data = (result as Success<CardReviewState?>).data;
      expect(data, isNull);
    });

    test('saves and retrieves review state', () async {
      final now = DateTime(2024, 6, 15);
      final state = CardReviewState(
        cardId: 'card_001',
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
        nextReviewDate: now.add(const Duration(days: 6)),
        lastReviewDate: now,
        totalReviews: 3,
        correctReviews: 2,
      );

      final saveResult = await reviewDao.saveReviewState(state);
      expect(saveResult, isA<Success<void>>());

      final loadResult = await reviewDao.getReviewState('card_001');
      final loaded = (loadResult as Success<CardReviewState?>).data!;

      expect(loaded.cardId, 'card_001');
      expect(loaded.easeFactor, 2.5);
      expect(loaded.interval, 6);
      expect(loaded.repetitions, 2);
      expect(loaded.totalReviews, 3);
      expect(loaded.correctReviews, 2);
    });

    test('upserts existing review state', () async {
      final now = DateTime(2024, 6, 15);
      final initial = CardReviewState(
        cardId: 'card_001',
        easeFactor: 2.5,
        interval: 1,
        repetitions: 1,
        nextReviewDate: now.add(const Duration(days: 1)),
        lastReviewDate: now,
        totalReviews: 1,
        correctReviews: 1,
      );
      await reviewDao.saveReviewState(initial);

      final updated = CardReviewState(
        cardId: 'card_001',
        easeFactor: 2.6,
        interval: 6,
        repetitions: 2,
        nextReviewDate: now.add(const Duration(days: 6)),
        lastReviewDate: now.add(const Duration(days: 1)),
        totalReviews: 2,
        correctReviews: 2,
      );
      await reviewDao.saveReviewState(updated);

      final result = await reviewDao.getReviewState('card_001');
      final loaded = (result as Success<CardReviewState?>).data!;

      expect(loaded.easeFactor, 2.6);
      expect(loaded.interval, 6);
      expect(loaded.totalReviews, 2);
    });

    test('getAllReviewStates returns all states', () async {
      final now = DateTime(2024, 6, 15);
      for (final id in ['card_001', 'card_002', 'card_003']) {
        await reviewDao.saveReviewState(
          CardReviewState(
            cardId: id,
            easeFactor: 2.5,
            interval: 1,
            repetitions: 0,
            nextReviewDate: now,
            lastReviewDate: now,
            totalReviews: 0,
            correctReviews: 0,
          ),
        );
      }

      final result = await reviewDao.getAllReviewStates();
      final states = (result as Success<List<CardReviewState>>).data;
      expect(states.length, 3);
    });

    test('getDueCards returns only overdue cards', () async {
      final now = DateTime(2024, 6, 15);

      // Due card (past)
      await reviewDao.saveReviewState(
        CardReviewState(
          cardId: 'due_card',
          easeFactor: 2.5,
          interval: 1,
          repetitions: 1,
          nextReviewDate: now.subtract(const Duration(days: 1)),
          lastReviewDate: now.subtract(const Duration(days: 2)),
          totalReviews: 1,
          correctReviews: 1,
        ),
      );

      // Not due card (future)
      await reviewDao.saveReviewState(
        CardReviewState(
          cardId: 'future_card',
          easeFactor: 2.5,
          interval: 10,
          repetitions: 3,
          nextReviewDate: now.add(const Duration(days: 5)),
          lastReviewDate: now.subtract(const Duration(days: 5)),
          totalReviews: 3,
          correctReviews: 3,
        ),
      );

      // Exactly due (now)
      await reviewDao.saveReviewState(
        CardReviewState(
          cardId: 'now_card',
          easeFactor: 2.5,
          interval: 1,
          repetitions: 1,
          nextReviewDate: now,
          lastReviewDate: now.subtract(const Duration(days: 1)),
          totalReviews: 1,
          correctReviews: 1,
        ),
      );

      final result = await reviewDao.getDueCards(now);
      final dueCards = (result as Success<List<CardReviewState>>).data;

      expect(dueCards.length, 2);
      expect(
        dueCards.map((c) => c.cardId),
        containsAll(['due_card', 'now_card']),
      );
      expect(dueCards.map((c) => c.cardId), isNot(contains('future_card')));
    });

    test('getDueCards ordered by most overdue first', () async {
      final now = DateTime(2024, 6, 15);

      await reviewDao.saveReviewState(
        CardReviewState(
          cardId: 'slightly_overdue',
          easeFactor: 2.5,
          interval: 1,
          repetitions: 1,
          nextReviewDate: now.subtract(const Duration(days: 1)),
          lastReviewDate: now.subtract(const Duration(days: 2)),
          totalReviews: 1,
          correctReviews: 1,
        ),
      );

      await reviewDao.saveReviewState(
        CardReviewState(
          cardId: 'very_overdue',
          easeFactor: 2.5,
          interval: 1,
          repetitions: 1,
          nextReviewDate: now.subtract(const Duration(days: 7)),
          lastReviewDate: now.subtract(const Duration(days: 8)),
          totalReviews: 1,
          correctReviews: 1,
        ),
      );

      final result = await reviewDao.getDueCards(now);
      final dueCards = (result as Success<List<CardReviewState>>).data;

      expect(dueCards.length, 2);
      expect(dueCards[0].cardId, 'very_overdue');
      expect(dueCards[1].cardId, 'slightly_overdue');
    });
  });

  group('ReviewSessionTable', () {
    test('adds and retrieves review session', () async {
      final session = ReviewSession(
        timestamp: DateTime(2024, 6, 15, 10, 30),
        cardsReviewed: 20,
        correctCount: 15,
        duration: const Duration(minutes: 10),
      );

      final addResult = await reviewDao.addReviewSession(session);
      expect(addResult, isA<Success<void>>());

      final loadResult = await reviewDao.getReviewSessions();
      final sessions = (loadResult as Success<List<ReviewSession>>).data;

      expect(sessions.length, 1);
      expect(sessions.first.cardsReviewed, 20);
      expect(sessions.first.correctCount, 15);
      expect(sessions.first.duration.inSeconds, 600);
    });

    test('returns sessions ordered by most recent first', () async {
      await reviewDao.addReviewSession(
        ReviewSession(
          timestamp: DateTime(2024, 6, 10),
          cardsReviewed: 10,
          correctCount: 8,
          duration: const Duration(minutes: 5),
        ),
      );
      await reviewDao.addReviewSession(
        ReviewSession(
          timestamp: DateTime(2024, 6, 15),
          cardsReviewed: 20,
          correctCount: 18,
          duration: const Duration(minutes: 10),
        ),
      );

      final result = await reviewDao.getReviewSessions();
      final sessions = (result as Success<List<ReviewSession>>).data;

      expect(sessions[0].cardsReviewed, 20); // most recent first
      expect(sessions[1].cardsReviewed, 10);
    });
  });

  group('QuizAttemptTable', () {
    test('adds and retrieves quiz attempt', () async {
      final attempt = QuizAttemptData(
        timestamp: DateTime(2024, 6, 15),
        targetRank: BeltRank.kyu9,
        isMockExam: false,
        totalQuestions: 20,
        correctAnswers: 16,
        duration: const Duration(minutes: 15),
        categoryScores: const {'terminology': 0.85, 'kihon': 0.92},
        weakAreas: const ['kata_sequences'],
      );

      final addResult = await quizDao.addQuizAttempt(attempt);
      expect(addResult, isA<Success<void>>());

      final loadResult = await quizDao.getQuizHistory();
      final history = (loadResult as Success<List<QuizAttemptData>>).data;

      expect(history.length, 1);
      expect(history.first.targetRank, BeltRank.kyu9);
      expect(history.first.totalQuestions, 20);
      expect(history.first.correctAnswers, 16);
      expect(history.first.categoryScores['terminology'], 0.85);
      expect(history.first.weakAreas, ['kata_sequences']);
    });

    test('filters quiz history by target rank', () async {
      await quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: DateTime(2024, 6, 10),
          targetRank: BeltRank.kyu9,
          isMockExam: false,
          totalQuestions: 10,
          correctAnswers: 8,
          duration: const Duration(minutes: 10),
          categoryScores: const {},
          weakAreas: const [],
        ),
      );
      await quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: DateTime(2024, 6, 15),
          targetRank: BeltRank.kyu8,
          isMockExam: false,
          totalQuestions: 15,
          correctAnswers: 12,
          duration: const Duration(minutes: 12),
          categoryScores: const {},
          weakAreas: const [],
        ),
      );

      final result = await quizDao.getQuizHistory(targetRank: BeltRank.kyu9);
      final history = (result as Success<List<QuizAttemptData>>).data;

      expect(history.length, 1);
      expect(history.first.targetRank, BeltRank.kyu9);
    });

    test('getAverageScoreByCategory computes averages', () async {
      await quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: DateTime(2024, 6, 10),
          targetRank: BeltRank.kyu9,
          isMockExam: false,
          totalQuestions: 10,
          correctAnswers: 8,
          duration: const Duration(minutes: 10),
          categoryScores: const {'terminology': 0.8, 'kihon': 0.9},
          weakAreas: const [],
        ),
      );
      await quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: DateTime(2024, 6, 15),
          targetRank: BeltRank.kyu9,
          isMockExam: false,
          totalQuestions: 10,
          correctAnswers: 9,
          duration: const Duration(minutes: 8),
          categoryScores: const {'terminology': 1.0, 'kihon': 0.7},
          weakAreas: const [],
        ),
      );

      final result = await quizDao.getAverageScoreByCategory();
      final averages = (result as Success<Map<String, double>>).data;

      expect(averages['terminology'], closeTo(0.9, 0.001));
      expect(averages['kihon'], closeTo(0.8, 0.001));
    });

    test('getAverageScoreByCategory returns empty map with no data', () async {
      final result = await quizDao.getAverageScoreByCategory();
      final averages = (result as Success<Map<String, double>>).data;
      expect(averages, isEmpty);
    });

    test('getMockExamPassCount counts passing mock exams', () async {
      // Passing mock exam (80%)
      await quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: DateTime(2024, 6, 10),
          targetRank: BeltRank.kyu9,
          isMockExam: true,
          totalQuestions: 20,
          correctAnswers: 16,
          duration: const Duration(minutes: 20),
          categoryScores: const {},
          weakAreas: const [],
        ),
      );

      // Failing mock exam (75%)
      await quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: DateTime(2024, 6, 12),
          targetRank: BeltRank.kyu9,
          isMockExam: true,
          totalQuestions: 20,
          correctAnswers: 15,
          duration: const Duration(minutes: 18),
          categoryScores: const {},
          weakAreas: const [],
        ),
      );

      // Passing but not mock exam
      await quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: DateTime(2024, 6, 14),
          targetRank: BeltRank.kyu9,
          isMockExam: false,
          totalQuestions: 20,
          correctAnswers: 20,
          duration: const Duration(minutes: 15),
          categoryScores: const {},
          weakAreas: const [],
        ),
      );

      // Passing mock but different rank
      await quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: DateTime(2024, 6, 16),
          targetRank: BeltRank.kyu8,
          isMockExam: true,
          totalQuestions: 20,
          correctAnswers: 18,
          duration: const Duration(minutes: 25),
          categoryScores: const {},
          weakAreas: const [],
        ),
      );

      final result = await quizDao.getMockExamPassCount(BeltRank.kyu9);
      final count = (result as Success<int>).data;

      expect(count, 1); // Only one passing mock for kyu9
    });

    test('getMockExamPassCount returns 0 with no data', () async {
      final result = await quizDao.getMockExamPassCount(BeltRank.kyu9);
      final count = (result as Success<int>).data;
      expect(count, 0);
    });

    test('quiz history returns newest first', () async {
      await quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: DateTime(2024, 6, 10),
          targetRank: BeltRank.kyu9,
          isMockExam: false,
          totalQuestions: 10,
          correctAnswers: 5,
          duration: const Duration(minutes: 5),
          categoryScores: const {},
          weakAreas: const [],
        ),
      );
      await quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: DateTime(2024, 6, 15),
          targetRank: BeltRank.kyu9,
          isMockExam: false,
          totalQuestions: 10,
          correctAnswers: 10,
          duration: const Duration(minutes: 8),
          categoryScores: const {},
          weakAreas: const [],
        ),
      );

      final result = await quizDao.getQuizHistory();
      final history = (result as Success<List<QuizAttemptData>>).data;

      expect(history[0].correctAnswers, 10); // most recent first
      expect(history[1].correctAnswers, 5);
    });
  });

  group('Cross-table integration', () {
    test('all tables work independently', () async {
      // Save progress
      await progressDao.saveProgress(
        UserProgress(
          currentRank: BeltRank.kyu10,
          completedTechniques: const {},
          advancementHistory: const [],
          trainingLog: const [],
          startDate: DateTime(2024, 1, 1),
        ),
      );

      // Add review state
      final now = DateTime(2024, 6, 15);
      await reviewDao.saveReviewState(
        CardReviewState(
          cardId: 'card_001',
          easeFactor: 2.5,
          interval: 1,
          repetitions: 0,
          nextReviewDate: now,
          lastReviewDate: now,
          totalReviews: 0,
          correctReviews: 0,
        ),
      );

      // Add quiz attempt
      await quizDao.addQuizAttempt(
        QuizAttemptData(
          timestamp: now,
          targetRank: BeltRank.kyu9,
          isMockExam: false,
          totalQuestions: 10,
          correctAnswers: 8,
          duration: const Duration(minutes: 10),
          categoryScores: const {},
          weakAreas: const [],
        ),
      );

      // Verify all
      final progress = await progressDao.getProgress();
      expect(progress, isA<Success<UserProgress?>>());

      final reviewStates = await reviewDao.getAllReviewStates();
      expect((reviewStates as Success<List<CardReviewState>>).data.length, 1);

      final quizHistory = await quizDao.getQuizHistory();
      expect((quizHistory as Success<List<QuizAttemptData>>).data.length, 1);
    });
  });

  group('Database lifecycle', () {
    test('data persists across DAO access', () async {
      await progressDao.saveProgress(
        UserProgress(
          currentRank: BeltRank.kyu10,
          completedTechniques: const {},
          advancementHistory: const [],
          trainingLog: const [],
          startDate: DateTime(2024, 1, 1),
        ),
      );

      // Access through a new DAO instance on the same db
      final newProgressDao = db.progressDao;
      final result = await newProgressDao.getProgress();
      expect((result as Success<UserProgress?>).data, isNotNull);
    });
  });
}
