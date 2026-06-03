import 'package:docklands_dojo/models/kumite.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KumiteType enum', () {
    test('has exactly 5 values', () {
      expect(KumiteType.values.length, 5);
    });

    test('contains yakusoku (prearranged)', () {
      expect(KumiteType.values, contains(KumiteType.yakusoku));
    });

    test('contains sanbon (3-step)', () {
      expect(KumiteType.values, contains(KumiteType.sanbon));
    });

    test('contains ippon (1-step)', () {
      expect(KumiteType.values, contains(KumiteType.ippon));
    });

    test('contains jiyu (free sparring)', () {
      expect(KumiteType.values, contains(KumiteType.jiyu));
    });

    test('contains tournament', () {
      expect(KumiteType.values, contains(KumiteType.tournament));
    });
  });

  group('KumiteRequirement construction', () {
    test('with all fields', () {
      const requirement = KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Full contact free sparring',
        rounds: 3,
        roundDuration: Duration(minutes: 1, seconds: 30),
      );
      expect(requirement.type, KumiteType.jiyu);
      expect(requirement.description, 'Full contact free sparring');
      expect(requirement.rounds, 3);
      expect(
        requirement.roundDuration,
        const Duration(minutes: 1, seconds: 30),
      );
    });

    test('rounds and roundDuration are optional', () {
      const requirement = KumiteRequirement(
        type: KumiteType.yakusoku,
        description: 'Prearranged sparring drill',
      );
      expect(requirement.rounds, isNull);
      expect(requirement.roundDuration, isNull);
    });
  });

  group('KumiteRequirement equality', () {
    test('equal when all fields match', () {
      const a = KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Free sparring',
        rounds: 3,
        roundDuration: Duration(minutes: 2),
      );
      const b = KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Free sparring',
        rounds: 3,
        roundDuration: Duration(minutes: 2),
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('not equal when type differs', () {
      const a = KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Sparring',
      );
      const b = KumiteRequirement(
        type: KumiteType.sanbon,
        description: 'Sparring',
      );
      expect(a, isNot(equals(b)));
    });

    test('not equal when rounds differ', () {
      const a = KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Sparring',
        rounds: 3,
      );
      const b = KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Sparring',
        rounds: 5,
      );
      expect(a, isNot(equals(b)));
    });
  });

  group('KumiteRequirement toString', () {
    test('includes type and description', () {
      const requirement = KumiteRequirement(
        type: KumiteType.tournament,
        description: 'Tournament rules kumite',
      );
      expect(requirement.toString(), contains('tournament'));
      expect(requirement.toString(), contains('Tournament rules kumite'));
    });
  });
}
