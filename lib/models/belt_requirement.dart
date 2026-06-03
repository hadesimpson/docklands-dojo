import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/fitness.dart';
import 'package:docklands_dojo/models/kumite.dart';

/// Complete set of requirements for a specific belt rank grading.
///
/// Each [BeltRequirement] encapsulates everything a student must demonstrate
/// to advance to the specified [rank], including kihon (basics), kata,
/// kumite (sparring), fitness standards, terminology, and ido geiko
/// (moving combinations).
///
/// ```dart
/// const requirement = BeltRequirement(
///   rank: BeltRank.kyu10,
///   japaneseName: 'Jūkyū',
///   colorDescription: 'White',
///   requiredKihon: ['seiken_chudan_tsuki'],
///   requiredKata: ['taikyoku_sono_ichi'],
///   kumiteRequirements: [],
///   fitnessRequirements: [FitnessRequirement(exerciseName: 'Push-ups', targetCount: 20)],
///   terminology: ['Osu'],
///   idoGeiko: [],
///   minimumTimeInGrade: Duration(days: 90),
///   minimumTrainingSessions: 20,
/// );
/// ```
class BeltRequirement {
  /// The belt rank this requirement is for.
  final BeltRank rank;

  /// Japanese name for this rank (e.g., 'Jūkyū').
  final String japaneseName;

  /// Human-readable color description (e.g., 'Orange with Blue stripe').
  final String colorDescription;

  /// Technique IDs required for this rank, validated against techniques_data.
  final List<String> requiredKihon;

  /// Kata IDs required for this rank, validated against kata_data.
  final List<String> requiredKata;

  /// Kumite (sparring) requirements for grading.
  final List<KumiteRequirement> kumiteRequirements;

  /// Fitness standards that must be met during grading.
  final List<FitnessRequirement> fitnessRequirements;

  /// Japanese terminology the student should know at this level.
  final List<String> terminology;

  /// Moving combination sequences (ido geiko) required.
  final List<String> idoGeiko;

  /// Minimum time that must be spent at the previous rank.
  final Duration minimumTimeInGrade;

  /// Minimum number of training sessions required before grading.
  final int minimumTrainingSessions;

  /// Creates a [BeltRequirement] with the given parameters.
  const BeltRequirement({
    required this.rank,
    required this.japaneseName,
    required this.colorDescription,
    required this.requiredKihon,
    required this.requiredKata,
    required this.kumiteRequirements,
    required this.fitnessRequirements,
    required this.terminology,
    required this.idoGeiko,
    required this.minimumTimeInGrade,
    required this.minimumTrainingSessions,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BeltRequirement && rank == other.rank;

  @override
  int get hashCode => rank.hashCode;

  @override
  String toString() => 'BeltRequirement($rank, $colorDescription)';
}
