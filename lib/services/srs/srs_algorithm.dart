/// Abstraction layer for spaced repetition algorithms.
///
/// Allows future migration from SM-2 to FSRS without changing consumers.
/// Consumers depend on [SrsAlgorithm] and [ReviewResult], not on a specific
/// algorithm implementation.
///
/// ```dart
/// final algorithm = SM2Algorithm();
/// final result = algorithm.calculateNextReview(
///   quality: 4,
///   easeFactor: 2.5,
///   interval: 6,
///   repetitions: 2,
/// );
/// ```
library;

/// Abstract interface for spaced repetition scheduling algorithms.
///
/// Implementations compute the next review parameters (ease factor,
/// interval, repetition count) given the user's quality rating and
/// the card's current state.
abstract class SrsAlgorithm {
  /// Calculate next review parameters after a review.
  ///
  /// [quality] is the user's self-assessed recall quality on a 0–5 scale:
  /// - 0: complete blackout
  /// - 1: incorrect, but recognized on reveal
  /// - 2: incorrect, but easy to recall on reveal
  /// - 3: correct with serious difficulty
  /// - 4: correct with minor hesitation
  /// - 5: perfect recall
  ///
  /// [easeFactor] is the card's current ease factor (≥ 1.3).
  /// [interval] is the current interval in days (≥ 0).
  /// [repetitions] is the consecutive correct-answer count (≥ 0).
  ///
  /// Returns a [ReviewResult] with the updated scheduling parameters.
  ReviewResult calculateNextReview({
    required int quality,
    required double easeFactor,
    required int interval,
    required int repetitions,
  });
}

/// The output of an [SrsAlgorithm.calculateNextReview] call.
///
/// Contains the updated scheduling state for a flashcard after a review.
class ReviewResult {
  /// Updated ease factor (always ≥ 1.3).
  final double easeFactor;

  /// Updated interval in days until the next review.
  final int interval;

  /// Updated consecutive-correct repetition count.
  final int repetitions;

  /// Whether the review was considered correct (quality ≥ 3).
  final bool isCorrect;

  /// Creates a [ReviewResult].
  const ReviewResult({
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    required this.isCorrect,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewResult &&
          easeFactor == other.easeFactor &&
          interval == other.interval &&
          repetitions == other.repetitions &&
          isCorrect == other.isCorrect;

  @override
  int get hashCode => Object.hash(easeFactor, interval, repetitions, isCorrect);

  @override
  String toString() =>
      'ReviewResult(ef=$easeFactor, interval=$interval, '
      'reps=$repetitions, correct=$isCorrect)';
}
