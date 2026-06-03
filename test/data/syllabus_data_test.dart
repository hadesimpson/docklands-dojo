import 'package:docklands_dojo/data/kata_data.dart';
import 'package:docklands_dojo/data/syllabus_data.dart';
import 'package:docklands_dojo/data/techniques_data.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Syllabus Data', () {
    test('contains exactly 11 belt requirements', () {
      expect(allBeltRequirements.length, equals(11));
    });

    test('covers all BeltRank values', () {
      final ranks = allBeltRequirements.map((r) => r.rank).toSet();
      for (final rank in BeltRank.values) {
        expect(
          ranks.contains(rank),
          isTrue,
          reason: 'Missing belt requirement for: $rank',
        );
      }
    });

    test('has no duplicate ranks', () {
      final ranks = allBeltRequirements.map((r) => r.rank).toList();
      final uniqueRanks = ranks.toSet();
      expect(uniqueRanks.length, equals(ranks.length));
    });

    test('every belt requirement has non-empty required fields', () {
      for (final r in allBeltRequirements) {
        expect(
          r.japaneseName,
          isNotEmpty,
          reason: '${r.rank} has empty japaneseName',
        );
        expect(
          r.colorDescription,
          isNotEmpty,
          reason: '${r.rank} has empty colorDescription',
        );
        expect(
          r.requiredKihon,
          isNotEmpty,
          reason: '${r.rank} has empty requiredKihon',
        );
        expect(
          r.requiredKata,
          isNotEmpty,
          reason: '${r.rank} has empty requiredKata',
        );
        expect(
          r.fitnessRequirements,
          isNotEmpty,
          reason: '${r.rank} has empty fitnessRequirements',
        );
        expect(
          r.terminology,
          isNotEmpty,
          reason: '${r.rank} has empty terminology',
        );
        expect(r.idoGeiko, isNotEmpty, reason: '${r.rank} has empty idoGeiko');
      }
    });

    test('all requiredKihon IDs resolve to techniques_data', () {
      final allTechniqueIds = allTechniques.map((t) => t.id).toSet();
      for (final r in allBeltRequirements) {
        for (final kihonId in r.requiredKihon) {
          expect(
            allTechniqueIds.contains(kihonId),
            isTrue,
            reason:
                '${r.rank} references non-existent technique: '
                '$kihonId',
          );
        }
      }
    });

    test('all requiredKata IDs resolve to kata_data', () {
      final allKataIds = allKata.map((k) => k.id).toSet();
      for (final r in allBeltRequirements) {
        for (final kataId in r.requiredKata) {
          expect(
            allKataIds.contains(kataId),
            isTrue,
            reason: '${r.rank} references non-existent kata: $kataId',
          );
        }
      }
    });

    test('fitness requirement numbers are positive', () {
      for (final r in allBeltRequirements) {
        for (final f in r.fitnessRequirements) {
          expect(
            f.targetCount,
            greaterThan(0),
            reason:
                '${r.rank} has non-positive fitness target: '
                '${f.exerciseName} = ${f.targetCount}',
          );
        }
      }
    });

    test('fitness requirements increase with belt rank', () {
      // Check that push-ups increase from kyu10 to shodan.
      int? previousPushUps;
      for (final rank in BeltRank.values) {
        final req = allBeltRequirements.firstWhere((r) => r.rank == rank);
        final pushUps = req.fitnessRequirements
            .where((f) => f.exerciseName == 'Push-ups')
            .firstOrNull;
        if (pushUps != null && previousPushUps != null) {
          expect(
            pushUps.targetCount,
            greaterThanOrEqualTo(previousPushUps),
            reason:
                '$rank push-ups (${pushUps.targetCount}) should be '
                '>= previous ($previousPushUps)',
          );
        }
        if (pushUps != null) {
          previousPushUps = pushUps.targetCount;
        }
      }
    });

    test('fitness numbers match PRD IKO-1 table', () {
      int pushUps(BeltRank rank) => allBeltRequirements
          .firstWhere((r) => r.rank == rank)
          .fitnessRequirements
          .firstWhere((f) => f.exerciseName == 'Push-ups')
          .targetCount;

      int sitUps(BeltRank rank) => allBeltRequirements
          .firstWhere((r) => r.rank == rank)
          .fitnessRequirements
          .firstWhere((f) => f.exerciseName == 'Sit-ups')
          .targetCount;

      int squats(BeltRank rank) => allBeltRequirements
          .firstWhere((r) => r.rank == rank)
          .fitnessRequirements
          .firstWhere((f) => f.exerciseName == 'Squats')
          .targetCount;

      // PRD table values:
      expect(pushUps(BeltRank.kyu10), equals(20));
      expect(sitUps(BeltRank.kyu10), equals(30));
      expect(squats(BeltRank.kyu10), equals(20));

      expect(pushUps(BeltRank.kyu9), equals(25));
      expect(sitUps(BeltRank.kyu9), equals(35));
      expect(squats(BeltRank.kyu9), equals(25));

      expect(pushUps(BeltRank.kyu8), equals(25));
      expect(sitUps(BeltRank.kyu8), equals(35));
      expect(squats(BeltRank.kyu8), equals(25));

      expect(pushUps(BeltRank.kyu7), equals(30));
      expect(sitUps(BeltRank.kyu7), equals(40));
      expect(squats(BeltRank.kyu7), equals(30));

      expect(pushUps(BeltRank.kyu6), equals(35));
      expect(sitUps(BeltRank.kyu6), equals(45));
      expect(squats(BeltRank.kyu6), equals(35));

      expect(pushUps(BeltRank.kyu5), equals(40));
      expect(sitUps(BeltRank.kyu5), equals(50));
      expect(squats(BeltRank.kyu5), equals(40));

      expect(pushUps(BeltRank.kyu4), equals(45));
      expect(sitUps(BeltRank.kyu4), equals(60));
      expect(squats(BeltRank.kyu4), equals(45));

      expect(pushUps(BeltRank.kyu3), equals(50));
      expect(sitUps(BeltRank.kyu3), equals(70));
      expect(squats(BeltRank.kyu3), equals(50));

      expect(pushUps(BeltRank.kyu2), equals(60));
      expect(sitUps(BeltRank.kyu2), equals(80));
      expect(squats(BeltRank.kyu2), equals(60));

      expect(pushUps(BeltRank.kyu1), equals(70));
      expect(sitUps(BeltRank.kyu1), equals(100));
      expect(squats(BeltRank.kyu1), equals(70));

      expect(pushUps(BeltRank.shodan), equals(100));
      expect(sitUps(BeltRank.shodan), equals(150));
      expect(squats(BeltRank.shodan), equals(100));
    });

    test('minimumTrainingSessions is positive for all ranks', () {
      for (final r in allBeltRequirements) {
        expect(
          r.minimumTrainingSessions,
          greaterThan(0),
          reason: '${r.rank} has non-positive minimumTrainingSessions',
        );
      }
    });

    test('minimumTimeInGrade is positive for all ranks', () {
      for (final r in allBeltRequirements) {
        expect(
          r.minimumTimeInGrade.inDays,
          greaterThan(0),
          reason: '${r.rank} has non-positive minimumTimeInGrade',
        );
      }
    });

    test('kumite requirements start at 7th Kyu', () {
      // Ranks below 7th Kyu should have no kumite.
      for (final r in allBeltRequirements) {
        if (r.rank == BeltRank.kyu10 ||
            r.rank == BeltRank.kyu9 ||
            r.rank == BeltRank.kyu8) {
          expect(
            r.kumiteRequirements,
            isEmpty,
            reason: '${r.rank} should not have kumite requirements',
          );
        }
      }

      // 7th Kyu and above should have kumite.
      for (final r in allBeltRequirements) {
        if (r.rank != BeltRank.kyu10 &&
            r.rank != BeltRank.kyu9 &&
            r.rank != BeltRank.kyu8) {
          expect(
            r.kumiteRequirements,
            isNotEmpty,
            reason: '${r.rank} should have kumite requirements',
          );
        }
      }
    });

    test('kumite rounds match PRD table', () {
      int? kumiteRounds(BeltRank rank) {
        final req = allBeltRequirements.firstWhere((r) => r.rank == rank);
        if (req.kumiteRequirements.isEmpty) return null;
        return req.kumiteRequirements
            .where((k) => k.rounds != null)
            .map((k) => k.rounds!)
            .reduce((a, b) => a > b ? a : b);
      }

      // PRD: 7th Kyu = 3 rounds, 6th = 3, 5th = 4, 4th = 4,
      // 3rd = 5, 2nd = 7, 1st = 10, Shodan = 20
      expect(kumiteRounds(BeltRank.kyu7), equals(3));
      expect(kumiteRounds(BeltRank.kyu6), equals(3));
      expect(kumiteRounds(BeltRank.kyu5), equals(4));
      expect(kumiteRounds(BeltRank.kyu4), equals(4));
      expect(kumiteRounds(BeltRank.kyu3), equals(5));
      expect(kumiteRounds(BeltRank.kyu2), equals(7));
      expect(kumiteRounds(BeltRank.kyu1), equals(10));
      expect(kumiteRounds(BeltRank.shodan), equals(20));
    });

    test('Shodan requires tameshiwari', () {
      final shodan = allBeltRequirements.firstWhere(
        (r) => r.rank == BeltRank.shodan,
      );
      expect(
        shodan.requiredKihon,
        containsAll([
          'tameshiwari_seiken',
          'tameshiwari_shuto',
          'tameshiwari_hiji',
        ]),
      );
    });

    test('10th Kyu requires Taikyoku kata', () {
      final kyu10 = allBeltRequirements.firstWhere(
        (r) => r.rank == BeltRank.kyu10,
      );
      expect(
        kyu10.requiredKata,
        containsAll([
          'taikyoku_sono_ichi',
          'taikyoku_sono_ni',
          'taikyoku_sono_san',
        ]),
      );
    });

    test('Shodan requires Kanku Dai', () {
      final shodan = allBeltRequirements.firstWhere(
        (r) => r.rank == BeltRank.shodan,
      );
      expect(shodan.requiredKata, contains('kanku_dai'));
    });
  });
}
