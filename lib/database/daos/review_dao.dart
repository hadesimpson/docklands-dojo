import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/result.dart';
import 'package:drift/drift.dart';

part 'review_dao.g.dart';

/// Data model for a card's spaced repetition state.
///
/// Represents the SM-2 algorithm state for a single flashcard,
/// as stored in the database. This is the persistence representation;
/// the domain model in `lib/models/flash_card.dart` will be added in CL8.
class CardReviewState {
  /// The flashcard identifier.
  final String cardId;

  /// SM-2 ease factor (default 2.5, minimum 1.3).
  final double easeFactor;

  /// Days until next review.
  final int interval;

  /// Consecutive correct answers.
  final int repetitions;

  /// Next scheduled review date.
  final DateTime nextReviewDate;

  /// Date of the last review.
  final DateTime lastReviewDate;

  /// Total number of reviews.
  final int totalReviews;

  /// Number of correct reviews.
  final int correctReviews;

  /// Creates a [CardReviewState].
  const CardReviewState({
    required this.cardId,
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    required this.nextReviewDate,
    required this.lastReviewDate,
    required this.totalReviews,
    required this.correctReviews,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardReviewState && cardId == other.cardId;

  @override
  int get hashCode => cardId.hashCode;

  @override
  String toString() =>
      'CardReviewState($cardId, ef=$easeFactor, interval=$interval)';
}

/// Data model for a review session summary.
///
/// Aggregates metrics from a completed spaced repetition session.
class ReviewSession {
  /// Unique identifier (auto-assigned by database).
  final int? id;

  /// When the session occurred.
  final DateTime timestamp;

  /// Number of cards reviewed.
  final int cardsReviewed;

  /// Number of correct answers.
  final int correctCount;

  /// Duration of the session.
  final Duration duration;

  /// Creates a [ReviewSession].
  const ReviewSession({
    this.id,
    required this.timestamp,
    required this.cardsReviewed,
    required this.correctCount,
    required this.duration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewSession && timestamp == other.timestamp;

  @override
  int get hashCode => timestamp.hashCode;

  @override
  String toString() =>
      'ReviewSession($timestamp, reviewed=$cardsReviewed, correct=$correctCount)';
}

/// Data access object for spaced repetition card review states.
///
/// Provides typed CRUD operations for:
/// - [CardReviewState] — SM-2 algorithm state per card
/// - [ReviewSession] — review session summaries
///
/// Key query: [getDueCards] returns cards where `nextReviewDate <= now`,
/// ordered by most overdue first.
///
/// All public methods return [Result] types for error handling.
@DriftAccessor(tables: [CardReviewStateTable, ReviewSessionTable])
class ReviewDao extends DatabaseAccessor<AppDatabase> with _$ReviewDaoMixin {
  /// Creates a [ReviewDao] attached to the given [AppDatabase].
  ReviewDao(super.db);

  /// Retrieves the review state for a specific card.
  ///
  /// Returns `null` if the card has never been reviewed.
  Future<Result<CardReviewState?>> getReviewState(String cardId) async {
    try {
      final row = await (select(
        cardReviewStateTable,
      )..where((tbl) => tbl.cardId.equals(cardId))).getSingleOrNull();
      if (row == null) {
        return const Success(null);
      }
      return Success(_rowToCardReviewState(row));
    } catch (e) {
      return Failure('Failed to load review state for $cardId', e);
    }
  }

  /// Saves or updates a card's review state.
  ///
  /// Uses upsert semantics: inserts if the card has no state,
  /// updates if it already exists.
  Future<Result<void>> saveReviewState(CardReviewState state) async {
    try {
      await into(cardReviewStateTable).insertOnConflictUpdate(
        CardReviewStateTableCompanion.insert(
          cardId: state.cardId,
          easeFactor: Value(state.easeFactor),
          interval: Value(state.interval),
          repetitions: Value(state.repetitions),
          nextReviewDate: state.nextReviewDate.millisecondsSinceEpoch,
          lastReviewDate: state.lastReviewDate.millisecondsSinceEpoch,
          totalReviews: Value(state.totalReviews),
          correctReviews: Value(state.correctReviews),
        ),
      );
      return const Success(null);
    } catch (e) {
      return Failure('Failed to save review state for ${state.cardId}', e);
    }
  }

  /// Retrieves all card review states.
  ///
  /// Returns an empty list if no cards have been reviewed.
  Future<Result<List<CardReviewState>>> getAllReviewStates() async {
    try {
      final rows = await select(cardReviewStateTable).get();
      return Success(rows.map(_rowToCardReviewState).toList());
    } catch (e) {
      return Failure('Failed to load review states', e);
    }
  }

  /// Retrieves cards that are due for review.
  ///
  /// Returns cards where `nextReviewDate <= now`, ordered by most
  /// overdue first (ascending nextReviewDate).
  Future<Result<List<CardReviewState>>> getDueCards(DateTime now) async {
    try {
      final nowEpoch = now.millisecondsSinceEpoch;
      final rows =
          await (select(cardReviewStateTable)
                ..where(
                  (tbl) => tbl.nextReviewDate.isSmallerOrEqualValue(nowEpoch),
                )
                ..orderBy([(tbl) => OrderingTerm.asc(tbl.nextReviewDate)]))
              .get();
      return Success(rows.map(_rowToCardReviewState).toList());
    } catch (e) {
      return Failure('Failed to load due cards', e);
    }
  }

  /// Records a completed review session.
  ///
  /// Returns [Success] with `void` on success, or [Failure] on error.
  Future<Result<void>> addReviewSession(ReviewSession session) async {
    try {
      await into(reviewSessionTable).insert(
        ReviewSessionTableCompanion.insert(
          timestamp: session.timestamp.millisecondsSinceEpoch,
          cardsReviewed: session.cardsReviewed,
          correctCount: session.correctCount,
          durationSeconds: session.duration.inSeconds,
        ),
      );
      return const Success(null);
    } catch (e) {
      return Failure('Failed to add review session', e);
    }
  }

  /// Retrieves all review sessions, ordered by most recent first.
  Future<Result<List<ReviewSession>>> getReviewSessions() async {
    try {
      final rows = await (select(
        reviewSessionTable,
      )..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])).get();
      return Success(rows.map(_rowToReviewSession).toList());
    } catch (e) {
      return Failure('Failed to load review sessions', e);
    }
  }

  CardReviewState _rowToCardReviewState(CardReviewStateTableData row) =>
      CardReviewState(
        cardId: row.cardId,
        easeFactor: row.easeFactor,
        interval: row.interval,
        repetitions: row.repetitions,
        nextReviewDate: DateTime.fromMillisecondsSinceEpoch(row.nextReviewDate),
        lastReviewDate: DateTime.fromMillisecondsSinceEpoch(row.lastReviewDate),
        totalReviews: row.totalReviews,
        correctReviews: row.correctReviews,
      );

  ReviewSession _rowToReviewSession(ReviewSessionTableData row) =>
      ReviewSession(
        id: row.id,
        timestamp: DateTime.fromMillisecondsSinceEpoch(row.timestamp),
        cardsReviewed: row.cardsReviewed,
        correctCount: row.correctCount,
        duration: Duration(seconds: row.durationSeconds),
      );
}
