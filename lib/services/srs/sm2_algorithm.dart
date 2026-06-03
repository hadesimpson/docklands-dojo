import 'dart:math' as math;

import 'package:docklands_dojo/services/srs/srs_algorithm.dart';

/// SM-2 spaced repetition algorithm implementation.
///
/// Implements the SuperMemo SM-2 algorithm as described by P. Woźniak:
///
/// **Interval formula**:
/// - I(1) = 1 day
/// - I(2) = 6 days
/// - I(n) = I(n-1) × EF, for n > 2
///
/// **Ease factor update**:
/// ```
/// EF' = EF + (0.1 - (5 - q) × (0.08 + (5 - q) × 0.02))
/// ```
/// where `q` is the quality rating (0–5). EF is clamped to a minimum
/// of [minimumEaseFactor] (1.3).
///
/// **Failure handling** (quality < 3):
/// Repetitions reset to 0, interval resets to 1 day, but the ease
/// factor is still updated (and clamped).
///
/// See: https://www.supermemo.com/en/blog/application-of-a-computer-to-improve-the-results-obtained-in-working-with-the-supermemo-method
class SM2Algorithm implements SrsAlgorithm {
  /// Default ease factor for new cards.
  static const double defaultEaseFactor = 2.5;

  /// Minimum ease factor — cards never become harder than this.
  static const double minimumEaseFactor = 1.3;

  /// Creates an [SM2Algorithm] instance.
  const SM2Algorithm();

  @override
  ReviewResult calculateNextReview({
    required int quality,
    required double easeFactor,
    required int interval,
    required int repetitions,
  }) {
    assert(quality >= 0 && quality <= 5, 'Quality must be 0-5, got $quality');

    final isCorrect = quality >= 3;

    // Update ease factor using SM-2 formula.
    // EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
    final q = quality;
    final newEaseFactor = math.max(
      minimumEaseFactor,
      easeFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02)),
    );

    int newRepetitions;
    int newInterval;

    if (isCorrect) {
      // Quality >= 3: correct answer — advance the schedule.
      newRepetitions = repetitions + 1;
      newInterval = switch (newRepetitions) {
        1 => 1,
        2 => 6,
        _ => (interval * newEaseFactor).round(),
      };
    } else {
      // Quality < 3: incorrect answer — reset to beginning.
      newRepetitions = 0;
      newInterval = 1;
    }

    return ReviewResult(
      easeFactor: newEaseFactor,
      interval: newInterval,
      repetitions: newRepetitions,
      isCorrect: isCorrect,
    );
  }
}
