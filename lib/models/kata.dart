import 'package:docklands_dojo/models/belt_rank.dart';

/// A Kyokushin kata (form) with full metadata.
///
/// Kata are predefined sequences of movements that encode fighting
/// techniques. Each kata has a minimum belt rank requirement and
/// an ordered movement sequence.
///
/// The [bunkai] field is nullable for V2 — kata application /
/// self-defense interpretation will be added in a future release.
///
/// ```dart
/// const kata = Kata(
///   id: 'taikyoku_sono_ichi',
///   japaneseName: '太極その一',
///   englishName: 'Taikyoku Sono Ichi',
///   meaning: 'First Cause, Number One',
///   moveCount: 20,
///   minimumRank: BeltRank.kyu10,
///   movementSequence: ['Turn left', 'Gedan barai', ...],
///   history: 'Created by Sosai Mas Oyama...',
///   keyPrinciples: ['Strong stances', 'Full hip rotation'],
/// );
/// ```
class Kata {
  /// Unique identifier for the kata (e.g., 'taikyoku_sono_ichi').
  final String id;

  /// Japanese name in kanji/kana (e.g., '太極その一').
  final String japaneseName;

  /// English/romanized name (e.g., 'Taikyoku Sono Ichi').
  final String englishName;

  /// Meaning or translation of the kata name (e.g., 'First Cause, Number One').
  final String meaning;

  /// Total number of movements in the kata.
  final int moveCount;

  /// Minimum belt rank required to learn this kata.
  final BeltRank minimumRank;

  /// Ordered sequence of movement descriptions.
  final List<String> movementSequence;

  /// Historical background and origin of the kata.
  final String history;

  /// Core principles and concepts emphasized in the kata.
  final List<String> keyPrinciples;

  /// Kata application / self-defense interpretation.
  ///
  /// Nullable for V2 — will be populated in a future release.
  final List<String>? bunkai;

  /// Creates a [Kata] with the given metadata.
  const Kata({
    required this.id,
    required this.japaneseName,
    required this.englishName,
    required this.meaning,
    required this.moveCount,
    required this.minimumRank,
    required this.movementSequence,
    required this.history,
    required this.keyPrinciples,
    this.bunkai,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Kata && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Kata($id, $englishName)';
}
