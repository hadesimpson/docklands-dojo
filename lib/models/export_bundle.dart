import 'package:docklands_dojo/models/user_progress.dart';

/// A bundle of all user data for export/import.
///
/// Contains all progress, review states, quiz history, and review
/// sessions. Includes the app version for forward compatibility
/// when importing on newer app versions.
///
/// ```dart
/// final bundle = ExportBundle(
///   appVersion: '1.0.0',
///   exportDate: DateTime.now(),
///   progress: userProgress,
///   reviewStates: cardStates,
///   quizHistory: attempts,
///   reviewSessions: sessions,
/// );
/// ```
class ExportBundle {
  /// App version that created this export (for forward compatibility).
  final String appVersion;

  /// Date and time when the export was created.
  final DateTime exportDate;

  /// The user's progress data (current rank, completed techniques, etc.).
  final UserProgress progress;

  /// All spaced repetition card review states.
  ///
  /// Typed as `List<Object>` for now — will be refined to
  /// `List<CardReviewState>` when flashcard models are added in CL8.
  final List<Object> reviewStates;

  /// History of all quiz attempts.
  ///
  /// Typed as `List<Object>` for now — will be refined to
  /// `List<QuizAttempt>` when quiz models are added in CL10.
  final List<Object> quizHistory;

  /// History of all review sessions.
  ///
  /// Typed as `List<Object>` for now — will be refined to
  /// `List<ReviewSession>` when flashcard models are added in CL8.
  final List<Object> reviewSessions;

  /// Creates an [ExportBundle] with the given data.
  const ExportBundle({
    required this.appVersion,
    required this.exportDate,
    required this.progress,
    required this.reviewStates,
    required this.quizHistory,
    required this.reviewSessions,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExportBundle &&
          appVersion == other.appVersion &&
          exportDate == other.exportDate;

  @override
  int get hashCode => Object.hash(appVersion, exportDate);

  @override
  String toString() => 'ExportBundle(v$appVersion, $exportDate)';
}
