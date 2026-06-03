import 'dart:math';

/// Service for fuzzy matching of Japanese romanization input.
///
/// Implements a multi-layer matching strategy from the PRD:
///
/// - **Layer 1**: Normalization (lowercase, strip hyphens, collapse whitespace,
///   remove macrons)
/// - **Layer 2**: Romanization canonical mapping (Kunrei → Hepburn)
/// - **Layer 3**: Edit distance (Levenshtein) with ≥ 80% similarity threshold
/// - **Layer 4**: Quality feedback (canonical spelling suggestion)
///
/// Used by both the technique search (CL7) and quiz fill-in-blank
/// scoring (CL10).
///
/// ```dart
/// final service = FuzzyMatchService();
/// final result = service.isMatch('mawasi geri', 'mawashi geri');
/// // result.isMatch == true
/// // result.canonicalSpelling == 'mawashi geri'
/// ```
class FuzzyMatchService {
  /// Romanization canonical mappings (Kunrei-shiki → Hepburn).
  static const Map<String, String> _romanizationMap = {
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

  /// Minimum similarity threshold for fuzzy matching (80%).
  static const double _similarityThreshold = 0.80;

  /// Normalizes input text for comparison.
  ///
  /// Applies Layer 1 transformations:
  /// - Lowercase
  /// - Strip hyphens
  /// - Collapse whitespace
  /// - Remove macrons (ō → o, ū → u, etc.)
  String normalize(String input) {
    var result = input.toLowerCase();
    // Remove macrons.
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

  /// Applies romanization canonical mapping (Layer 2).
  ///
  /// Converts Kunrei-shiki romanization to Hepburn standard.
  /// Processes longer mappings first to avoid partial replacements.
  String applyRomanizationMapping(String input) {
    var result = input;
    // Sort by key length descending to match longer patterns first.
    final sortedEntries = _romanizationMap.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    for (final entry in sortedEntries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  /// Calculates the Levenshtein edit distance between two strings.
  int levenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    final m = s.length;
    final n = t.length;

    // Use two rows instead of full matrix for space efficiency.
    var previousRow = List<int>.generate(n + 1, (i) => i);
    var currentRow = List<int>.filled(n + 1, 0);

    for (var i = 1; i <= m; i++) {
      currentRow[0] = i;
      for (var j = 1; j <= n; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        currentRow[j] = [
          currentRow[j - 1] + 1, // insertion
          previousRow[j] + 1, // deletion
          previousRow[j - 1] + cost, // substitution
        ].reduce(min);
      }
      final temp = previousRow;
      previousRow = currentRow;
      currentRow = temp;
    }

    return previousRow[n];
  }

  /// Calculates similarity between two strings (0.0 to 1.0).
  ///
  /// Based on Levenshtein distance normalized by the length of
  /// the longer string.
  double similarity(String s, String t) {
    if (s == t) return 1.0;
    if (s.isEmpty || t.isEmpty) return 0.0;
    final maxLen = max(s.length, t.length);
    final distance = levenshteinDistance(s, t);
    return 1.0 - (distance / maxLen);
  }

  /// Checks if [input] fuzzy-matches [target].
  ///
  /// Applies all 4 layers of the matching pipeline:
  /// 1. Normalization
  /// 2. Romanization canonical mapping
  /// 3. Levenshtein similarity ≥ 80%
  /// 4. Returns canonical spelling for feedback
  ///
  /// Returns a [FuzzyMatchResult] with match status and details.
  FuzzyMatchResult isMatch(String input, String target) {
    final normalizedInput = normalize(input);
    final normalizedTarget = normalize(target);

    // Exact match after normalization.
    if (normalizedInput == normalizedTarget) {
      return FuzzyMatchResult(
        isMatch: true,
        similarity: 1.0,
        canonicalSpelling: target,
        wasExactMatch: true,
      );
    }

    // Apply romanization mapping.
    final mappedInput = applyRomanizationMapping(normalizedInput);
    final mappedTarget = applyRomanizationMapping(normalizedTarget);

    // Exact match after romanization mapping.
    if (mappedInput == mappedTarget) {
      return FuzzyMatchResult(
        isMatch: true,
        similarity: 1.0,
        canonicalSpelling: target,
        wasExactMatch: false,
      );
    }

    // Levenshtein similarity check.
    final sim = similarity(mappedInput, mappedTarget);
    return FuzzyMatchResult(
      isMatch: sim >= _similarityThreshold,
      similarity: sim,
      canonicalSpelling: target,
      wasExactMatch: false,
    );
  }
}

/// Result of a fuzzy match operation.
///
/// Contains match status, similarity score, and the canonical
/// (standard Hepburn) spelling for user feedback.
class FuzzyMatchResult {
  /// Whether the input matched the target within threshold.
  final bool isMatch;

  /// Similarity score between 0.0 (no match) and 1.0 (exact match).
  final double similarity;

  /// The standard/canonical spelling of the target term.
  final String canonicalSpelling;

  /// Whether the match was exact (no fuzzy matching needed).
  final bool wasExactMatch;

  /// Creates a [FuzzyMatchResult].
  const FuzzyMatchResult({
    required this.isMatch,
    required this.similarity,
    required this.canonicalSpelling,
    required this.wasExactMatch,
  });

  @override
  String toString() =>
      'FuzzyMatchResult(match=$isMatch, sim=${similarity.toStringAsFixed(2)}, '
      'canonical=$canonicalSpelling)';
}
