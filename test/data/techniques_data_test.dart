import 'package:docklands_dojo/data/techniques_data.dart';
import 'package:docklands_dojo/models/technique.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Techniques Data', () {
    test('contains at least 72 techniques', () {
      expect(allTechniques.length, greaterThanOrEqualTo(72));
    });

    test('has no duplicate IDs', () {
      final ids = allTechniques.map((t) => t.id).toList();
      final uniqueIds = ids.toSet();
      expect(
        uniqueIds.length,
        equals(ids.length),
        reason:
            'Duplicate technique IDs found: '
            '${ids.where((id) => ids.indexOf(id) != ids.lastIndexOf(id)).toSet()}',
      );
    });

    test('all 8 non-kata technique categories are represented', () {
      // Kata have their own dedicated model (Kata) and data file
      // (kata_data.dart), so TechniqueCategory.kata is not expected
      // in the techniques list.
      final categories = allTechniques.map((t) => t.category).toSet();
      final expectedCategories = TechniqueCategory.values
          .where((c) => c != TechniqueCategory.kata)
          .toSet();
      for (final category in expectedCategories) {
        expect(
          categories.contains(category),
          isTrue,
          reason: 'Missing category: $category',
        );
      }
      // Kata category should NOT appear in techniques_data.
      expect(
        categories.contains(TechniqueCategory.kata),
        isFalse,
        reason: 'Kata should be in kata_data.dart, not techniques_data',
      );
    });

    test('has correct count per category', () {
      final categoryCounts = <TechniqueCategory, int>{};
      for (final t in allTechniques) {
        categoryCounts[t.category] = (categoryCounts[t.category] ?? 0) + 1;
      }

      expect(
        categoryCounts[TechniqueCategory.dachi],
        equals(11),
        reason: 'Expected 11 stances',
      );
      expect(
        categoryCounts[TechniqueCategory.tsuki],
        equals(12),
        reason: 'Expected 12 punches',
      );
      expect(
        categoryCounts[TechniqueCategory.geri],
        equals(14),
        reason: 'Expected 14 kicks',
      );
      expect(
        categoryCounts[TechniqueCategory.uke],
        equals(10),
        reason: 'Expected 10 blocks',
      );
      expect(
        categoryCounts[TechniqueCategory.uchi],
        equals(12),
        reason: 'Expected 12 strikes',
      );
      expect(
        categoryCounts[TechniqueCategory.hiji],
        equals(6),
        reason: 'Expected 6 elbow strikes',
      );
      expect(
        categoryCounts[TechniqueCategory.hiza],
        equals(4),
        reason: 'Expected 4 knee strikes',
      );
      expect(
        categoryCounts[TechniqueCategory.tameshiwari],
        equals(3),
        reason: 'Expected 3 breaking techniques',
      );
    });

    test('every technique has non-empty required fields', () {
      for (final t in allTechniques) {
        expect(t.id, isNotEmpty, reason: 'Empty ID found');
        expect(
          t.japaneseName,
          isNotEmpty,
          reason: '${t.id} has empty japaneseName',
        );
        expect(
          t.englishName,
          isNotEmpty,
          reason: '${t.id} has empty englishName',
        );
        expect(
          t.romajiName,
          isNotEmpty,
          reason: '${t.id} has empty romajiName',
        );
        expect(
          t.description,
          isNotEmpty,
          reason: '${t.id} has empty description',
        );
        expect(t.keyPoints, isNotEmpty, reason: '${t.id} has empty keyPoints');
        expect(
          t.commonMistakes,
          isNotEmpty,
          reason: '${t.id} has empty commonMistakes',
        );
        expect(
          t.requiredForBelts,
          isNotEmpty,
          reason: '${t.id} has empty requiredForBelts',
        );
      }
    });

    test('every technique has at least 3 key points', () {
      for (final t in allTechniques) {
        expect(
          t.keyPoints.length,
          greaterThanOrEqualTo(3),
          reason: '${t.id} has fewer than 3 key points',
        );
      }
    });

    test('every technique has at least 2 common mistakes', () {
      for (final t in allTechniques) {
        expect(
          t.commonMistakes.length,
          greaterThanOrEqualTo(2),
          reason: '${t.id} has fewer than 2 common mistakes',
        );
      }
    });

    test('all relatedTechniqueIds reference existing techniques', () {
      final allIds = allTechniques.map((t) => t.id).toSet();
      for (final t in allTechniques) {
        for (final relatedId in t.relatedTechniqueIds) {
          expect(
            allIds.contains(relatedId),
            isTrue,
            reason: '${t.id} references non-existent technique: $relatedId',
          );
        }
      }
    });

    test('technique IDs follow snake_case convention', () {
      final snakeCasePattern = RegExp(r'^[a-z][a-z0-9_]*$');
      for (final t in allTechniques) {
        expect(
          snakeCasePattern.hasMatch(t.id),
          isTrue,
          reason: '${t.id} does not follow snake_case convention',
        );
      }
    });

    test('all requiredForBelts values are valid BeltRank values', () {
      for (final t in allTechniques) {
        for (final belt in t.requiredForBelts) {
          // Belt rank is an enum, so this is validated at compile time.
          // This test ensures the list is non-empty and all values resolve.
          expect(belt.name, isNotEmpty);
        }
      }
    });

    test('stances have correct IDs', () {
      final stanceIds = allTechniques
          .where((t) => t.category == TechniqueCategory.dachi)
          .map((t) => t.id)
          .toSet();
      expect(stanceIds, contains('heisoku_dachi'));
      expect(stanceIds, contains('musubi_dachi'));
      expect(stanceIds, contains('heiko_dachi'));
      expect(stanceIds, contains('shizen_tai'));
      expect(stanceIds, contains('uchi_hachiji_dachi'));
      expect(stanceIds, contains('sanchin_dachi'));
      expect(stanceIds, contains('zenkutsu_dachi'));
      expect(stanceIds, contains('kiba_dachi'));
      expect(stanceIds, contains('kokutsu_dachi'));
      expect(stanceIds, contains('neko_ashi_dachi'));
      expect(stanceIds, contains('tsuru_ashi_dachi'));
    });

    test('breaking techniques reference tameshiwari category', () {
      final breaking = allTechniques.where(
        (t) => t.category == TechniqueCategory.tameshiwari,
      );
      expect(breaking.length, equals(3));
      final ids = breaking.map((t) => t.id).toSet();
      expect(ids, contains('tameshiwari_seiken'));
      expect(ids, contains('tameshiwari_shuto'));
      expect(ids, contains('tameshiwari_hiji'));
    });
  });
}
