/// A structured fitness requirement for belt grading.
///
/// Each belt rank in the IKO-1 syllabus specifies minimum fitness
/// standards (push-ups, sit-ups, squats, etc.) that must be
/// demonstrated during grading.
///
/// ```dart
/// const requirement = FitnessRequirement(
///   exerciseName: 'Push-ups',
///   targetCount: 20,
///   unit: 'reps',
///   notes: 'On knuckles',
/// );
/// ```
class FitnessRequirement {
  /// Name of the exercise (e.g., 'Push-ups', 'Sit-ups', 'Squats').
  final String exerciseName;

  /// Target count to achieve (e.g., 20 push-ups).
  final int targetCount;

  /// Unit of measurement (e.g., 'reps', 'seconds', 'rounds').
  ///
  /// Nullable — defaults to 'reps' conceptually when not specified.
  final String? unit;

  /// Additional notes about the exercise (e.g., 'On knuckles').
  final String? notes;

  /// Creates a [FitnessRequirement] with the given parameters.
  const FitnessRequirement({
    required this.exerciseName,
    required this.targetCount,
    this.unit,
    this.notes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitnessRequirement &&
          exerciseName == other.exerciseName &&
          targetCount == other.targetCount &&
          unit == other.unit &&
          notes == other.notes;

  @override
  int get hashCode => Object.hash(exerciseName, targetCount, unit, notes);

  @override
  String toString() => 'FitnessRequirement($exerciseName, $targetCount)';
}
