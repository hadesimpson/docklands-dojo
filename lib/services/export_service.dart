import 'dart:convert';
import 'dart:io';

import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/database/daos/quiz_dao.dart';
import 'package:docklands_dojo/database/daos/review_dao.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/user_progress.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/services/import_summary.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Current export format version. Bump when the schema changes.
const int _currentExportVersion = 1;

/// App version embedded in exports.
const String _appVersion = '1.0.0';

/// Maximum acceptable future date tolerance (1 day from now).
const Duration _futureDateTolerance = Duration(days: 1);

/// Data portability service for JSON export/import.
///
/// Serializes all user data (progress, advancements, training sessions,
/// card review states, and quiz attempts) into a portable JSON format.
/// Supports export via the system share sheet and import from file picker.
///
/// All methods return [Result] types for error handling.
///
/// ```dart
/// final service = ExportService(db);
/// final result = await service.exportAllData();
/// switch (result) {
///   Success(:final data) => print(data), // JSON string
///   Failure(:final message) => print('Error: $message'),
/// }
/// ```
class ExportService {
  /// The Drift database instance.
  final AppDatabase _db;

  /// Creates an [ExportService] with the given [AppDatabase].
  ExportService(this._db);

  /// Exports all user data as a JSON string.
  ///
  /// Returns a [Success] containing the JSON string of the export bundle,
  /// or a [Failure] if the data cannot be serialized.
  Future<Result<String>> exportAllData() async {
    try {
      final progressDao = _db.progressDao;
      final reviewDao = _db.reviewDao;
      final quizDao = _db.quizDao;

      // Gather all data from the database.
      final progressResult = await progressDao.getProgress();
      final advancementsResult = await progressDao.getAdvancementHistory();
      final sessionsResult = await progressDao.getTrainingSessions();
      final cardStatesResult = await reviewDao.getAllReviewStates();
      final quizAttemptsResult = await quizDao.getQuizHistory();

      // Unwrap results, propagating any failures.
      if (progressResult is Failure<UserProgress?>) {
        return Failure<String>('Export failed: ${progressResult.message}');
      }
      if (advancementsResult is Failure<List<BeltAdvancement>>) {
        return Failure<String>('Export failed: ${advancementsResult.message}');
      }
      if (sessionsResult is Failure<List<TrainingSession>>) {
        return Failure<String>('Export failed: ${sessionsResult.message}');
      }
      if (cardStatesResult is Failure<List<CardReviewState>>) {
        return Failure<String>('Export failed: ${cardStatesResult.message}');
      }
      if (quizAttemptsResult is Failure<List<QuizAttemptData>>) {
        return Failure<String>('Export failed: ${quizAttemptsResult.message}');
      }

      final progress = (progressResult as Success<UserProgress?>).data;
      final advancements =
          (advancementsResult as Success<List<BeltAdvancement>>).data;
      final sessions = (sessionsResult as Success<List<TrainingSession>>).data;
      final cardStates =
          (cardStatesResult as Success<List<CardReviewState>>).data;
      final quizAttempts =
          (quizAttemptsResult as Success<List<QuizAttemptData>>).data;

      final bundle = <String, dynamic>{
        'version': _currentExportVersion,
        'exportDate': DateTime.now().toUtc().toIso8601String(),
        'appVersion': _appVersion,
        'progress': _serializeProgress(progress),
        'advancements': advancements.map(_serializeAdvancement).toList(),
        'sessions': sessions.map(_serializeSession).toList(),
        'cardStates': cardStates.map(_serializeCardState).toList(),
        'quizAttempts': quizAttempts.map(_serializeQuizAttempt).toList(),
      };

      final json = const JsonEncoder.withIndent('  ').convert(bundle);
      return Success(json);
    } catch (e) {
      return Failure('Failed to export data', e);
    }
  }

  /// Exports all data to a temporary JSON file.
  ///
  /// Returns a [Success] containing the [File], or a [Failure] on error.
  Future<Result<File>> exportToFile() async {
    try {
      final jsonResult = await exportAllData();
      if (jsonResult is Failure<String>) {
        return Failure<File>(jsonResult.message, jsonResult.error);
      }
      final json = (jsonResult as Success<String>).data;

      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/docklands_dojo_export_$timestamp.json');
      await file.writeAsString(json);

      return Success(file);
    } catch (e) {
      return Failure('Failed to write export file', e);
    }
  }

