import 'package:docklands_dojo/database/daos/review_dao.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/services/srs/sm2_algorithm.dart';
import 'package:docklands_dojo/services/srs/srs_algorithm.dart';

/// Statistics about the user's review activity.
class ReviewStats {
  /// Total number of individual card reviews.
  final int totalReviews;

  /// Total number of correct reviews (quality ≥ 3).
  final int correctReviews;

  /// Number of cards currently tracked.
  final int totalCards;

  /// Number of cards currently due for review.
  final int dueCards;

  /// Retention rate as a percentage (0.0–1.0).
  ///
  /// Returns 0.0 if no reviews have been recorded.
  double get retentionRate =>
      totalReviews > 0 ? correctReviews / totalReviews : 0.0;

  /// Creates a [ReviewStats].
  const ReviewStats({
    required this.totalReviews,
    required this.correctReviews,
    required this.totalCards,
    required this.dueCards,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewStats &&
          totalReviews == other.totalReviews &&
          correctReviews == other.correctReviews &&
          totalCards == other.totalCards &&
          dueCards == other.dueCards;

  @override
  int get hashCode =>
      Object.hash(totalReviews, correctReviews, totalCards, dueCards);

  @override
  String toString() =>
      'ReviewStats(total=$totalReviews, correct=$correctReviews, '
      'cards=$totalCards, due=$dueCards, '
      'retention=${(retentionRate * 100).toStringAsFixed(1)}%)';
}

/// High-level service for managing spaced repetition reviews.
///
/// Wraps [SrsAlgorithm] (SM-2 by default) and [ReviewDao] to provide
/// a clean API for the review workflow:
///
/// 1. [getDueCards] — fetch cards that need review today
/// 2. [reviewCard] — process a quality rating for a card
/// 3. [getReviewStats] — aggregate statistics across all cards
/// 4. [createCard] — initialize a new card with default SM-2 state
///
/// All methods return [Result<T>] for error handling.
///
/// ```dart
/// final service = ReviewService(dao: reviewDao);
/// final dueResult = await service.getDueCards(DateTime.now());
/// switch (dueResult) {
///   Success(:final data) => startSession(data),
///   Failure(:final message) => showError(message),
/// }
/// ```
class ReviewService {
  final ReviewDao _dao;
  final SrsAlgorithm _algorithm;

  /// Creates a [ReviewService].
  ///
  /// [dao] provides persistence via Drift.
  /// [algorithm] defaults to [SM2Algorithm] but can be swapped for
  /// testing or future FSRS migration.
  ReviewService({required this._dao, SrsAlgorithm? algorithm})
    : _algorithm = algorithm ?? const SM2Algorithm();

  /// Retrieves all cards due for review at or before [now].
  ///
  /// Cards are ordered by most overdue first.
  Future<Result<List<CardReviewState>>> getDueCards(DateTime now) async {
    return _dao.getDueCards(now);
  }

  /// Processes a review for a card.
  ///
  /// [cardId] identifies the card.
  /// [quality] is the recall quality (0–5).
  /// [now] is the current time (injectable for testing).
  ///
  /// Returns the updated [CardReviewState] on success.
  Future<Result<CardReviewState>> reviewCard({
    required String cardId,
    required int quality,
    required DateTime now,
  }) async {
    try {
      // 1. Load current state.
      final stateResult = await _dao.getReviewState(cardId);
      final CardReviewState? currentState;
      switch (stateResult) {
        case Success(:final data):
          currentState = data;
        case Failure(:final message, :final error):
          return Failure(message, error);
      }

      if (currentState == null) {
        return Failure('Card $cardId not found. Create it first.');
      }

      // 2. Run SM-2 algorithm.
      final result = _algorithm.calculateNextReview(
        quality: quality,
        easeFactor: currentState.easeFactor,
        interval: currentState.interval,
        repetitions: currentState.repetitions,
      );

      // 3. Build updated state.
      final updatedState = CardReviewState(
        cardId: cardId,
        easeFactor: result.easeFactor,
        interval: result.interval,
        repetitions: result.repetitions,
        nextReviewDate: now.add(Duration(days: result.interval)),
        lastReviewDate: now,
        totalReviews: currentState.totalReviews + 1,
        correctReviews:
            currentState.correctReviews + (result.isCorrect ? 1 : 0),
      );

      // 4. Persist.
      final saveResult = await _dao.saveReviewState(updatedState);
      switch (saveResult) {
        case Success():
          return Success(updatedState);
        case Failure(:final message, :final error):
          return Failure(message, error);
      }
    } catch (e) {
      return Failure('Failed to review card $cardId', e);
    }
  }

  /// Retrieves aggregate review statistics.
  Future<Result<ReviewStats>> getReviewStats({DateTime? now}) async {
    try {
      final allResult = await _dao.getAllReviewStates();
      final List<CardReviewState> allCards;
      switch (allResult) {
        case Success(:final data):
          allCards = data;
        case Failure(:final message, :final error):
          return Failure(message, error);
      }

      final effectiveNow = now ?? DateTime.now();
      final dueResult = await _dao.getDueCards(effectiveNow);
      final int dueCount;
      switch (dueResult) {
        case Success(:final data):
          dueCount = data.length;
        case Failure(:final message, :final error):
          return Failure(message, error);
      }

      var totalReviews = 0;
      var correctReviews = 0;
      for (final card in allCards) {
        totalReviews += card.totalReviews;
        correctReviews += card.correctReviews;
      }

      return Success(
        ReviewStats(
          totalReviews: totalReviews,
          correctReviews: correctReviews,
          totalCards: allCards.length,
          dueCards: dueCount,
        ),
      );
    } catch (e) {
      return Failure('Failed to compute review stats', e);
    }
  }

  /// Returns the total number of card reviews across all cards.
  ///
  /// Convenience wrapper that sums `totalReviews` from all states.
  /// Returns 0 on error.
  Future<int> getTotalCardsReviewed() async {
    final result = await _dao.getAllReviewStates();
    switch (result) {
      case Success(:final data):
        return data.fold<int>(0, (sum, card) => sum + card.totalReviews);
      case Failure():
        return 0;
    }
  }

  /// Returns the overall retention rate (correct / total).
  ///
  /// Returns 0.0 if no reviews have been recorded or on error.
  Future<double> getRetentionRate() async {
    final result = await _dao.getAllReviewStates();
    switch (result) {
      case Success(:final data):
        var total = 0;
        var correct = 0;
        for (final card in data) {
          total += card.totalReviews;
          correct += card.correctReviews;
        }
        return total > 0 ? correct / total : 0.0;
      case Failure():
        return 0.0;
    }
  }

  /// Initializes a new card with default SM-2 state.
  ///
  /// Sets EF=2.5, interval=0, repetitions=0, and the next review
  /// date to [now] so the card appears immediately in the due queue.
  Future<Result<void>> createCard(String cardId, {DateTime? now}) async {
    try {
      final effectiveNow = now ?? DateTime.now();
      final state = CardReviewState(
        cardId: cardId,
        easeFactor: SM2Algorithm.defaultEaseFactor,
        interval: 0,
        repetitions: 0,
        nextReviewDate: effectiveNow,
        lastReviewDate: effectiveNow,
        totalReviews: 0,
        correctReviews: 0,
      );
      return _dao.saveReviewState(state);
    } catch (e) {
      return Failure('Failed to create card $cardId', e);
    }
  }
}
