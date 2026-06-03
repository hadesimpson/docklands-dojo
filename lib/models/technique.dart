import 'package:docklands_dojo/models/belt_rank.dart';

/// Technique categories following Kyokushin classification.
///
/// Includes the 9 standard categories: stances, punches, kicks, blocks,
/// strikes, elbow strikes, knee strikes, kata, and breaking.
/// Hiji (elbow) and hiza (knee) are Kyokushin signature categories.
enum TechniqueCategory {
  /// Stances (立ち).
  dachi,

  /// Punches (突き).
  tsuki,

  /// Kicks (蹴り).
  geri,

  /// Blocks (受け).
  uke,

  /// Strikes — hand/arm (打ち).
  uchi,

  /// Elbow strikes (肘) — Kyokushin signature.
  hiji,

  /// Knee strikes (膝) — Kyokushin signature.
  hiza,

  /// Forms (型).
  kata,

  /// Breaking (試し割り) — required from brown belt for Dan grading.
  tameshiwari,
}

/// A Kyokushin karate technique with full metadata.
///
/// Techniques are immutable and typically created as `const` instances
/// in the content data files. Each technique belongs to exactly one
/// [TechniqueCategory] and may be required for multiple belt ranks.
///
/// ```dart
/// const technique = Technique(
///   id: 'seiken_chudan_tsuki',
///   japaneseName: '正拳中段突き',
///   englishName: 'Middle-level straight punch',
///   romajiName: 'Seiken chūdan tsuki',
///   category: TechniqueCategory.tsuki,
///   description: 'A fundamental straight punch...',
///   keyPoints: ['Rotate hips', 'Pull back hikite'],
///   commonMistakes: ['Dropping elbow'],
///   requiredForBelts: [BeltRank.kyu10],
///   relatedTechniqueIds: ['seiken_jodan_tsuki'],
/// );
/// ```
class Technique {
  /// Unique identifier for the technique (e.g., 'seiken_chudan_tsuki').
  final String id;

  /// Japanese name in kanji/kana (e.g., '正拳中段突き').
  final String japaneseName;

  /// English translation (e.g., 'Middle-level straight punch').
  final String englishName;

  /// Romanized Japanese name (e.g., 'Seiken chūdan tsuki').
  final String romajiName;

  /// Which category this technique belongs to.
  final TechniqueCategory category;

  /// Detailed description of how to perform the technique.
  final String description;

  /// Key execution points to remember.
  final List<String> keyPoints;

  /// Common mistakes practitioners make.
  final List<String> commonMistakes;

  /// Belt ranks that require this technique in their syllabus.
  final List<BeltRank> requiredForBelts;

  /// IDs of related techniques for cross-referencing.
  final List<String> relatedTechniqueIds;

  /// Path to the technique illustration asset, if available.
  final String? imageAssetPath;

  /// URL to a video demonstration, if available (V2).
  final String? videoUrl;

  /// Creates a [Technique] with the given metadata.
  const Technique({
    required this.id,
    required this.japaneseName,
    required this.englishName,
    required this.romajiName,
    required this.category,
    required this.description,
    required this.keyPoints,
    required this.commonMistakes,
    required this.requiredForBelts,
    required this.relatedTechniqueIds,
    this.imageAssetPath,
    this.videoUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Technique && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Technique($id, $romajiName)';
}