  /// Exports data and opens the system share sheet.
  ///
  /// Creates a temporary JSON file and uses [Share.shareXFiles] to present
  /// the system share sheet (Save to Files, Email, AirDrop, etc.).
  ///
  /// Returns [Success] with `void` on success, or [Failure] on error.
  Future<Result<void>> shareExport() async {
    try {
      final fileResult = await exportToFile();
      if (fileResult is Failure<File>) {
        return Failure<void>(fileResult.message, fileResult.error);
      }
      final file = (fileResult as Success<File>).data;

      await Share.shareXFiles([
        XFile(file.path),
      ], subject: 'Docklands Dojo - Progress Export');

      return const Success(null);
    } catch (e) {
      return Failure('Failed to share export', e);
    }
  }

  /// Imports user data from a JSON string.
  ///
  /// Performs full validation before importing:
  /// - Checks export format version compatibility
  /// - Validates all [BeltRank] values
  /// - Validates date ranges (not in future by >1 day)
  ///
  /// On import, **all existing data is replaced** (full overwrite).
  ///
  /// Returns [Success] with an [ImportSummary] on success,
  /// or [Failure] with a descriptive message on error.
  Future<Result<ImportSummary>> importData(String json) async {
    try {
      final dynamic decoded;
      try {
        decoded = jsonDecode(json);
      } catch (e) {
        return const Failure('Invalid JSON format');
      }

      if (decoded is! Map<String, dynamic>) {
        return const Failure('Invalid export format: expected JSON object');
      }

      // Version check.
      final version = decoded['version'];
      if (version is! int) {
        return const Failure(
          'Invalid export format: missing or invalid version',
        );
      }
      if (version > _currentExportVersion) {
        return Failure(
          'Export version $version is not supported. '
          'Please update the app (current version: $_currentExportVersion)',
        );
      }

      final warnings = <String>[];
      final now = DateTime.now();
      final futureCutoff = now.add(_futureDateTolerance);

      // Parse and validate progress.
      final progressMap = decoded['progress'] as Map<String, dynamic>?;
      UserProgress? progress;
      if (progressMap != null) {
        final parseResult = _parseProgress(progressMap, futureCutoff, warnings);
        if (parseResult is Failure<UserProgress?>) {
          return Failure(parseResult.message);
        }
        progress = (parseResult as Success<UserProgress?>).data;
      }

      // Parse and validate advancements.
      final advancementsList = decoded['advancements'] as List<dynamic>? ?? [];
      final advancements = <BeltAdvancement>[];
      for (final item in advancementsList) {
        if (item is! Map<String, dynamic>) {
          return const Failure(
            'Invalid advancement entry: expected JSON object',
          );
        }
        final parseResult = _parseAdvancement(item, futureCutoff, warnings);
        if (parseResult is Failure<BeltAdvancement>) {
          return Failure(parseResult.message);
        }
        advancements.add((parseResult as Success<BeltAdvancement>).data);
      }

      // Parse and validate sessions.
      final sessionsList = decoded['sessions'] as List<dynamic>? ?? [];
      final sessions = <TrainingSession>[];
      for (final item in sessionsList) {
        if (item is! Map<String, dynamic>) {
          return const Failure('Invalid session entry: expected JSON object');
        }
        final parseResult = _parseSession(item, futureCutoff, warnings);
        if (parseResult is Failure<TrainingSession>) {
          return Failure(parseResult.message);
        }
        sessions.add((parseResult as Success<TrainingSession>).data);
      }

      // Parse and validate card states.
      final cardStatesList = decoded['cardStates'] as List<dynamic>? ?? [];
      final cardStates = <CardReviewState>[];
      for (final item in cardStatesList) {
        if (item is! Map<String, dynamic>) {
          return const Failure(
            'Invalid card state entry: expected JSON object',
          );
        }
        final parseResult = _parseCardState(item, futureCutoff, warnings);
        if (parseResult is Failure<CardReviewState>) {
          return Failure(parseResult.message);
        }
        cardStates.add((parseResult as Success<CardReviewState>).data);
      }

      // Parse and validate quiz attempts.
      final quizAttemptsList = decoded['quizAttempts'] as List<dynamic>? ?? [];
      final quizAttempts = <QuizAttemptData>[];
      for (final item in quizAttemptsList) {
        if (item is! Map<String, dynamic>) {
          return const Failure(
            'Invalid quiz attempt entry: expected JSON object',
          );
        }
        final parseResult = _parseQuizAttempt(item, futureCutoff, warnings);
        if (parseResult is Failure<QuizAttemptData>) {
          return Failure(parseResult.message);
        }
        quizAttempts.add((parseResult as Success<QuizAttemptData>).data);
      }

      // All validation passed — perform the import (full overwrite).
      await _clearAllData();

      final progressDao = _db.progressDao;
      final reviewDao = _db.reviewDao;
      final quizDao = _db.quizDao;

      var progressRestored = false;
      if (progress != null) {
        final saveResult = await progressDao.saveProgress(progress);
        if (saveResult is Failure) {
          return Failure(
            'Import failed saving progress: ${saveResult.message}',
          );
        }
        progressRestored = true;
      }

      for (final advancement in advancements) {
        final saveResult = await progressDao.addBeltAdvancement(advancement);
        if (saveResult is Failure) {
          return Failure(
            'Import failed saving advancement: '
            '${saveResult.message}',
          );
        }
      }

      for (final session in sessions) {
        final saveResult = await progressDao.addTrainingSession(session);
        if (saveResult is Failure) {
          return Failure(
            'Import failed saving session: '
            '${saveResult.message}',
          );
        }
      }

      for (final cardState in cardStates) {
        final saveResult = await reviewDao.saveReviewState(cardState);
        if (saveResult is Failure) {
          return Failure(
            'Import failed saving card state: '
            '${saveResult.message}',
          );
        }
      }

      for (final attempt in quizAttempts) {
        final saveResult = await quizDao.addQuizAttempt(attempt);
        if (saveResult is Failure) {
          return Failure(
            'Import failed saving quiz attempt: '
            '${saveResult.message}',
          );
        }
      }

      return Success(
        ImportSummary(
          progressRestored: progressRestored,
          advancementsCount: advancements.length,
          sessionsCount: sessions.length,
          cardStatesCount: cardStates.length,
          quizAttemptsCount: quizAttempts.length,
          warnings: warnings,
        ),
      );
    } catch (e) {
      return Failure('Failed to import data', e);
    }
  }

