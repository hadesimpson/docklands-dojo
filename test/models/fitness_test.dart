import 'package:docklands_dojo/models/fitness.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitnessRequirement construction', () {
    test('with all fields', () {
      const requirement = FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 20,
        unit: 'reps',
        notes: 'On knuckles',
      );
      expect(requirement.exerciseName, 'Push-ups');
      expect(requirement.targetCount, 20);
      expect(requirement.unit, 'reps');
      expect(requirement.notes, 'On knuckles');
    });

    test('unit and notes are optional', () {
      const requirement = FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 30,
      );
      expect(requirement.unit, isNull);
      expect(requirement.notes, isNull);
    });

    test('targetCount is stored correctly for various exercises', () {
      const pushUps = FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 20,
      );
      const sitUps = FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 30,
      );
      const squats = FitnessRequirement(
        exerciseName: 'Squats',
        targetCount: 20,
      );
      expect(pushUps.targetCount, 20);
      expect(sitUps.targetCount, 30);
      expect(squats.targetCount, 20);
    });
  });

  group('FitnessRequirement for IKO-1 standards', () {
    test('10th Kyu push-ups: 20 reps', () {
      const requirement = FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 20,
        unit: 'reps',
      );
      expect(requirement.targetCount, 20);
    });

    test('Shodan push-ups: 100 reps', () {
      const requirement = FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 100,
        unit: 'reps',
        notes: 'Consecutive',
      );
      expect(requirement.targetCount, 100);
      expect(requirement.notes, 'Consecutive');
    });

    test('kumite rounds can be represented', () {
      const requirement = FitnessRequirement(
        exerciseName: 'Kumite',
        targetCount: 20,
        unit: 'rounds',
        notes: '2 min each, consecutive rounds',
      );
      expect(requirement.exerciseName, 'Kumite');
      expect(requirement.targetCount, 20);
      expect(requirement.unit, 'rounds');
    });
  });

  group('FitnessRequirement equality', () {
    test('equal when all fields match', () {
      const a = FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 20,
        unit: 'reps',
        notes: 'On knuckles',
      );
      const b = FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 20,
        unit: 'reps',
        notes: 'On knuckles',
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('not equal when exerciseName differs', () {
      const a = FitnessRequirement(exerciseName: 'Push-ups', targetCount: 20);
      const b = FitnessRequirement(exerciseName: 'Sit-ups', targetCount: 20);
      expect(a, isNot(equals(b)));
    });

    test('not equal when targetCount differs', () {
      const a = FitnessRequirement(exerciseName: 'Push-ups', targetCount: 20);
      const b = FitnessRequirement(exerciseName: 'Push-ups', targetCount: 30);
      expect(a, isNot(equals(b)));
    });

    test('not equal when unit differs', () {
      const a = FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 20,
        unit: 'reps',
      );
      const b = FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 20,
        unit: 'seconds',
      );
      expect(a, isNot(equals(b)));
    });
  });

  group('FitnessRequirement toString', () {
    test('includes exercise name and count', () {
      const requirement = FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 50,
      );
      expect(requirement.toString(), contains('Push-ups'));
      expect(requirement.toString(), contains('50'));
    });
  });
}
