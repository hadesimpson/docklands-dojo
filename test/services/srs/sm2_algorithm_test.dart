import 'package:docklands_dojo/services/srs/sm2_algorithm.dart';
import 'package:docklands_dojo/services/srs/srs_algorithm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SM2Algorithm algorithm;

  setUp(() {
    algorithm = const SM2Algorithm();
  });

  group('SM2Algorithm', () {
    group('perfect recall (quality=5)', () {
      test('increases ease factor', () {
        final result = algorithm.calculateNextReview(
          quality: 5,
          easeFactor: 2.5,
          interval: 1,
          repetitions: 0,
        );

        // EF' = 2.5 + (0.1 - (5-5)*(0.08+(5-5)*0.02)) = 2.5 + 0.1 = 2.6
        expect(result.easeFactor, closeTo(2.6, 0.001));
        expect(result.isCorrect, isTrue);
      });

      test('first correct answer gives interval=1', () {
        final result = algorithm.calculateNextReview(
          quality: 5,
          easeFactor: 2.5,
          interval: 0,
          repetitions: 0,
        );

        expect(result.repetitions, 1);
        expect(result.interval, 1);
        expect(result.isCorrect, isTrue);
      });

      test('second correct answer gives interval=6', () {
        final result = algorithm.calculateNextReview(
          quality: 5,
          easeFactor: 2.5,
          interval: 1,
          repetitions: 1,
        );

        expect(result.repetitions, 2);
        expect(result.interval, 6);
      });

      test('third correct answer multiplies by ease factor', () {
        // After 2 reps, EF was 2.6 (from perfect recall).
        // At the start of 3rd review: EF=2.6, q=5.
        // EF' = 2.6 + 0.1 = 2.7. But we pass EF=2.6 from the SECOND step.
        // Wait — in the progression test we feed EF forward. Here we test
        // directly with EF=2.6. New EF=2.7, rep=3, interval=round(6*2.7).
        // BUT the test above that chains all three starts from EF=2.5,
        // so by step 3 the EF is already 2.7 (updated after step 2).
        // In THIS test we pass EF=2.6 directly, so EF'=2.7,
        // interval=round(6*2.7)=round(16.2)=16.
        final result = algorithm.calculateNextReview(
          quality: 5,
          easeFactor: 2.6,
          interval: 6,
          repetitions: 2,
        );

        // EF' = 2.6 + 0.1 = 2.7
        expect(result.easeFactor, closeTo(2.7, 0.001));
        expect(result.repetitions, 3);
        // interval = round(6 * 2.7) = round(16.2) = 16
        expect(result.interval, 16);
      });
    });

    group('good recall (quality=4)', () {
      test('keeps ease factor approximately stable', () {
        final result = algorithm.calculateNextReview(
          quality: 4,
          easeFactor: 2.5,
          interval: 6,
          repetitions: 2,
        );

        // EF' = 2.5 + (0.1 - (5-4)*(0.08+(5-4)*0.02))
        //      = 2.5 + (0.1 - 1*(0.08+0.02))
        //      = 2.5 + (0.1 - 0.1)
        //      = 2.5
        expect(result.easeFactor, closeTo(2.5, 0.001));
        expect(result.isCorrect, isTrue);
      });
    });

    group('just-passing recall (quality=3)', () {
      test('decreases ease factor slightly', () {
        final result = algorithm.calculateNextReview(
          quality: 3,
          easeFactor: 2.5,
          interval: 6,
          repetitions: 2,
        );

        // EF' = 2.5 + (0.1 - (5-3)*(0.08+(5-3)*0.02))
        //      = 2.5 + (0.1 - 2*(0.08+0.04))
        //      = 2.5 + (0.1 - 0.24)
        //      = 2.5 - 0.14
        //      = 2.36
        expect(result.easeFactor, closeTo(2.36, 0.001));
        expect(result.isCorrect, isTrue);
        expect(result.repetitions, 3);
      });
    });

    group('blackout (quality=0)', () {
      test('resets repetitions to 0 and interval to 1', () {
        final result = algorithm.calculateNextReview(
          quality: 0,
          easeFactor: 2.5,
          interval: 30,
          repetitions: 5,
        );

        expect(result.repetitions, 0);
        expect(result.interval, 1);
        expect(result.isCorrect, isFalse);
      });

      test('still updates ease factor', () {
        final result = algorithm.calculateNextReview(
          quality: 0,
          easeFactor: 2.5,
          interval: 30,
          repetitions: 5,
        );

        // EF' = 2.5 + (0.1 - (5-0)*(0.08+(5-0)*0.02))
        //      = 2.5 + (0.1 - 5*(0.08+0.1))
        //      = 2.5 + (0.1 - 0.9)
        //      = 2.5 - 0.8
        //      = 1.7
        expect(result.easeFactor, closeTo(1.7, 0.001));
      });
    });

    group('quality=1 (incorrect but recognized)', () {
      test('resets repetitions and interval', () {
        final result = algorithm.calculateNextReview(
          quality: 1,
          easeFactor: 2.5,
          interval: 15,
          repetitions: 3,
        );

        expect(result.repetitions, 0);
        expect(result.interval, 1);
        expect(result.isCorrect, isFalse);
      });
    });

    group('quality=2 (incorrect, easy recall on reveal)', () {
      test('resets repetitions and interval', () {
        final result = algorithm.calculateNextReview(
          quality: 2,
          easeFactor: 2.5,
          interval: 10,
          repetitions: 4,
        );

        expect(result.repetitions, 0);
        expect(result.interval, 1);
        expect(result.isCorrect, isFalse);
      });

      test('updates ease factor', () {
        final result = algorithm.calculateNextReview(
          quality: 2,
          easeFactor: 2.5,
          interval: 10,
          repetitions: 4,
        );

        // EF' = 2.5 + (0.1 - (5-2)*(0.08+(5-2)*0.02))
        //      = 2.5 + (0.1 - 3*(0.08+0.06))
        //      = 2.5 + (0.1 - 0.42)
        //      = 2.5 - 0.32
        //      = 2.18
        expect(result.easeFactor, closeTo(2.18, 0.001));
      });
    });

    group('ease factor minimum clamping', () {
      test('never drops below 1.3', () {
        // Start with low EF and a blackout — should clamp to 1.3.
        final result = algorithm.calculateNextReview(
          quality: 0,
          easeFactor: 1.3,
          interval: 1,
          repetitions: 0,
        );

        // EF' = 1.3 + (0.1 - 5*(0.08+0.1)) = 1.3 - 0.8 = 0.5
        // Clamped to 1.3
        expect(result.easeFactor, 1.3);
      });

      test('clamps when EF would go below minimum with quality=1', () {
        final result = algorithm.calculateNextReview(
          quality: 1,
          easeFactor: 1.4,
          interval: 1,
          repetitions: 0,
        );

        // EF' = 1.4 + (0.1 - (5-1)*(0.08+(5-1)*0.02))
        //      = 1.4 + (0.1 - 4*(0.08+0.08))
        //      = 1.4 + (0.1 - 0.64)
        //      = 1.4 - 0.54 = 0.86 → clamped to 1.3
        expect(result.easeFactor, 1.3);
      });
    });

    group('interval progression', () {
      test('follows 1 → 6 → 6*EF → ... pattern', () {
        var ef = 2.5;
        var interval = 0;
        var reps = 0;

        // First review (q=5)
        var result = algorithm.calculateNextReview(
          quality: 5,
          easeFactor: ef,
          interval: interval,
          repetitions: reps,
        );
        expect(result.interval, 1);
        expect(result.repetitions, 1);
        ef = result.easeFactor;
        interval = result.interval;
        reps = result.repetitions;

        // Second review (q=5)
        result = algorithm.calculateNextReview(
          quality: 5,
          easeFactor: ef,
          interval: interval,
          repetitions: reps,
        );
        expect(result.interval, 6);
        expect(result.repetitions, 2);
        ef = result.easeFactor;
        interval = result.interval;
        reps = result.repetitions;

        // Third review (q=5): EF was 2.7 after step 2.
        // EF' = 2.7 + 0.1 = 2.8. interval = round(6 * 2.8) = round(16.8) = 17
        result = algorithm.calculateNextReview(
          quality: 5,
          easeFactor: ef,
          interval: interval,
          repetitions: reps,
        );
        expect(result.interval, 17);
        expect(result.repetitions, 3);
      });
    });

    group('multiple consecutive reviews', () {
      test('long streak of perfect answers grows intervals', () {
        var ef = 2.5;
        var interval = 0;
        var reps = 0;
        final intervals = <int>[];

        for (var i = 0; i < 7; i++) {
          final result = algorithm.calculateNextReview(
            quality: 5,
            easeFactor: ef,
            interval: interval,
            repetitions: reps,
          );
          ef = result.easeFactor;
          interval = result.interval;
          reps = result.repetitions;
          intervals.add(interval);
        }

        // Intervals should be monotonically increasing after the 2nd.
        expect(intervals[0], 1);
        expect(intervals[1], 6);
        for (var i = 2; i < intervals.length; i++) {
          expect(
            intervals[i],
            greaterThan(intervals[i - 1]),
            reason: 'Interval at step $i should grow',
          );
        }
      });

      test('failure mid-streak resets then climbs again', () {
        var ef = 2.5;
        var interval = 0;
        var reps = 0;

        // Build up 3 correct reviews.
        for (var i = 0; i < 3; i++) {
          final result = algorithm.calculateNextReview(
            quality: 5,
            easeFactor: ef,
            interval: interval,
            repetitions: reps,
          );
          ef = result.easeFactor;
          interval = result.interval;
          reps = result.repetitions;
        }

        expect(reps, 3);
        expect(interval, greaterThan(6));

        // Fail (q=0)
        final failResult = algorithm.calculateNextReview(
          quality: 0,
          easeFactor: ef,
          interval: interval,
          repetitions: reps,
        );
        expect(failResult.repetitions, 0);
        expect(failResult.interval, 1);
        expect(failResult.isCorrect, isFalse);
        ef = failResult.easeFactor;
        interval = failResult.interval;
        reps = failResult.repetitions;

        // Recover with correct answers — should start from 1 again.
        final recoverResult = algorithm.calculateNextReview(
          quality: 5,
          easeFactor: ef,
          interval: interval,
          repetitions: reps,
        );
        expect(recoverResult.repetitions, 1);
        expect(recoverResult.interval, 1);
        expect(recoverResult.isCorrect, isTrue);
      });

      test('repeated failures keep EF clamped at minimum', () {
        var ef = 2.5;
        var interval = 1;
        var reps = 0;

        // Fail 10 times in a row.
        for (var i = 0; i < 10; i++) {
          final result = algorithm.calculateNextReview(
            quality: 0,
            easeFactor: ef,
            interval: interval,
            repetitions: reps,
          );
          ef = result.easeFactor;
          interval = result.interval;
          reps = result.repetitions;
        }

        expect(ef, 1.3);
        expect(reps, 0);
        expect(interval, 1);
      });
    });

    group('edge cases', () {
      test('default ease factor constant is 2.5', () {
        expect(SM2Algorithm.defaultEaseFactor, 2.5);
      });

      test('minimum ease factor constant is 1.3', () {
        expect(SM2Algorithm.minimumEaseFactor, 1.3);
      });

      test('quality=5 with minimum EF recovers toward higher EF', () {
        final result = algorithm.calculateNextReview(
          quality: 5,
          easeFactor: 1.3,
          interval: 1,
          repetitions: 0,
        );

        // EF' = 1.3 + 0.1 = 1.4
        expect(result.easeFactor, closeTo(1.4, 0.001));
        expect(result.easeFactor, greaterThan(1.3));
      });
    });
  });

  group('ReviewResult', () {
    test('equality works', () {
      const a = ReviewResult(
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
        isCorrect: true,
      );
      const b = ReviewResult(
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
        isCorrect: true,
      );

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality on different fields', () {
      const a = ReviewResult(
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
        isCorrect: true,
      );
      const b = ReviewResult(
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
        isCorrect: false,
      );

      expect(a, isNot(equals(b)));
    });

    test('toString is descriptive', () {
      const result = ReviewResult(
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
        isCorrect: true,
      );

      expect(result.toString(), contains('2.5'));
      expect(result.toString(), contains('6'));
      expect(result.toString(), contains('2'));
    });
  });
}
