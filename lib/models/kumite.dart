/// Kumite (sparring) types following IKO-1 Kyokushin standard.
///
/// Ordered from most structured (yakusoku) to least structured (tournament).
/// Higher belt ranks require more advanced kumite types.
enum KumiteType {
  /// Prearranged sparring — predetermined attack and defense sequences.
  yakusoku,

  /// 3-step sparring — attacker steps forward three times with set attacks.
  sanbon,

  /// 1-step sparring — single attack with free defense.
  ippon,

  /// Free sparring — full contact, no predetermined techniques.
  jiyu,

  /// Tournament rules — timed rounds with scoring.
  tournament,
}

/// A structured kumite (sparring) requirement for belt grading.
///
/// Specifies the type of sparring, description, number of rounds,
/// and round duration as required by the IKO-1 grading syllabus.
///
/// ```dart
/// const requirement = KumiteRequirement(
///   type: KumiteType.jiyu,
///   description: 'Full contact free sparring',
///   rounds: 3,
///   roundDuration: Duration(minutes: 1, seconds: 30),
/// );
/// ```
class KumiteRequirement {
  /// The type of kumite required.
  final KumiteType type;

  /// Human-readable description of the requirement.
  final String description;

  /// Number of rounds required, if applicable.
  final int? rounds;

  /// Duration of each round, if applicable.
  final Duration? roundDuration;

  /// Creates a [KumiteRequirement] with the given parameters.
  const KumiteRequirement({
    required this.type,
    required this.description,
    this.rounds,
    this.roundDuration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KumiteRequirement &&
          type == other.type &&
          description == other.description &&
          rounds == other.rounds &&
          roundDuration == other.roundDuration;

  @override
  int get hashCode => Object.hash(type, description, rounds, roundDuration);

  @override
  String toString() => 'KumiteRequirement($type, $description)';
}
