import 'package:docklands_dojo/models/belt_rank.dart';

/// Tracks a user's overall progress through the Kyokushin belt system.
///
/// Maintains the current belt rank, completed techniques, advancement
/// history, and training session log. All fields are immutable;
/// create a new instance to record updates.
///
/// ```dart
/// final progress = UserProgress(
///   currentRank: BeltRank.kyu10,
///   completedTechniques: {'seiken_chudan_tsuki': true},
///   advancementHistory: [],
///   trainingLog: [],
///   startDate: DateTime.now(),
/// );
/// ```
class UserProgress {
  /// The user's current belt rank.
  final BeltRank currentRank;

  /// Map of technique IDs to completion status.
  ///
  /// Keys are technique IDs from the syllabus data. A value of `true`
  /// means the user has marked this technique as learned.
  final Map<String, bool> completedTechniques;

  /// Chronological history of belt advancement events.
  final List<BeltAdvancement> advancementHistory;

  /// Chronological log of training sessions.
  final List<TrainingSession> trainingLog;

  /// Date when the user started tracking progress.
  final DateTime startDate;

  /// Creates a [UserProgress] with the given state.
  const UserProgress({
    required this.currentRank,
    required this.completedTechniques,
    required this.advancementHistory,
    required this.trainingLog,
    required this.startDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgress &&
          currentRank == other.currentRank &&
          startDate == other.startDate;

  @override
  int get hashCode => Object.hash(currentRank, startDate);

  @override
  String toString() => 'UserProgress($currentRank, started: $startDate)';
}

/// Records a belt advancement event.
///
/// Captures the transition from one rank to the next, including
/// the date and optional notes about the grading.
class BeltAdvancement {
  /// The belt rank before advancement.
  final BeltRank fromRank;

  /// The belt rank after advancement.
  final BeltRank toRank;

  /// Date when the advancement occurred.
  final DateTime date;

  /// Optional notes about the grading (e.g., 'Passed with distinction').
  final String? notes;

  /// Creates a [BeltAdvancement] record.
  const BeltAdvancement({
    required this.fromRank,
    required this.toRank,
    required this.date,
    this.notes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeltAdvancement &&
          fromRank == other.fromRank &&
          toRank == other.toRank &&
          date == other.date;

  @override
  int get hashCode => Object.hash(fromRank, toRank, date);

  @override
  String toString() =>
      'BeltAdvancement(${fromRank.name} → ${toRank.name}, $date)';
}

/// Records a single training session.
///
/// Used for tracking attendance and time-in-grade requirements.
class TrainingSession {
  /// Date when the training session occurred.
  final DateTime date;

  /// Duration of the training session.
  final Duration duration;

  /// Optional notes about the session (e.g., 'Focused on kata').
  final String? notes;

  /// Creates a [TrainingSession] record.
  const TrainingSession({
    required this.date,
    required this.duration,
    this.notes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TrainingSession && date == other.date;

  @override
  int get hashCode => date.hashCode;

  @override
  String toString() => 'TrainingSession($date, $duration)';
}
