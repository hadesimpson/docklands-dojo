import 'dart:math' as math;

import 'package:docklands_dojo/data/kata_data.dart';
import 'package:docklands_dojo/data/techniques_data.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/kata.dart';
import 'package:docklands_dojo/models/technique.dart';

/// Search and filter service for techniques and kata.
///
/// Implements the PRD's 4-layer fuzzy matching specification for Japanese
/// romanization:
///
/// 1. **Exact match** — direct substring on japaneseName, englishName, romajiName
/// 2. **Normalization** — strip macrons (ō→o, ū→u), hyphens, collapse whitespace
/// 3. **Romanization canonical mapping** — Kunrei→Hepburn (si→shi, ti→chi, etc.)
/// 4. **Levenshtein similarity** — threshold ≥ 80% on normalized strings
///
/// See PRD Section 3, F2: Fuzzy Matching Specification.
class SearchService {
  /// Creates a [SearchService].
  const SearchService();

  /// Searches techniques matching [query] with optional [category] and
  /// [beltRank] filters.
  ///
  /// Returns techniques ordered by match quality: exact matches first,
  /// then normalized matches, then fuzzy matches.
  ///
  /// Returns an empty list if [query] is empty and no filters are applied.
  List<Technique> searchTechniques(
    String query, {
    TechniqueCategory? category,
    BeltRank? beltRank,
  }) {
    var results = List<Technique>.from(allTechniques);

    // Apply category filter.
    if (category != null) {
      results = results.where((t) => t.category == category).toList();
    }

    // Apply belt rank filter.
    if (beltRank != null) {
      results = results
          .where((t) => t.requiredForBelts.contains(beltRank))
          .toList();
    }

    // Apply search query.
    if (query.trim().isEmpty) {
      return results;
    }

    return _fuzzyMatchTechniques(results, query);
  }

  /// Searches kata matching [query].
  ///
  /// Matches against japaneseName, englishName, and meaning fields.
  List<Kata> searchKata(String query) {
    if (query.trim().isEmpty) {
      return List<Kata>.from(allKata);
    }

    return _fuzzyMatchKata(allKata, query);
  }

  /// Filters techniques by [category].
  List<Technique> filterByCategory(TechniqueCategory category) {
    return allTechniques.where((t) => t.category == category).toList();
  }

  /// Filters techniques by [beltRank].
  ///
  /// Returns techniques that are required for the given belt rank.
  List<Technique> filterByBeltRank(BeltRank beltRank) {
    return allTechniques
        .where((t) => t.requiredForBelts.contains(beltRank))
        .toList();
  }

  /// Gets a technique by its [id], or `null` if not found.
  Technique? getTechniqueById(String id) {
    for (final technique in allTechniques) {
      if (technique.id == id) return technique;
    }
    return null;
  }

  /// Gets a kata by its [id], or `null` if not found.
  Kata? getKataById(String id) {
    for (final kata in allKata) {
      if (kata.id == id) return kata;
    }
    return null;
  }

  /// Gets related techniques for a given technique [id].
  List<Technique> getRelatedTechniques(String techniqueId) {
    final technique = getTechniqueById(techniqueId);
    if (technique == null) return [];

    return technique.relatedTechniqueIds
        .map(getTechniqueById)
        .whereType<Technique>()
        .toList();
  }

  // ── Private: Fuzzy Matching Engine ──────────────────────────────────────

  List<Technique> _fuzzyMatchTechniques(
    List<Technique> candidates,
    String query,
  ) {
    final scored = <_ScoredItem<Technique>>[];

    for (final technique in candidates) {
      final score = _bestMatchScore(query, [
        technique.japaneseName,
        technique.englishName,
        technique.romajiName,
      ]);
      if (score != null) {
        scored.add(_ScoredItem(technique, score));
      }
    }

    // Sort by score (lower is better).
    scored.sort((a, b) => a.score.compareTo(b.score));
    return scored.map((s) => s.item).toList();
  }

  List<Kata> _fuzzyMatchKata(List<Kata> candidates, String query) {
    final scored = <_ScoredItem<Kata>>[];

    for (final kata in candidates) {
      final score = _bestMatchScore(query, [
        kata.japaneseName,
        kata.englishName,
        kata.meaning,
      ]);
      if (score != null) {
        scored.add(_ScoredItem(kata, score));
      }
    }

    scored.sort((a, b) => a.score.compareTo(b.score));
    return scored.map((s) => s.item).toList();
  }