  // ---------------------------------------------------------------------------
  // Serialization helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic>? _serializeProgress(UserProgress? progress) {
    if (progress == null) return null;
    return {
      'currentRank': progress.currentRank.name,
      'startDate': progress.startDate.toUtc().toIso8601String(),
      'completedTechniques': progress.completedTechniques,
    };
  }

  Map<String, dynamic> _serializeAdvancement(BeltAdvancement advancement) => {
    'fromRank': advancement.fromRank.name,
    'toRank': advancement.toRank.name,
    'date': advancement.date.toUtc().toIso8601String(),
    'notes': advancement.notes,
  };

  Map<String, dynamic> _serializeSession(TrainingSession session) => {
    'date': session.date.toUtc().toIso8601String(),
    'durationMinutes': session.duration.inMinutes,
    'notes': session.notes,
  };

  Map<String, dynamic> _serializeCardState(CardReviewState state) => {
    'cardId': state.cardId,
    'easeFactor': state.easeFactor,
    'interval': state.interval,
    'repetitions': state.repetitions,
    'nextReviewDate': state.nextReviewDate.toUtc().toIso8601String(),
    'lastReviewDate': state.lastReviewDate.toUtc().toIso8601String(),
    'totalReviews': state.totalReviews,
    'correctReviews': state.correctReviews,
  };

  Map<String, dynamic> _serializeQuizAttempt(QuizAttemptData attempt) => {
    'timestamp': attempt.timestamp.toUtc().toIso8601String(),
    'targetRank': attempt.targetRank.name,
    'isMockExam': attempt.isMockExam,
    'totalQuestions': attempt.totalQuestions,
    'correctAnswers': attempt.correctAnswers,
    'durationSeconds': attempt.duration.inSeconds,
    'categoryScores': attempt.categoryScores,
    'weakAreas': attempt.weakAreas,
  };

  // ---------------------------------------------------------------------------
  // Parsing / validation helpers
  // ---------------------------------------------------------------------------

  Result<UserProgress?> _parseProgress(
    Map<String, dynamic> map,
    DateTime futureCutoff,
    List<String> warnings,
  ) {
    try {
      final rankName = map['currentRank'] as String?;
      if (rankName == null) {
        return const Failure('Invalid progress: missing currentRank');
      }
      final rank = _parseBeltRank(rankName);
      if (rank == null) {
        return Failure('Invalid progress: unknown belt rank "$rankName"');
      }

      final startDateStr = map['startDate'] as String?;
      if (startDateStr == null) {
        return const Failure('Invalid progress: missing startDate');
      }
      var startDate = DateTime.parse(startDateStr);
      if (startDate.isAfter(futureCutoff)) {
        warnings.add('Progress start date is in the future, clamped to now');
        startDate = DateTime.now();
      }

      final completedRaw =
          map['completedTechniques'] as Map<String, dynamic>? ?? {};
      final completed = completedRaw.map(
        (key, value) => MapEntry(key, value == true),
      );

      return Success(
        UserProgress(
          currentRank: rank,
          completedTechniques: completed,
          advancementHistory: const [],
          trainingLog: const [],
          startDate: startDate,
        ),
      );
    } catch (e) {
      return Failure('Failed to parse progress: $e');
    }
  }

  Result<BeltAdvancement> _parseAdvancement(
    Map<String, dynamic> map,
    DateTime futureCutoff,
    List<String> warnings,
  ) {
    try {
      final fromName = map['fromRank'] as String?;
      final toName = map['toRank'] as String?;
      if (fromName == null || toName == null) {
        return const Failure('Invalid advancement: missing fromRank or toRank');
      }

      final fromRank = _parseBeltRank(fromName);
      final toRank = _parseBeltRank(toName);
      if (fromRank == null) {
        return Failure('Invalid advancement: unknown belt rank "$fromName"');
      }
      if (toRank == null) {
        return Failure('Invalid advancement: unknown belt rank "$toName"');
      }

      final dateStr = map['date'] as String?;
      if (dateStr == null) {
        return const Failure('Invalid advancement: missing date');
      }
      var date = DateTime.parse(dateStr);
      if (date.isAfter(futureCutoff)) {
        warnings.add(
          'Advancement date (${fromRank.name} → ${toRank.name}) '
          'is in the future, clamped to now',
        );
        date = DateTime.now();
      }

      return Success(
        BeltAdvancement(
          fromRank: fromRank,
          toRank: toRank,
          date: date,
          notes: map['notes'] as String?,
        ),
      );
    } catch (e) {
      return Failure('Failed to parse advancement: $e');
    }
  }

  Result<TrainingSession> _parseSession(
    Map<String, dynamic> map,
    DateTime futureCutoff,
    List<String> warnings,
  ) {
    try {
      final dateStr = map['date'] as String?;
      if (dateStr == null) {
        return const Failure('Invalid session: missing date');
      }
      var date = DateTime.parse(dateStr);
      if (date.isAfter(futureCutoff)) {
        warnings.add('Training session date is in the future, clamped to now');
        date = DateTime.now();
      }

      final durationMinutes = map['durationMinutes'] as int? ?? 0;

      return Success(
        TrainingSession(
          date: date,
          duration: Duration(minutes: durationMinutes),
          notes: map['notes'] as String?,
        ),
      );
    } catch (e) {
      return Failure('Failed to parse session: $e');
    }
  }

  Result<CardReviewState> _parseCardState(
    Map<String, dynamic> map,
    DateTime futureCutoff,
    List<String> warnings,
  ) {
    try {
      final cardId = map['cardId'] as String?;
      if (cardId == null || cardId.isEmpty) {
        return const Failure('Invalid card state: missing cardId');
      }

      final nextDateStr = map['nextReviewDate'] as String?;
      final lastDateStr = map['lastReviewDate'] as String?;
      if (nextDateStr == null || lastDateStr == null) {
        return const Failure('Invalid card state: missing review dates');
      }

      final nextReviewDate = DateTime.parse(nextDateStr);
      var lastReviewDate = DateTime.parse(lastDateStr);

      // Future next-review dates are acceptable (scheduled reviews).
      // Only warn if lastReviewDate is in the future.
      if (lastReviewDate.isAfter(futureCutoff)) {
        warnings.add(
          'Card "$cardId" lastReviewDate is in the future, clamped to now',
        );
        lastReviewDate = DateTime.now();
      }

      final easeFactor = (map['easeFactor'] as num?)?.toDouble() ?? 2.5;
      final interval = map['interval'] as int? ?? 0;
      final repetitions = map['repetitions'] as int? ?? 0;
      final totalReviews = map['totalReviews'] as int? ?? 0;
      final correctReviews = map['correctReviews'] as int? ?? 0;

      return Success(
        CardReviewState(
          cardId: cardId,
          easeFactor: easeFactor < 1.3 ? 1.3 : easeFactor,
          interval: interval < 0 ? 0 : interval,
          repetitions: repetitions < 0 ? 0 : repetitions,
          nextReviewDate: nextReviewDate,
          lastReviewDate: lastReviewDate,
          totalReviews: totalReviews < 0 ? 0 : totalReviews,
          correctReviews: correctReviews < 0 ? 0 : correctReviews,
        ),
      );
    } catch (e) {
      return Failure('Failed to parse card state: $e');
    }
  }

  Result<QuizAttemptData> _parseQuizAttempt(
    Map<String, dynamic> map,
    DateTime futureCutoff,
    List<String> warnings,
  ) {
    try {
      final timestampStr = map['timestamp'] as String?;
      if (timestampStr == null) {
        return const Failure('Invalid quiz attempt: missing timestamp');
      }
      var timestamp = DateTime.parse(timestampStr);
      if (timestamp.isAfter(futureCutoff)) {
        warnings.add('Quiz attempt timestamp is in the future, clamped to now');
        timestamp = DateTime.now();
      }

      final rankName = map['targetRank'] as String?;
      if (rankName == null) {
        return const Failure('Invalid quiz attempt: missing targetRank');
      }
      final targetRank = _parseBeltRank(rankName);
      if (targetRank == null) {
        return Failure('Invalid quiz attempt: unknown belt rank "$rankName"');
      }

      final categoryScoresRaw =
          map['categoryScores'] as Map<String, dynamic>? ?? {};
      final categoryScores = categoryScoresRaw.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      );

      final weakAreasRaw = map['weakAreas'] as List<dynamic>? ?? [];
      final weakAreas = weakAreasRaw.map((e) => e as String).toList();

      return Success(
        QuizAttemptData(
          timestamp: timestamp,
          targetRank: targetRank,
          isMockExam: map['isMockExam'] as bool? ?? false,
          totalQuestions: map['totalQuestions'] as int? ?? 0,
          correctAnswers: map['correctAnswers'] as int? ?? 0,
          duration: Duration(seconds: map['durationSeconds'] as int? ?? 0),
          categoryScores: categoryScores,
          weakAreas: weakAreas,
        ),
      );
    } catch (e) {
      return Failure('Failed to parse quiz attempt: $e');
    }
  }

  /// Parses a [BeltRank] from its enum name string.
  ///
  /// Returns `null` if the name doesn't match any value.
  BeltRank? _parseBeltRank(String name) {
    for (final rank in BeltRank.values) {
      if (rank.name == name) return rank;
    }
    return null;
  }

  /// Clears all user data from the database (full overwrite preparation).
  Future<void> _clearAllData() async {
    await _db.delete(_db.userProgressTable).go();
    await _db.delete(_db.beltAdvancementTable).go();
    await _db.delete(_db.trainingSessionTable).go();
    await _db.delete(_db.cardReviewStateTable).go();
    await _db.delete(_db.quizAttemptTable).go();
    await _db.delete(_db.reviewSessionTable).go();
  }
}
