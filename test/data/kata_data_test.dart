import 'package:docklands_dojo/data/kata_data.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Kata Data', () {
    test('contains exactly 22 kata', () {
      expect(allKata.length, equals(22));
    });

    test('has no duplicate IDs', () {
      final ids = allKata.map((k) => k.id).toList();
      final uniqueIds = ids.toSet();
      expect(
        uniqueIds.length,
        equals(ids.length),
        reason:
            'Duplicate kata IDs found: '
            '${ids.where((id) => ids.indexOf(id) != ids.lastIndexOf(id)).toSet()}',
      );
    });

    test('all expected kata are present', () {
      final ids = allKata.map((k) => k.id).toSet();
      final expectedKata = [
        'taikyoku_sono_ichi',
        'taikyoku_sono_ni',
        'taikyoku_sono_san',
        'sokugi_taikyoku_sono_ichi',
        'sokugi_taikyoku_sono_ni',
        'sokugi_taikyoku_sono_san',
        'pinan_sono_ichi',
        'pinan_sono_ni',
        'pinan_sono_san',
        'pinan_sono_yon',
        'pinan_sono_go',
        'sanchin',
        'tsuki_no_kata',
        'yantsu',
        'saifa',
        'gekisai_dai',
        'gekisai_sho',
        'tensho',
        'seienchin',
        'garyu',
        'kanku_dai',
        'seipai',
      ];
      for (final expected in expectedKata) {
        expect(
          ids.contains(expected),
          isTrue,
          reason: 'Missing kata: $expected',
        );
      }
    });

    test('every kata has non-empty required fields', () {
      for (final k in allKata) {
        expect(k.id, isNotEmpty, reason: 'Empty ID found');
        expect(
          k.japaneseName,
          isNotEmpty,
          reason: '${k.id} has empty japaneseName',
        );
        expect(
          k.englishName,
          isNotEmpty,
          reason: '${k.id} has empty englishName',
        );
        expect(k.meaning, isNotEmpty, reason: '${k.id} has empty meaning');
        expect(k.history, isNotEmpty, reason: '${k.id} has empty history');
        expect(
          k.keyPrinciples,
          isNotEmpty,
          reason: '${k.id} has empty keyPrinciples',
        );
        expect(
          k.movementSequence,
          isNotEmpty,
          reason: '${k.id} has empty movementSequence',
        );
      }
    });

    test('all minimumRank values are valid BeltRank values', () {
      final validRanks = BeltRank.values.toSet();
      for (final k in allKata) {
        expect(
          validRanks.contains(k.minimumRank),
          isTrue,
          reason: '${k.id} has invalid minimumRank: ${k.minimumRank}',
        );
      }
    });

    test('move counts are positive', () {
      for (final k in allKata) {
        expect(
          k.moveCount,
          greaterThan(0),
          reason: '${k.id} has non-positive move count: ${k.moveCount}',
        );
      }
    });

    test('movement sequence length matches move count', () {
      for (final k in allKata) {
        expect(
          k.movementSequence.length,
          equals(k.moveCount),
          reason:
              '${k.id}: movementSequence length '
              '(${k.movementSequence.length}) does not match '
              'moveCount (${k.moveCount})',
        );
      }
    });

    test('kata IDs follow snake_case convention', () {
      final snakeCasePattern = RegExp(r'^[a-z][a-z0-9_]*$');
      for (final k in allKata) {
        expect(
          snakeCasePattern.hasMatch(k.id),
          isTrue,
          reason: '${k.id} does not follow snake_case convention',
        );
      }
    });

    test('Taikyoku kata are for 10th Kyu', () {
      final taikyoku = allKata.where((k) => k.id.startsWith('taikyoku_'));
      for (final k in taikyoku) {
        expect(
          k.minimumRank,
          equals(BeltRank.kyu10),
          reason: '${k.id} should be for 10th Kyu',
        );
      }
    });

    test('Sokugi Taikyoku kata are for 9th Kyu', () {
      final sokugi = allKata.where((k) => k.id.startsWith('sokugi_taikyoku_'));
      for (final k in sokugi) {
        expect(
          k.minimumRank,
          equals(BeltRank.kyu9),
          reason: '${k.id} should be for 9th Kyu',
        );
      }
    });

    test('Kanku Dai is for Shodan', () {
      final kanku = allKata.firstWhere((k) => k.id == 'kanku_dai');
      expect(kanku.minimumRank, equals(BeltRank.shodan));
    });

    test('every kata has at least 3 key principles', () {
      for (final k in allKata) {
        expect(
          k.keyPrinciples.length,
          greaterThanOrEqualTo(3),
          reason: '${k.id} has fewer than 3 key principles',
        );
      }
    });
  });
}
