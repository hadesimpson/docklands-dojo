import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/technique.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TechniqueCategory enum', () {
    test('has exactly 9 values', () {
      expect(TechniqueCategory.values.length, 9);
    });

    test('contains dachi (stances)', () {
      expect(TechniqueCategory.values, contains(TechniqueCategory.dachi));
    });

    test('contains tsuki (punches)', () {
      expect(TechniqueCategory.values, contains(TechniqueCategory.tsuki));
    });

    test('contains geri (kicks)', () {
      expect(TechniqueCategory.values, contains(TechniqueCategory.geri));
    });

    test('contains uke (blocks)', () {
      expect(TechniqueCategory.values, contains(TechniqueCategory.uke));
    });

    test('contains uchi (strikes)', () {
      expect(TechniqueCategory.values, contains(TechniqueCategory.uchi));
    });

    test('contains hiji (elbow strikes)', () {
      expect(TechniqueCategory.values, contains(TechniqueCategory.hiji));
    });

    test('contains hiza (knee strikes)', () {
      expect(TechniqueCategory.values, contains(TechniqueCategory.hiza));
    });

    test('contains kata (forms)', () {
      expect(TechniqueCategory.values, contains(TechniqueCategory.kata));
    });

    test('contains tameshiwari (breaking)', () {
      expect(TechniqueCategory.values, contains(TechniqueCategory.tameshiwari));
    });
  });

  group('Technique construction', () {
    const technique = Technique(
      id: 'seiken_chudan_tsuki',
      japaneseName: '正拳中段突き',
      englishName: 'Middle-level straight punch',
      romajiName: 'Seiken chūdan tsuki',
      category: TechniqueCategory.tsuki,
      description: 'A fundamental straight punch targeting the solar plexus.',
      keyPoints: ['Rotate hips fully', 'Pull back hikite'],
      commonMistakes: ['Dropping the elbow', 'Not rotating hips'],
      requiredForBelts: [BeltRank.kyu10, BeltRank.kyu9],
      relatedTechniqueIds: ['seiken_jodan_tsuki'],
    );

    test('has correct id', () {
      expect(technique.id, 'seiken_chudan_tsuki');
    });

    test('has correct Japanese name', () {
      expect(technique.japaneseName, '正拳中段突き');
    });

    test('has correct English name', () {
      expect(technique.englishName, 'Middle-level straight punch');
    });

    test('has correct romaji name', () {
      expect(technique.romajiName, 'Seiken chūdan tsuki');
    });

    test('has correct category', () {
      expect(technique.category, TechniqueCategory.tsuki);
    });

    test('has key points', () {
      expect(technique.keyPoints, hasLength(2));
    });

    test('has common mistakes', () {
      expect(technique.commonMistakes, hasLength(2));
    });

    test('has required belts', () {
      expect(
        technique.requiredForBelts,
        containsAll([BeltRank.kyu10, BeltRank.kyu9]),
      );
    });

    test('has related technique IDs', () {
      expect(technique.relatedTechniqueIds, ['seiken_jodan_tsuki']);
    });

    test('imageAssetPath defaults to null', () {
      expect(technique.imageAssetPath, isNull);
    });

    test('videoUrl defaults to null', () {
      expect(technique.videoUrl, isNull);
    });

    test('optional fields can be set', () {
      const withOptionals = Technique(
        id: 'test',
        japaneseName: 'テスト',
        englishName: 'Test',
        romajiName: 'Tesuto',
        category: TechniqueCategory.dachi,
        description: 'Test technique.',
        keyPoints: [],
        commonMistakes: [],
        requiredForBelts: [],
        relatedTechniqueIds: [],
        imageAssetPath: 'assets/images/test.png',
        videoUrl: 'https://example.com/video',
      );
      expect(withOptionals.imageAssetPath, 'assets/images/test.png');
      expect(withOptionals.videoUrl, 'https://example.com/video');
    });
  });

  group('Technique equality', () {
    test('techniques with same id are equal', () {
      const a = Technique(
        id: 'same_id',
        japaneseName: 'A',
        englishName: 'A',
        romajiName: 'A',
        category: TechniqueCategory.dachi,
        description: 'A',
        keyPoints: [],
        commonMistakes: [],
        requiredForBelts: [],
        relatedTechniqueIds: [],
      );
      const b = Technique(
        id: 'same_id',
        japaneseName: 'B',
        englishName: 'B',
        romajiName: 'B',
        category: TechniqueCategory.geri,
        description: 'B',
        keyPoints: ['different'],
        commonMistakes: ['different'],
        requiredForBelts: [],
        relatedTechniqueIds: [],
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('techniques with different ids are not equal', () {
      const a = Technique(
        id: 'id_a',
        japaneseName: 'A',
        englishName: 'A',
        romajiName: 'A',
        category: TechniqueCategory.dachi,
        description: 'A',
        keyPoints: [],
        commonMistakes: [],
        requiredForBelts: [],
        relatedTechniqueIds: [],
      );
      const b = Technique(
        id: 'id_b',
        japaneseName: 'A',
        englishName: 'A',
        romajiName: 'A',
        category: TechniqueCategory.dachi,
        description: 'A',
        keyPoints: [],
        commonMistakes: [],
        requiredForBelts: [],
        relatedTechniqueIds: [],
      );
      expect(a, isNot(equals(b)));
    });
  });

  group('Technique toString', () {
    test('includes id and romaji name', () {
      const technique = Technique(
        id: 'mae_geri',
        japaneseName: '前蹴り',
        englishName: 'Front kick',
        romajiName: 'Mae geri',
        category: TechniqueCategory.geri,
        description: 'A front kick.',
        keyPoints: [],
        commonMistakes: [],
        requiredForBelts: [],
        relatedTechniqueIds: [],
      );
      expect(technique.toString(), contains('mae_geri'));
      expect(technique.toString(), contains('Mae geri'));
    });
  });
}
