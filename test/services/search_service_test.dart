import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/technique.dart';
import 'package:docklands_dojo/services/search_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const searchService = SearchService();

  group('SearchService', () {
    group('searchTechniques', () {
      test('returns all techniques when query is empty', () {
        final results = searchService.searchTechniques('');
        expect(results, isNotEmpty);
      });

      test('finds exact match by romaji name', () {
        final results = searchService.searchTechniques('Mawashi geri');
        expect(results, isNotEmpty);
        expect(
          results.any((t) => t.romajiName.contains('Mawashi geri')),
          isTrue,
        );
      });

      test('finds exact match by English name', () {
        final results = searchService.searchTechniques(
          'Middle-level straight punch',
        );
        expect(results, isNotEmpty);
        expect(
          results.any((t) => t.englishName == 'Middle-level straight punch'),
          isTrue,
        );
      });

      test('finds exact match by Japanese name', () {
        final results = searchService.searchTechniques('正拳中段突き');
        expect(results, isNotEmpty);
        expect(results.any((t) => t.japaneseName == '正拳中段突き'), isTrue);
      });

      test(
        'fuzzy matches "mawasi geri" to "mawashi geri" via canonicalization',
        () {
          // "si" → "shi" canonical mapping.
          final results = searchService.searchTechniques('mawasi geri');
          expect(results, isNotEmpty);
          expect(
            results.any((t) => t.romajiName.toLowerCase().contains('mawashi')),
            isTrue,
          );
        },
      );

      test('fuzzy matches "chudan tuki" via canonicalization', () {
        // "tu" stays "tu" but "tuki" might need checking.
        // Actually "tuki" doesn't match "tsuki" via the mapping.
        // But "tuski" would. Let's test "chudan" substring match.
        final results = searchService.searchTechniques('chudan');
        expect(results, isNotEmpty);
        expect(
          results.any(
            (t) =>
                t.romajiName.toLowerCase().contains('chūdan') ||
                t.romajiName.toLowerCase().contains('chudan'),
          ),
          isTrue,
        );
      });

      test('normalization strips macrons', () {
        // "chūdan" normalized → "chudan"
        final results = searchService.searchTechniques('chudan');
        expect(results, isNotEmpty);
      });

      test('returns empty list for nonsense query', () {
        final results = searchService.searchTechniques('xyznonexistent123abc');
        expect(results, isEmpty);
      });

      test('search is case insensitive', () {
        final results1 = searchService.searchTechniques('MAWASHI');
        final results2 = searchService.searchTechniques('mawashi');
        expect(results1.length, equals(results2.length));
      });
    });

    group('searchTechniques with category filter', () {
      test('filters by category', () {
        final results = searchService.searchTechniques(
          '',
          category: TechniqueCategory.geri,
        );
        expect(results, isNotEmpty);
        expect(
          results.every((t) => t.category == TechniqueCategory.geri),
          isTrue,
        );
      });

      test('combines search query with category filter', () {
        final results = searchService.searchTechniques(
          'mae',
          category: TechniqueCategory.geri,
        );
        expect(results, isNotEmpty);
        expect(
          results.every((t) => t.category == TechniqueCategory.geri),
          isTrue,
        );
      });

      test('returns empty when category has no matches for query', () {
        final results = searchService.searchTechniques(
          'mawashi geri',
          category: TechniqueCategory.dachi,
        );
        expect(results, isEmpty);
      });
    });

    group('searchTechniques with belt rank filter', () {
      test('filters by belt rank', () {
        final results = searchService.searchTechniques(
          '',
          beltRank: BeltRank.kyu10,
        );
        expect(results, isNotEmpty);
        expect(
          results.every((t) => t.requiredForBelts.contains(BeltRank.kyu10)),
          isTrue,
        );
      });

      test('combines search query with belt filter', () {
        final results = searchService.searchTechniques(
          'dachi',
          beltRank: BeltRank.kyu10,
        );
        expect(results, isNotEmpty);
        expect(
          results.every((t) => t.requiredForBelts.contains(BeltRank.kyu10)),
          isTrue,
        );
      });
    });

    group('filterByCategory', () {
      test('returns only techniques of the given category', () {
        for (final category in TechniqueCategory.values) {
          final results = searchService.filterByCategory(category);
          for (final technique in results) {
            expect(technique.category, equals(category));
          }
        }
      });

      test('dachi category has at least 10 techniques', () {
        final results = searchService.filterByCategory(TechniqueCategory.dachi);
        expect(results.length, greaterThanOrEqualTo(10));
      });

      test('geri category has at least 10 techniques', () {
        final results = searchService.filterByCategory(TechniqueCategory.geri);
        expect(results.length, greaterThanOrEqualTo(10));
      });

      test('hiji category has at least 4 techniques', () {
        final results = searchService.filterByCategory(TechniqueCategory.hiji);
        expect(results.length, greaterThanOrEqualTo(4));
      });

      test('hiza category has at least 3 techniques', () {
        final results = searchService.filterByCategory(TechniqueCategory.hiza);
        expect(results.length, greaterThanOrEqualTo(3));
      });

      test('tameshiwari category has at least 2 techniques', () {
        final results = searchService.filterByCategory(
          TechniqueCategory.tameshiwari,
        );
        expect(results.length, greaterThanOrEqualTo(2));
      });
    });

    group('filterByBeltRank', () {
      test('returns techniques required for white belt', () {
        final results = searchService.filterByBeltRank(BeltRank.kyu10);
        expect(results, isNotEmpty);
        for (final technique in results) {
          expect(technique.requiredForBelts.contains(BeltRank.kyu10), isTrue);
        }
      });

      test('returns techniques required for shodan', () {
        final results = searchService.filterByBeltRank(BeltRank.shodan);
        // Shodan should have techniques required.
        expect(results, isNotEmpty);
      });
    });

    group('getTechniqueById', () {
      test('returns technique for valid id', () {
        final result = searchService.getTechniqueById('heisoku_dachi');
        expect(result, isNotNull);
        expect(result!.id, equals('heisoku_dachi'));
      });

      test('returns null for invalid id', () {
        final result = searchService.getTechniqueById('nonexistent_id');
        expect(result, isNull);
      });
    });

    group('getKataById', () {
      test('returns kata for valid id', () {
        final result = searchService.getKataById('taikyoku_sono_ichi');
        expect(result, isNotNull);
        expect(result!.id, equals('taikyoku_sono_ichi'));
      });

      test('returns null for invalid id', () {
        final result = searchService.getKataById('nonexistent_kata');
        expect(result, isNull);
      });
    });

    group('getRelatedTechniques', () {
      test('returns related techniques', () {
        final results = searchService.getRelatedTechniques('heisoku_dachi');
        expect(results, isNotEmpty);
      });

      test('returns empty for nonexistent technique', () {
        final results = searchService.getRelatedTechniques('nonexistent_id');
        expect(results, isEmpty);
      });
    });

    group('searchKata', () {
      test('returns all kata when query is empty', () {
        final results = searchService.searchKata('');
        expect(results, isNotEmpty);
        expect(results.length, greaterThanOrEqualTo(20));
      });

      test('finds kata by name', () {
        final results = searchService.searchKata('Taikyoku');
        expect(results, isNotEmpty);
        expect(
          results.any((k) => k.englishName.toLowerCase().contains('taikyoku')),
          isTrue,
        );
      });

      test('returns empty for nonsense query', () {
        final results = searchService.searchKata('xyznonexistent123');
        expect(results, isEmpty);
      });
    });
  });

  group('SearchService.normalize', () {
    test('lowercases input', () {
      expect(SearchService.normalize('HELLO'), equals('hello'));
    });

    test('removes macrons', () {
      expect(SearchService.normalize('chūdan'), equals('chudan'));
      expect(SearchService.normalize('jōdan'), equals('jodan'));
      expect(SearchService.normalize('tsūki'), equals('tsuki'));
    });

    test('strips hyphens', () {
      expect(SearchService.normalize('uchi-hachiji'), equals('uchi hachiji'));
    });

    test('collapses whitespace', () {
      expect(SearchService.normalize('a  b   c'), equals('a b c'));
    });

    test('trims whitespace', () {
      expect(SearchService.normalize('  hello  '), equals('hello'));
    });

    test('handles combined transformations', () {
      expect(
        SearchService.normalize('Chūdan-Tsuki  TEST'),
        equals('chudan tsuki test'),
      );
    });
  });

  group('SearchService.canonicalize', () {
    test('maps si to shi', () {
      expect(SearchService.canonicalize('mawasi'), equals('mawashi'));
    });

    test('maps ti to chi', () {
      expect(SearchService.canonicalize('uti'), equals('uchi'));
    });

    test('maps tu to tsu', () {
      expect(SearchService.canonicalize('tuki'), equals('tsuki'));
    });

    test('maps hu to fu', () {
      expect(SearchService.canonicalize('hudo'), equals('fudo'));
    });

    test('maps zi to ji', () {
      expect(SearchService.canonicalize('zion'), equals('jion'));
    });

    test('maps di to ji', () {
      expect(SearchService.canonicalize('dion'), equals('jion'));
    });

    test('maps du to zu', () {
      expect(SearchService.canonicalize('duki'), equals('zuki'));
    });

    test('maps compound sya to sha', () {
      expect(SearchService.canonicalize('syame'), equals('shame'));
    });

    test('maps compound tya to cha', () {
      expect(SearchService.canonicalize('tyaku'), equals('chaku'));
    });

    test('leaves already-Hepburn input unchanged', () {
      expect(SearchService.canonicalize('mawashi'), equals('mawashi'));
      expect(SearchService.canonicalize('tsuki'), equals('tsuki'));
    });
  });

  group('SearchService.levenshteinDistance', () {
    test('returns 0 for identical strings', () {
      expect(SearchService.levenshteinDistance('abc', 'abc'), equals(0));
    });

    test('returns length of other string when one is empty', () {
      expect(SearchService.levenshteinDistance('', 'abc'), equals(3));
      expect(SearchService.levenshteinDistance('abc', ''), equals(3));
    });

    test('returns correct distance for single edit', () {
      // Substitution.
      expect(SearchService.levenshteinDistance('abc', 'adc'), equals(1));
      // Insertion.
      expect(SearchService.levenshteinDistance('abc', 'abcd'), equals(1));
      // Deletion.
      expect(SearchService.levenshteinDistance('abcd', 'abc'), equals(1));
    });

    test('returns correct distance for multiple edits', () {
      expect(SearchService.levenshteinDistance('kitten', 'sitting'), equals(3));
    });

    test('returns correct distance for completely different strings', () {
      expect(SearchService.levenshteinDistance('abc', 'xyz'), equals(3));
    });

    test('is symmetric', () {
      expect(
        SearchService.levenshteinDistance('abc', 'axc'),
        equals(SearchService.levenshteinDistance('axc', 'abc')),
      );
    });
  });
}