  /// Returns the best match score across multiple [targets], or `null`
  /// if no match.
  ///
  /// Score tiers: 0 = exact, 1 = normalized, 2 = canonical, 3 = levenshtein.
  int? _bestMatchScore(String query, List<String> targets) {
    final queryLower = query.toLowerCase();
    final queryNorm = normalize(query);
    final queryCanon = canonicalize(queryNorm);

    int? bestScore;

    for (final target in targets) {
      final targetLower = target.toLowerCase();
      final targetNorm = normalize(target);
      final targetCanon = canonicalize(targetNorm);

      // Layer 1: Exact substring match.
      if (targetLower.contains(queryLower)) {
        bestScore = _min(bestScore, 0);
        continue;
      }

      // Layer 2: Normalized match (macrons stripped, hyphens removed).
      if (targetNorm.contains(queryNorm)) {
        bestScore = _min(bestScore, 1);
        continue;
      }

      // Layer 3: Canonical romanization match (Kunrei → Hepburn).
      if (targetCanon.contains(queryCanon)) {
        bestScore = _min(bestScore, 2);
        continue;
      }

      // Layer 4: Levenshtein similarity ≥ 80% (PRD spec).
      final distance = levenshteinDistance(queryCanon, targetCanon);
      final maxLen = math.max(queryCanon.length, targetCanon.length);
      final similarity = maxLen > 0 ? 1.0 - (distance / maxLen) : 0.0;
      if (similarity >= 0.8) {
        bestScore = _min(bestScore, 3);
      }
    }

    return bestScore;
  }

  int _min(int? a, int b) => a == null ? b : math.min(a, b);

  // ── Static: Normalization & Canonicalization ────────────────────────────

  /// Normalizes a string by lowercasing, removing macrons, stripping
  /// hyphens, and collapsing whitespace.
  ///
  /// This is Layer 1 of the fuzzy matching specification.
  static String normalize(String input) {
    var result = input.toLowerCase();

    // Remove macrons: ō → o, ū → u, ā → a, ē → e, ī → i.
    result = result
        .replaceAll('ō', 'o')
        .replaceAll('ū', 'u')
        .replaceAll('ā', 'a')
        .replaceAll('ē', 'e')
        .replaceAll('ī', 'i');

    // Strip hyphens.
    result = result.replaceAll('-', ' ');

    // Collapse whitespace.
    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();

    return result;
  }

  /// Applies Kunrei→Hepburn romanization canonical mapping.
  ///
  /// This is Layer 2 of the fuzzy matching specification.
  /// Maps common Kunrei-shiki romanizations to Hepburn equivalents.
  static String canonicalize(String input) {
    var result = input;

    // Order matters — apply longer patterns first to avoid partial matches.
    const mappings = <String, String>{
      'sya': 'sha',
      'syu': 'shu',
      'syo': 'sho',
      'tya': 'cha',
      'tyu': 'chu',
      'tyo': 'cho',
      'si': 'shi',
      'ti': 'chi',
      'tu': 'tsu',
      'hu': 'fu',
      'zi': 'ji',
      'di': 'ji',
      'du': 'zu',
      'sy': 'sh',
      'ty': 'ch',
    };

    for (final entry in mappings.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }

    return result;
  }

  /// Computes the Levenshtein edit distance between two strings.
  ///
  /// Used for Layer 4 of the fuzzy matching specification.
  /// Returns the minimum number of single-character edits (insertions,
  /// deletions, or substitutions) required to change [source] into [target].
  static int levenshteinDistance(String source, String target) {
    if (source == target) return 0;
    if (source.isEmpty) return target.length;
    if (target.isEmpty) return source.length;

    final sLen = source.length;
    final tLen = target.length;

    // Use two rows instead of full matrix for memory efficiency.
    var previousRow = List<int>.generate(tLen + 1, (i) => i);
    var currentRow = List<int>.filled(tLen + 1, 0);

    for (var i = 1; i <= sLen; i++) {
      currentRow[0] = i;

      for (var j = 1; j <= tLen; j++) {
        final cost = source[i - 1] == target[j - 1] ? 0 : 1;
        currentRow[j] = math.min(
          math.min(currentRow[j - 1] + 1, previousRow[j] + 1),
          previousRow[j - 1] + cost,
        );
      }

      // Swap rows.
      final temp = previousRow;
      previousRow = currentRow;
      currentRow = temp;
    }

    return previousRow[tLen];
  }
}

/// Internal scored item for sorting search results by match quality.
class _ScoredItem<T> {
  final T item;
  final int score;

  const _ScoredItem(this.item, this.score);
}
