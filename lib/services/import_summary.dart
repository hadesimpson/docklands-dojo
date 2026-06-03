/// Summary of a data import operation.
///
/// Provides counts of restored items and any warnings encountered
/// during the import process (e.g., future dates clamped, missing fields).
///
/// ```dart
/// final summary = ImportSummary(
///   progressRestored: true,
///   advancementsCount: 3,
///   sessionsCount: 42,
///   cardStatesCount: 150,
///   quizAttemptsCount: 8,
///   warnings: ['2 dates were in the future and were clamped to today'],
/// );
/// ```
class ImportSummary {
  /// Whether the user progress record was successfully restored.
  final bool progressRestored;

  /// Number of belt advancement records imported.
  final int advancementsCount;

  /// Number of training session records imported.
  final int sessionsCount;

  /// Number of card review state records imported.
  final int cardStatesCount;

  /// Number of quiz attempt records imported.
  final int quizAttemptsCount;

  /// Warnings encountered during import (non-fatal issues).
  ///
  /// Examples: future dates, clamped values, missing optional fields.
  final List<String> warnings;

  /// Creates an [ImportSummary] with the given counts and warnings.
  const ImportSummary({
    required this.progressRestored,
    required this.advancementsCount,
    required this.sessionsCount,
    required this.cardStatesCount,
    required this.quizAttemptsCount,
    this.warnings = const [],
  });

  /// Total number of records imported across all categories.
  int get totalRecords =>
      advancementsCount + sessionsCount + cardStatesCount + quizAttemptsCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImportSummary &&
          progressRestored == other.progressRestored &&
          advancementsCount == other.advancementsCount &&
          sessionsCount == other.sessionsCount &&
          cardStatesCount == other.cardStatesCount &&
          quizAttemptsCount == other.quizAttemptsCount;

  @override
  int get hashCode => Object.hash(
    progressRestored,
    advancementsCount,
    sessionsCount,
    cardStatesCount,
    quizAttemptsCount,
  );

  @override
  String toString() =>
      'ImportSummary(progress=$progressRestored, '
      'advancements=$advancementsCount, sessions=$sessionsCount, '
      'cards=$cardStatesCount, quizzes=$quizAttemptsCount, '
      'warnings=${warnings.length})';
}
