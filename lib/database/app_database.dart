import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:docklands_dojo/database/daos/progress_dao.dart';
import 'package:docklands_dojo/database/daos/quiz_dao.dart';
import 'package:docklands_dojo/database/daos/review_dao.dart';

part 'app_database.g.dart';

/// Drift table for storing user progress state.
///
/// Stores the user's current belt rank (as enum index), start date,
/// and a JSON-encoded map of completed technique IDs.
class UserProgressTable extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Current belt rank as enum index into [BeltRank].
  IntColumn get currentRank => integer()();

  /// Date when the user started tracking, stored as epoch milliseconds.
  IntColumn get startDate => integer()();

  /// JSON-encoded map of technique ID → completion status.
  ///
  /// Example: `{"seiken_chudan_tsuki": true, "mae_geri": false}`
  TextColumn get completedTechniquesJson =>
      text().withDefault(const Constant('{}'))();
}

/// Drift table for recording belt advancement events.
///
/// Each row represents a transition from one belt rank to the next,
/// forming an immutable event log of the user's grading history.
class BeltAdvancementTable extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Belt rank before advancement (enum index).
  IntColumn get fromRank => integer()();

  /// Belt rank after advancement (enum index).
  IntColumn get toRank => integer()();

  /// Date of advancement, stored as epoch milliseconds.
  IntColumn get date => integer()();

  /// Optional notes about the grading.
  TextColumn get notes => text().nullable()();
}

/// Drift table for recording training sessions.
///
/// Tracks attendance for time-in-grade requirements.
class TrainingSessionTable extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Date of the training session, stored as epoch milliseconds.
  IntColumn get date => integer()();

  /// Duration of the session in minutes.
  IntColumn get durationMinutes => integer()();

  /// Optional notes about the session.
  TextColumn get notes => text().nullable()();
}

/// Drift table for spaced repetition card review states.
///
/// Each row tracks the SM-2 algorithm state for a single flashcard.
/// The [cardId] is the primary key (TEXT), linking to flashcard content.
class CardReviewStateTable extends Table {
  /// Flashcard ID (primary key). Links to flashcard content data.
  TextColumn get cardId => text()();

  /// SM-2 ease factor (default 2.5, minimum 1.3).
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();

  /// Days until next review.
  IntColumn get interval => integer().withDefault(const Constant(0))();

  /// Number of consecutive correct answers.
  IntColumn get repetitions => integer().withDefault(const Constant(0))();

  /// Next review date, stored as epoch milliseconds.
  IntColumn get nextReviewDate => integer()();

  /// Last review date, stored as epoch milliseconds.
  IntColumn get lastReviewDate => integer()();

  /// Total number of reviews for this card.
  IntColumn get totalReviews => integer().withDefault(const Constant(0))();

  /// Number of correct reviews for this card.
  IntColumn get correctReviews => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {cardId};
}

/// Drift table for recording quiz attempts.
///
/// Stores quiz results including score breakdowns and weak areas
/// as JSON-encoded text fields for flexible schema.
class QuizAttemptTable extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Timestamp of the quiz attempt, stored as epoch milliseconds.
  IntColumn get timestamp => integer()();

  /// Target belt rank for this quiz (enum index).
  IntColumn get targetRank => integer()();

  /// Whether this was a mock grading exam.
  BoolColumn get isMockExam => boolean().withDefault(const Constant(false))();

  /// Total number of questions in the quiz.
  IntColumn get totalQuestions => integer()();

  /// Number of correctly answered questions.
  IntColumn get correctAnswers => integer()();

  /// Duration of the quiz in seconds.
  IntColumn get durationSeconds => integer()();

  /// JSON-encoded map of category → score percentage.
  ///
  /// Example: `{"terminology": 0.85, "kihon": 0.92}`
  TextColumn get categoryScoresJson =>
      text().withDefault(const Constant('{}'))();

  /// JSON-encoded list of weak area identifiers.
  ///
  /// Example: `["terminology", "kata_sequences"]`
  TextColumn get weakAreasJson => text().withDefault(const Constant('[]'))();
}

/// Drift table for recording review sessions (spaced repetition).
///
/// Each row summarizes a completed review session with aggregate metrics.
class ReviewSessionTable extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Timestamp of the session, stored as epoch milliseconds.
  IntColumn get timestamp => integer()();

  /// Number of cards reviewed in this session.
  IntColumn get cardsReviewed => integer()();

  /// Number of cards answered correctly.
  IntColumn get correctCount => integer()();

  /// Duration of the session in seconds.
  IntColumn get durationSeconds => integer()();
}

/// The main Drift database for Docklands Dojo.
///
/// Provides access to all tables via typed DAOs:
/// - [ProgressDao] for user progress and belt advancement
/// - [ReviewDao] for spaced repetition card states
/// - [QuizDao] for quiz attempt history
///
/// Schema versioning starts at v1 with a migration callback for
/// future schema changes.
///
/// ```dart
/// final db = AppDatabase(NativeDatabase.memory());
/// final progressDao = db.progressDao;
/// ```
@DriftDatabase(
  tables: [
    UserProgressTable,
    BeltAdvancementTable,
    TrainingSessionTable,
    CardReviewStateTable,
    QuizAttemptTable,
    ReviewSessionTable,
  ],
  daos: [ProgressDao, ReviewDao, QuizDao],
)
class AppDatabase extends _$AppDatabase {
  /// Creates an [AppDatabase] with the given [QueryExecutor].
  ///
  /// For production, use `NativeDatabase` with a file path.
  /// For testing, use `NativeDatabase.memory()`.
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Future migrations go here.
      // Example:
      // if (from < 2) {
      //   await m.addColumn(someTable, someTable.newColumn);
      // }
    },
  );
}
