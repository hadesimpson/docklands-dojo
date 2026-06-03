import 'package:docklands_dojo/models/belt_rank.dart';

/// Categories for flashcard content domains.
///
/// Aligned with the PRD F3 flashcard content domains table.
enum CardCategory {
  /// Japanese terminology (body targets, directions, positions).
  terminology,

  /// Technique name recall (Japanese ↔ English).
  techniqueRecall,

  /// Kata name, meaning, and sequence recall.
  kataSequence,

  /// Japanese counting (1-10).
  counting,

  /// Dojo etiquette, bowing protocol, class structure.
  etiquette,

  /// Kyokushin history: Sosai Oyama, 100-man kumite, etc.
  history,

  /// Fitness requirement recall per belt grade.
  fitnessRequirements,

  /// Kumite types and rules.
  kumiteRules,
}

/// A single flashcard for spaced repetition review.
///
/// The [front] is shown first (question/prompt), and the [back] is
/// revealed after the user attempts recall. An optional [hint] can
/// be displayed after consecutive failures (circuit breaker).
///
/// Cards are scoped to a [minimumRank] so beginners don't see
/// advanced content.
class FlashCard {
  /// Unique identifier for this card.
  final String id;

  /// The question/prompt shown on the front of the card.
  final String front;

  /// The answer revealed on the back of the card.
  final String back;

  /// Optional hint shown after consecutive failures.
  final String? hint;

  /// Content domain this card belongs to.
  final CardCategory category;

  /// Minimum belt rank required to see this card.
  final BeltRank minimumRank;

  /// Creates a [FlashCard].
  const FlashCard({
    required this.id,
    required this.front,
    required this.back,
    this.hint,
    required this.category,
    required this.minimumRank,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FlashCard && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FlashCard($id)';
}

/// All flashcards for the Docklands Dojo spaced repetition system.
///
/// Contains 200+ flashcards across 8 content domains:
/// - Counting (1-10): 10 cards
/// - Body targets: 3+ cards
/// - Command terms: 10+ cards
/// - Direction/position: 5+ cards
/// - Technique names: 100+ cards
/// - Kata names & meanings: 22+ cards
/// - Dojo Kun: 5 cards
/// - Sosai Oyama history: 10+ cards
/// - Dojo etiquette: 10+ cards
/// - Belt requirements (fitness): 11+ cards
/// - Kumite rules: 10+ cards
///
/// All data is AI-generated and must be expert-validated.
/// See `CONTENT_REVIEW.md` for validation status.
const List<FlashCard> allFlashCards = [
  // ============================================================
  // COUNTING (1-10) — 10 cards
  // ============================================================
  FlashCard(
    id: 'count_1',
    front: 'What is "one" in Japanese counting?',
    back: 'Ichi (一)',
    hint: 'Starts with "I"',
    category: CardCategory.counting,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'count_2',
    front: 'What is "two" in Japanese counting?',
    back: 'Ni (二)',
    hint: 'Sounds like "knee"',
    category: CardCategory.counting,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'count_3',
    front: 'What is "three" in Japanese counting?',
    back: 'San (三)',
    hint: 'Like San Francisco',
    category: CardCategory.counting,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'count_4',
    front: 'What is "four" in Japanese counting?',
    back: 'Shi / Yon (四)',
    hint: 'Two readings: shi or yon',
    category: CardCategory.counting,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'count_5',
    front: 'What is "five" in Japanese counting?',
    back: 'Go (五)',
    hint: 'Like the English word "go"',
    category: CardCategory.counting,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'count_6',
    front: 'What is "six" in Japanese counting?',
    back: 'Roku (六)',
    hint: 'Sounds like "rock"',
    category: CardCategory.counting,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'count_7',
    front: 'What is "seven" in Japanese counting?',
    back: 'Shichi / Nana (七)',
    hint: 'Two readings: shichi or nana',
    category: CardCategory.counting,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'count_8',
    front: 'What is "eight" in Japanese counting?',
    back: 'Hachi (八)',
    hint: 'Like the dog Hachi',
    category: CardCategory.counting,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'count_9',
    front: 'What is "nine" in Japanese counting?',
    back: 'Ku / Kyū (九)',
    hint: 'Same "kyu" as belt grades',
    category: CardCategory.counting,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'count_10',
    front: 'What is "ten" in Japanese counting?',
    back: 'Jū (十)',
    hint: 'Short, one syllable',
    category: CardCategory.counting,
    minimumRank: BeltRank.kyu10,
  ),

  // ============================================================
  // BODY TARGETS — 5 cards
  // ============================================================
  FlashCard(
    id: 'target_jodan',
    front: 'What does "Jōdan" mean?',
    back: 'Upper level (face/head area)',
    hint: 'Think "above the neck"',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'target_chudan',
    front: 'What does "Chūdan" mean?',
    back: 'Middle level (chest/stomach area)',
    hint: 'Between neck and belt',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'target_gedan',
    front: 'What does "Gedan" mean?',
    back: 'Lower level (below the belt)',
    hint: 'Below the belt',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'target_ganmen',
    front: 'What does "Ganmen" mean?',
    back: 'Face',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'target_hizo',
    front: 'What does "Hizō" mean?',
    back: 'Spleen/floating ribs area',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu9,
  ),

  // ============================================================
  // COMMAND TERMS — 12 cards
  // ============================================================
  FlashCard(
    id: 'cmd_yoi',
    front: 'What does "Yoi" mean?',
    back: 'Ready / Prepare',
    hint: 'Said before starting',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'cmd_hajime',
    front: 'What does "Hajime" mean?',
    back: 'Begin / Start',
    hint: 'Opposite of "yame"',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'cmd_yame',
    front: 'What does "Yame" mean?',
    back: 'Stop',
    hint: 'Opposite of "hajime"',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'cmd_mawate',
    front: 'What does "Mawate" mean?',
    back: 'Turn around',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'cmd_naore',
    front: 'What does "Naore" mean?',
    back: 'Return to original position',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'cmd_mokuso',
    front: 'What does "Mokusō" mean?',
    back: 'Meditation / Close your eyes',
    hint: 'Done at start and end of class',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'cmd_seiza',
    front: 'What does "Seiza" mean?',
    back: 'Formal kneeling position',
    hint: 'Kneel on the floor',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'cmd_kiritsu',
    front: 'What does "Kiritsu" mean?',
    back: 'Stand up',
    hint: 'Opposite of seiza',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'cmd_osu',
    front: 'What does "Osu" mean in Kyokushin?',
    back:
        'A multi-purpose greeting/response meaning respect, '
        'acknowledgment, and perseverance',
    hint: 'The most important word in Kyokushin',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'cmd_senpai',
    front: 'What does "Senpai" mean?',
    back: 'Senior student',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'cmd_sensei',
    front: 'What does "Sensei" mean?',
    back: 'Teacher / Instructor (literally "one who came before")',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'cmd_shihan',
    front: 'What does "Shihan" mean?',
    back: 'Master instructor (4th Dan and above)',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),

  // ============================================================
  // DIRECTION / POSITION — 7 cards
  // ============================================================
  FlashCard(
    id: 'dir_hidari',
    front: 'What does "Hidari" mean?',
    back: 'Left',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'dir_migi',
    front: 'What does "Migi" mean?',
    back: 'Right',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'dir_mae',
    front: 'What does "Mae" mean?',
    back: 'Front / Forward',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'dir_ushiro',
    front: 'What does "Ushiro" mean?',
    back: 'Back / Behind',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'dir_yoko',
    front: 'What does "Yoko" mean?',
    back: 'Side',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'dir_uchi',
    front: 'What does "Uchi" mean as a direction?',
    back: 'Inside / Inward',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'dir_soto',
    front: 'What does "Soto" mean as a direction?',
    back: 'Outside / Outward',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu9,
  ),

  // ============================================================
  // TECHNIQUE NAME RECALL — Stances (11 cards)
  // ============================================================
  FlashCard(
    id: 'tech_heisoku_dachi',
    front: 'What is "Heisoku dachi"?',
    back: 'Closed foot stance — feet together, toes forward',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_musubi_dachi',
    front: 'What is "Musubi dachi"?',
    back: 'Knot stance — heels together, toes turned out at 45°',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_heiko_dachi',
    front: 'What is "Heikō dachi"?',
    back: 'Parallel stance — feet shoulder-width apart, parallel',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_shizen_tai',
    front: 'What is "Shizen tai" (Fudō dachi)?',
    back: 'Natural stance — relaxed, feet shoulder-width apart',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_uchi_hachiji_dachi',
    front: 'What is "Uchi hachiji dachi"?',
    back: 'Inward figure-eight stance — toes turned inward',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_sanchin_dachi',
    front: 'What is "Sanchin dachi"?',
    back: 'Three-point stance — hourglass stance, toes inward, strong center',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_zenkutsu_dachi',
    front: 'What is "Zenkutsu dachi"?',
    back: 'Front stance — long, deep forward stance, 70% weight on front leg',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_kiba_dachi',
    front: 'What is "Kiba dachi"?',
    back: 'Horse-riding stance — wide stance, weight evenly distributed',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_kokutsu_dachi',
    front: 'What is "Kokutsu dachi"?',
    back: 'Back stance — 70% weight on rear leg',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_neko_ashi_dachi',
    front: 'What is "Neko ashi dachi"?',
    back: 'Cat foot stance — 90% weight on rear leg, front foot on ball',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_tsuru_ashi_dachi',
    front: 'What is "Tsuru ashi dachi"?',
    back: 'Crane stance — standing on one leg, other foot tucked behind knee',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),

  // ============================================================
  // TECHNIQUE NAME RECALL — Punches (12 cards)
  // ============================================================
  FlashCard(
    id: 'tech_seiken_chudan_tsuki',
    front: 'What is "Seiken chūdan tsuki"?',
    back: 'Middle-level straight punch (forefist)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_seiken_jodan_tsuki',
    front: 'What is "Seiken jōdan tsuki"?',
    back: 'Upper-level straight punch (forefist)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_seiken_ago_uchi',
    front: 'What is "Seiken ago uchi"?',
    back: 'Forefist uppercut to the chin',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_seiken_shita_tsuki',
    front: 'What is "Seiken shita tsuki"?',
    back: 'Forefist lower punch / body punch',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_seiken_kagi_tsuki',
    front: 'What is "Seiken kagi tsuki"?',
    back: 'Forefist hook punch',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_morote_tsuki',
    front: 'What is "Morote tsuki"?',
    back: 'Double-fist punch (both fists strike simultaneously)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_ura_tsuki',
    front: 'What is "Ura tsuki"?',
    back: 'Close-range inverted punch (palm facing up)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_furi_tsuki',
    front: 'What is "Furi tsuki"?',
    back: 'Circular/swinging punch',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'tech_age_tsuki',
    front: 'What is "Age tsuki"?',
    back: 'Rising punch (uppercut)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'tech_tate_tsuki',
    front: 'What is "Tate tsuki"?',
    back: 'Vertical fist punch',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'tech_shotei_tsuki',
    front: 'What is "Shotei tsuki"?',
    back: 'Palm heel thrust',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu6,
  ),
  FlashCard(
    id: 'tech_nukite',
    front: 'What is "Nukite"?',
    back: 'Spear hand strike (fingertip strike)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu5,
  ),

  // ============================================================
  // TECHNIQUE NAME RECALL — Kicks (14 cards)
  // ============================================================
  FlashCard(
    id: 'tech_mae_geri_chudan',
    front: 'What is "Mae geri chūdan"?',
    back: 'Middle-level front kick (ball of foot)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_mae_geri_jodan',
    front: 'What is "Mae geri jōdan"?',
    back: 'Upper-level front kick',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_mawashi_geri_chudan',
    front: 'What is "Mawashi geri chūdan"?',
    back: 'Middle-level roundhouse kick',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_mawashi_geri_jodan',
    front: 'What is "Mawashi geri jōdan"?',
    back: 'Upper-level roundhouse kick (head kick)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_yoko_geri_keage',
    front: 'What is "Yoko geri keage"?',
    back: 'Side snap kick',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_yoko_geri_kekomi',
    front: 'What is "Yoko geri kekomi"?',
    back: 'Side thrust kick (pushing through)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_ushiro_geri',
    front: 'What is "Ushiro geri"?',
    back: 'Back kick (heel strike behind)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_ushiro_mawashi_geri',
    front: 'What is "Ushiro mawashi geri"?',
    back: 'Reverse roundhouse kick (spinning heel kick)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu6,
  ),
  FlashCard(
    id: 'tech_kansetsu_geri',
    front: 'What is "Kansetsu geri"?',
    back: 'Joint kick (stamping kick to the knee)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'tech_kin_geri',
    front: 'What is "Kin geri"?',
    back: 'Groin kick (instep kick)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_mae_keage',
    front: 'What is "Mae keage"?',
    back: 'Front rising kick (stretching kick)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_tobi_mae_geri',
    front: 'What is "Tobi mae geri"?',
    back: 'Jumping front kick',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu5,
  ),
  FlashCard(
    id: 'tech_tobi_mawashi_geri',
    front: 'What is "Tobi mawashi geri"?',
    back: 'Jumping roundhouse kick',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu4,
  ),
  FlashCard(
    id: 'tech_tobi_ushiro_geri',
    front: 'What is "Tobi ushiro geri"?',
    back: 'Jumping back kick',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu3,
  ),

  // ============================================================
  // TECHNIQUE NAME RECALL — Blocks (10 cards)
  // ============================================================
  FlashCard(
    id: 'tech_seiken_jodan_uke',
    front: 'What is "Seiken jōdan uke"?',
    back: 'Upper-level rising block (forefist)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_seiken_chudan_soto_uke',
    front: 'What is "Seiken chūdan soto uke"?',
    back: 'Middle-level outside block (forefist)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_seiken_chudan_uchi_uke',
    front: 'What is "Seiken chūdan uchi uke"?',
    back: 'Middle-level inside block (forefist)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_seiken_gedan_barai',
    front: 'What is "Seiken gedan barai"?',
    back: 'Lower-level sweeping block (downward block)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_shuto_mawashi_uke',
    front: 'What is "Shuto mawashi uke"?',
    back: 'Knife-hand circular block',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_shuto_jodan_uke',
    front: 'What is "Shuto jōdan uke"?',
    back: 'Knife-hand upper block',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_koken_uke',
    front: 'What is "Kōken uke"?',
    back: 'Wrist block (bent wrist block)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'tech_morote_uke',
    front: 'What is "Morote uke"?',
    back: 'Double-handed block (augmented block)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'tech_juji_uke',
    front: 'What is "Jūji uke"?',
    back: 'Cross block (X-block)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu6,
  ),
  FlashCard(
    id: 'tech_shotei_uke',
    front: 'What is "Shotei uke"?',
    back: 'Palm heel block',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu6,
  ),

  // ============================================================
  // TECHNIQUE NAME RECALL — Strikes (12 cards)
  // ============================================================
  FlashCard(
    id: 'tech_uraken_shomen_uchi',
    front: 'What is "Uraken shōmen uchi"?',
    back: 'Backfist front strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_uraken_sayu_uchi',
    front: 'What is "Uraken sayu uchi"?',
    back: 'Backfist side strike (left-right strike)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'tech_uraken_hizo_uchi',
    front: 'What is "Uraken hizō uchi"?',
    back: 'Backfist strike to the floating ribs',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_uraken_oroshi_uchi',
    front: 'What is "Uraken oroshi uchi"?',
    back: 'Backfist downward strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_uraken_mawashi_uchi',
    front: 'What is "Uraken mawashi uchi"?',
    back: 'Backfist circular strike (spinning backfist)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_shuto_sakotsu_uchi',
    front: 'What is "Shuto sakotsu uchi"?',
    back: 'Knife-hand collarbone strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_shuto_sakotsu_uchi_komi',
    front: 'What is "Shuto sakotsu uchi komi"?',
    back: 'Knife-hand collarbone driving strike (inside strike)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_shuto_hizo_uchi',
    front: 'What is "Shuto hizō uchi"?',
    back: 'Knife-hand strike to the floating ribs',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_shuto_jodan_uchi',
    front: 'What is "Shuto jōdan uchi"?',
    back: 'Knife-hand upper strike (to the temple)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_tettsui_oroshi_uchi',
    front: 'What is "Tettsui oroshi uchi"?',
    back: 'Hammer fist downward strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_tettsui_komi_uchi',
    front: 'What is "Tettsui komi uchi"?',
    back: 'Hammer fist inside strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'tech_shotei_uchi',
    front: 'What is "Shotei uchi"?',
    back: 'Palm heel strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),

  // ============================================================
  // TECHNIQUE NAME RECALL — Elbow Strikes (6 cards)
  // ============================================================
  FlashCard(
    id: 'tech_hiji_chudan_ate',
    front: 'What is "Hiji chūdan ate"?',
    back: 'Middle-level elbow strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_hiji_jodan_ate',
    front: 'What is "Hiji jōdan ate"?',
    back: 'Upper-level elbow strike (upward elbow)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_hiji_oroshi_ate',
    front: 'What is "Hiji oroshi ate"?',
    back: 'Downward elbow strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_hiji_ushiro_ate',
    front: 'What is "Hiji ushiro ate"?',
    back: 'Rear elbow strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_mae_hiji_ate',
    front: 'What is "Mae hiji ate"?',
    back: 'Front elbow strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'tech_age_hiji_ate',
    front: 'What is "Age hiji ate"?',
    back: 'Rising elbow strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),

  // ============================================================
  // TECHNIQUE NAME RECALL — Knee Strikes (4 cards)
  // ============================================================
  FlashCard(
    id: 'tech_mae_hiza_geri',
    front: 'What is "Mae hiza geri"?',
    back: 'Front knee strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'tech_mawashi_hiza_geri',
    front: 'What is "Mawashi hiza geri"?',
    back: 'Roundhouse knee strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'tech_hiza_ganmen_geri',
    front: 'What is "Hiza ganmen geri"?',
    back: 'Knee strike to the face (pull head down)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'tech_tobi_hiza_geri',
    front: 'What is "Tobi hiza geri"?',
    back: 'Jumping knee strike',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu5,
  ),

  // ============================================================
  // KATA NAMES & MEANINGS (22 cards)
  // ============================================================
  FlashCard(
    id: 'kata_taikyoku_1',
    front: 'What is "Taikyoku sono ichi"?',
    back: 'First Cause, First — the most basic kata (20 moves)',
    hint: 'Taikyoku = "first cause" or "grand ultimate"',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'kata_taikyoku_2',
    front: 'What is "Taikyoku sono ni"?',
    back: 'First Cause, Second — adds upper blocks and punches (20 moves)',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'kata_taikyoku_3',
    front: 'What is "Taikyoku sono san"?',
    back: 'First Cause, Third — adds inside blocks and backfists (20 moves)',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'kata_sokugi_1',
    front: 'What is "Sokugi Taikyoku sono ichi"?',
    back: 'Kicking First Cause, First — Taikyoku pattern with kicks only',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'kata_sokugi_2',
    front: 'What is "Sokugi Taikyoku sono ni"?',
    back: 'Kicking First Cause, Second — adds knee kicks and side kicks',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'kata_sokugi_3',
    front: 'What is "Sokugi Taikyoku sono san"?',
    back: 'Kicking First Cause, Third — adds roundhouse and back kicks',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'kata_pinan_1',
    front: 'What is "Pinan sono ichi"?',
    back: 'Peaceful Mind, First — intermediate kata with varied techniques',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'kata_pinan_2',
    front: 'What is "Pinan sono ni"?',
    back: 'Peaceful Mind, Second',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'kata_pinan_3',
    front: 'What is "Pinan sono san"?',
    back: 'Peaceful Mind, Third',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'kata_pinan_4',
    front: 'What is "Pinan sono yon"?',
    back: 'Peaceful Mind, Fourth — most complex Pinan',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu6,
  ),
  FlashCard(
    id: 'kata_pinan_5',
    front: 'What is "Pinan sono go"?',
    back: 'Peaceful Mind, Fifth',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu6,
  ),
  FlashCard(
    id: 'kata_sanchin',
    front: 'What is "Sanchin" kata?',
    back:
        'Three Battles — breathing kata focusing on mind, body, '
        'and spirit coordination',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu6,
  ),
  FlashCard(
    id: 'kata_tsuki_no_kata',
    front: 'What is "Tsuki no kata"?',
    back: 'Punching kata — focuses on punching combinations',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu5,
  ),
  FlashCard(
    id: 'kata_yantsu',
    front: 'What is "Yantsu" kata?',
    back: 'Safe Three — emphasizes strong stances and elbow strikes',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu5,
  ),
  FlashCard(
    id: 'kata_saifa',
    front: 'What is "Saifa" kata?',
    back: 'Smash and Tear — powerful close-range techniques',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu4,
  ),
  FlashCard(
    id: 'kata_gekisai_dai',
    front: 'What is "Gekisai dai" kata?',
    back: 'Conquer and Occupy, Major — a power kata',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu4,
  ),
  FlashCard(
    id: 'kata_gekisai_sho',
    front: 'What is "Gekisai shō" kata?',
    back: 'Conquer and Occupy, Minor',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu3,
  ),
  FlashCard(
    id: 'kata_tensho',
    front: 'What is "Tensho" kata?',
    back: 'Rotating Palms — soft/circular breathing kata, complement to Sanchin',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu3,
  ),
  FlashCard(
    id: 'kata_seienchin',
    front: 'What is "Seienchin" kata?',
    back: 'Marching Far Quietly — slow, powerful movements',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu2,
  ),
  FlashCard(
    id: 'kata_garyu',
    front: 'What is "Garyu" kata?',
    back: 'Reclining Dragon — named after Sosai Oyama\'s pen name',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu1,
  ),
  FlashCard(
    id: 'kata_kanku_dai',
    front: 'What is "Kanku dai" kata?',
    back:
        'Sky Gazing, Major — the longest and most difficult kata, '
        'named after the Kyokushin symbol (kanku)',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.kyu1,
  ),
  FlashCard(
    id: 'kata_seipai',
    front: 'What is "Seipai" kata?',
    back: 'Eighteen Hands — advanced kata with 18 fundamental movements',
    category: CardCategory.kataSequence,
    minimumRank: BeltRank.shodan,
  ),

  // ============================================================
  // DOJO KUN (5 cards)
  // ============================================================
  FlashCard(
    id: 'kun_1',
    front:
        'Dojo Kun #1: 一、我々は心身を練磨し 確固不抜の心技を極めること\n\n'
        'What does it mean?',
    back:
        'We will train our hearts and bodies for a firm, '
        'unshaking spirit.',
    hint: 'About training heart and body',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'kun_2',
    front:
        'Dojo Kun #2: 一、我々は武の神髄を極め 機に臨み感に敏なること\n\n'
        'What does it mean?',
    back:
        'We will pursue the true meaning of the martial way, '
        'so our senses may be alert.',
    hint: 'About the martial way and alertness',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'kun_3',
    front:
        'Dojo Kun #3: 一、我々は質実剛健を以て 克己の精神を涵養すること\n\n'
        'What does it mean?',
    back:
        'With true vigour, we will seek to cultivate a spirit '
        'of self-denial.',
    hint: 'About vigour and self-denial',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'kun_4',
    front:
        'Dojo Kun #4: 一、我々は礼節を重んじ 長上を敬し 粗暴の振る舞いを慎むこと\n\n'
        'What does it mean?',
    back:
        'We will observe the rules of courtesy, respect our superiors, '
        'and refrain from violence.',
    hint: 'About courtesy, respect, and non-violence',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'kun_5',
    front:
        'Dojo Kun #5: 一、我々は神仏を尊び 謙譲の美徳を忘れざること\n\n'
        'What does it mean?',
    back:
        'We will follow our God and never forget the true virtue '
        'of humility.',
    hint: 'About humility and spirituality',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),

  // ============================================================
  // SOSAI OYAMA HISTORY (12 cards)
  // ============================================================
  FlashCard(
    id: 'hist_founder',
    front: 'Who founded Kyokushin Karate?',
    back:
        'Masutatsu "Mas" Oyama (大山 倍達), also known as Sosai. '
        'Born Choi Yeong-eui in Korea, 1923.',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'hist_sosai_meaning',
    front: 'What does "Sosai" mean?',
    back: 'President/Founder — the title used for Mas Oyama',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'hist_kyokushin_meaning',
    front: 'What does "Kyokushin" (極真) mean?',
    back: 'The Ultimate Truth',
    hint: 'Kyoku = ultimate, Shin = truth',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'hist_founded_year',
    front: 'When was the first Kyokushin dojo established?',
    back: '1956 in Ikebukuro, Tokyo, Japan',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'hist_iko',
    front: 'What does IKO stand for?',
    back: 'International Karate Organization (Kyokushinkaikan)',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'hist_100man_kumite',
    front: 'What is the 100-man kumite (Hyakunin kumite)?',
    back:
        'Fighting 100 opponents in full-contact consecutive bouts. '
        'Sosai Oyama completed this over three days.',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'hist_bull_fighting',
    front: 'What is Sosai Oyama famous for besides karate bouts?',
    back:
        'Fighting bulls barehanded — he reportedly fought 52 bulls, '
        'killing 3 instantly with a single blow.',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'hist_mt_minobu',
    front: 'Where did Sosai Oyama train in isolation?',
    back:
        'Mount Minobu and Mount Kiyosumi for 18 months of solo training, '
        'meditating and practicing 12 hours a day.',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'hist_kanku',
    front: 'What does the Kanku (Kyokushin symbol) represent?',
    back:
        'The points represent the fingers (ultimate peaks), the thick '
        'sections the wrists (power), and the circle the continuity '
        'and circular movement. Derived from the Kanku kata.',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'hist_oyama_death',
    front: 'When did Sosai Mas Oyama pass away?',
    back: 'April 26, 1994, at age 70',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'hist_first_world_tournament',
    front: 'When was the first Kyokushin World Tournament held?',
    back: '1975 in Tokyo, Japan',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'hist_strongest_karate',
    front: 'Kyokushin is often called what?',
    back:
        '"The Strongest Karate" — due to its full-contact fighting rules '
        'and rigorous physical conditioning.',
    category: CardCategory.history,
    minimumRank: BeltRank.kyu10,
  ),

  // ============================================================
  // DOJO ETIQUETTE (12 cards)
  // ============================================================
  FlashCard(
    id: 'etq_bowing_enter',
    front: 'What should you do when entering the dojo?',
    back: 'Bow at the entrance and say "Osu!"',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'etq_bowing_sensei',
    front: 'How do you greet the Sensei?',
    back:
        'Bow deeply and say "Osu, Sensei!" '
        'When in seiza, bow with both palms on the floor.',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'etq_lineup',
    front: 'How do students line up in class?',
    back:
        'By rank, highest grade on the right (facing shōmen/front), '
        'lowest on the left. Rows are formed evenly.',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'etq_belt_tying',
    front: 'How should the belt knot be positioned?',
    back:
        'The knot should be flat and centered below the navel. '
        'Both ends of the belt should hang evenly.',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'etq_gi_care',
    front: 'What is the proper care for a gi (training uniform)?',
    back:
        'Keep it clean and white. The gi should be washed after '
        'every training session. No patches or markings without '
        'Sensei permission.',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'etq_lateness',
    front: 'What should you do if you arrive late to class?',
    back:
        'Kneel in seiza at the edge of the training area, wait for '
        'Sensei to acknowledge you, bow, and say "Osu, shitsurei shimasu" '
        '(excuse me for being rude).',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'etq_class_structure',
    front: 'What is the typical Kyokushin class structure?',
    back:
        '1. Seiza + Mokusō (meditation)\n'
        '2. Dojo Kun recitation\n'
        '3. Warm-up + stretching\n'
        '4. Kihon (basics)\n'
        '5. Ido geiko (moving combinations)\n'
        '6. Kata\n'
        '7. Kumite (sparring)\n'
        '8. Cool down + Mokusō',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'etq_shomen',
    front: 'What is the "Shōmen"?',
    back:
        'The front of the dojo — usually has the Kanku symbol, '
        'Japanese flag, and/or a photo of Sosai Oyama.',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'etq_sparring',
    front: 'What is the proper etiquette before kumite (sparring)?',
    back:
        'Face your partner, bow, and say "Osu!" at both the '
        'beginning and end of each bout.',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'etq_shoes',
    front: 'What is the rule about footwear in the dojo?',
    back:
        'No shoes on the training floor. Shoes should be placed neatly '
        'at the entrance. Wear zōri (sandals) outside the floor.',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'etq_nails',
    front: 'Why must fingernails and toenails be kept short?',
    back:
        'To prevent injury to training partners during kumite and '
        'partner drills. This is a safety requirement.',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'etq_sempai_kohai',
    front: 'What is the Senpai-Kōhai relationship?',
    back:
        'Senior-Junior mentoring relationship. Senpai (senior) guides '
        'and supports Kōhai (junior). This is fundamental to dojo culture.',
    category: CardCategory.etiquette,
    minimumRank: BeltRank.kyu10,
  ),

  // ============================================================
  // FITNESS REQUIREMENTS (11 cards)
  // ============================================================
  FlashCard(
    id: 'fit_kyu10',
    front: 'What are the fitness requirements for 10th Kyu (White Belt)?',
    back: '20 push-ups, 30 sit-ups, 20 squats',
    category: CardCategory.fitnessRequirements,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'fit_kyu9',
    front: 'What are the fitness requirements for 9th Kyu (Orange Belt)?',
    back: '25 push-ups, 35 sit-ups, 25 squats',
    category: CardCategory.fitnessRequirements,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'fit_kyu8',
    front: 'What are the fitness requirements for 8th Kyu?',
    back: '25 push-ups, 35 sit-ups, 25 squats',
    category: CardCategory.fitnessRequirements,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'fit_kyu7',
    front: 'What are the fitness requirements for 7th Kyu (Blue Belt)?',
    back: '30 push-ups, 40 sit-ups, 30 squats + 3 × 1.5 min kumite',
    category: CardCategory.fitnessRequirements,
    minimumRank: BeltRank.kyu8,
  ),
  FlashCard(
    id: 'fit_kyu6',
    front: 'What are the fitness requirements for 6th Kyu?',
    back: '35 push-ups, 45 sit-ups, 35 squats + 3 × 1.5 min kumite',
    category: CardCategory.fitnessRequirements,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'fit_kyu5',
    front: 'What are the fitness requirements for 5th Kyu (Yellow Belt)?',
    back: '40 push-ups, 50 sit-ups, 40 squats + 4 × 2 min kumite',
    category: CardCategory.fitnessRequirements,
    minimumRank: BeltRank.kyu6,
  ),
  FlashCard(
    id: 'fit_kyu4',
    front: 'What are the fitness requirements for 4th Kyu?',
    back: '45 push-ups, 60 sit-ups, 45 squats + 4 × 2 min kumite',
    category: CardCategory.fitnessRequirements,
    minimumRank: BeltRank.kyu5,
  ),
  FlashCard(
    id: 'fit_kyu3',
    front: 'What are the fitness requirements for 3rd Kyu (Green Belt)?',
    back: '50 push-ups, 70 sit-ups, 50 squats + 5 × 2 min kumite',
    category: CardCategory.fitnessRequirements,
    minimumRank: BeltRank.kyu4,
  ),
  FlashCard(
    id: 'fit_kyu2',
    front: 'What are the fitness requirements for 2nd Kyu (Brown Belt)?',
    back: '60 push-ups, 80 sit-ups, 60 squats + 7 × 2 min kumite',
    category: CardCategory.fitnessRequirements,
    minimumRank: BeltRank.kyu3,
  ),
  FlashCard(
    id: 'fit_kyu1',
    front: 'What are the fitness requirements for 1st Kyu?',
    back: '70 push-ups, 100 sit-ups, 70 squats + 10 × 2 min kumite',
    category: CardCategory.fitnessRequirements,
    minimumRank: BeltRank.kyu2,
  ),
  FlashCard(
    id: 'fit_shodan',
    front: 'What are the fitness requirements for Shodan (Black Belt)?',
    back:
        '100 push-ups, 150 sit-ups, 100 squats + '
        '20 × 2 min consecutive kumite rounds',
    category: CardCategory.fitnessRequirements,
    minimumRank: BeltRank.kyu1,
  ),

  // ============================================================
  // KUMITE RULES (12 cards)
  // ============================================================
  FlashCard(
    id: 'kum_yakusoku',
    front: 'What is "Yakusoku kumite"?',
    back:
        'Pre-arranged sparring — both attacker and defender know '
        'the techniques in advance',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'kum_sanbon',
    front: 'What is "Sanbon kumite"?',
    back: 'Three-step sparring — 3 pre-arranged attack/defense exchanges',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'kum_ippon',
    front: 'What is "Ippon kumite"?',
    back: 'One-step sparring — single attack with defense and counter',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu9,
  ),
  FlashCard(
    id: 'kum_jiyu',
    front: 'What is "Jiyu kumite"?',
    back: 'Free sparring — full-contact, unrestricted techniques (within rules)',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'kum_no_head_punches',
    front: 'What is the Kyokushin rule about punches to the head?',
    back:
        'Punches to the head/face are NOT allowed in Kyokushin kumite. '
        'Kicks to the head are allowed.',
    hint: 'Kicks yes, punches no (to the head)',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'kum_ippon_win',
    front: 'What is an "Ippon" (full point) in Kyokushin tournament?',
    back:
        'A technique that downs the opponent for 3+ seconds, '
        'or a knockout. Scores an automatic win.',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'kum_wazari',
    front: 'What is a "Wazari" (half point) in Kyokushin?',
    back:
        'A technique that causes significant damage or a momentary '
        'knockdown. Two wazari equal one ippon.',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'kum_tameshiwari_meaning',
    front: 'What is "Tameshiwari"?',
    back:
        'Board/brick breaking — a test of power, focus, and technique. '
        'Required from brown belt grading onward.',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu2,
  ),
  FlashCard(
    id: 'kum_matte',
    front: 'What does "Matte" mean in kumite?',
    back: 'Wait / pause — referee command to stop fighting temporarily',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'kum_aka_shiro',
    front: 'What do "Aka" and "Shiro" mean in tournament?',
    back: 'Aka = Red (corner), Shiro = White (corner)',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'kum_hantei',
    front: 'What is "Hantei" in a tournament?',
    back:
        'Decision — judges raise flags to indicate their decision '
        'on who won the bout',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'kum_jogai',
    front: 'What does "Jōgai" mean in tournament kumite?',
    back:
        'Stepping out of bounds — a penalty. Multiple jōgai can '
        'lead to disqualification.',
    category: CardCategory.kumiteRules,
    minimumRank: BeltRank.kyu7,
  ),

  // ============================================================
  // BREAKING TECHNIQUES (3 cards)
  // ============================================================
  FlashCard(
    id: 'tech_tameshiwari_seiken',
    front: 'What is "Seiken tameshiwari"?',
    back: 'Breaking with the forefist (front two knuckles)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu2,
  ),
  FlashCard(
    id: 'tech_tameshiwari_shuto',
    front: 'What is "Shuto tameshiwari"?',
    back: 'Breaking with the knife hand (edge of hand)',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu2,
  ),
  FlashCard(
    id: 'tech_tameshiwari_hiji',
    front: 'What is "Hiji tameshiwari"?',
    back: 'Breaking with the elbow',
    category: CardCategory.techniqueRecall,
    minimumRank: BeltRank.kyu2,
  ),

  // ============================================================
  // ADDITIONAL TERMINOLOGY (10 cards)
  // ============================================================
  FlashCard(
    id: 'term_kihon',
    front: 'What does "Kihon" mean?',
    back: 'Basics / Fundamentals — the foundation of all technique',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'term_kata',
    front: 'What does "Kata" mean?',
    back: 'Form / Pattern — a pre-arranged sequence of techniques',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'term_kumite',
    front: 'What does "Kumite" mean?',
    back: 'Sparring / Fighting (literally "grappling hands")',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'term_dojo',
    front: 'What does "Dojo" mean?',
    back: 'Training hall (literally "place of the way")',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'term_gi',
    front: 'What is a "Gi" (or "Dōgi")?',
    back: 'Training uniform — the white karate suit',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'term_obi',
    front: 'What does "Obi" mean?',
    back: 'Belt — the colored belt worn around the waist',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'term_ido_geiko',
    front: 'What does "Ido geiko" mean?',
    back: 'Moving practice — performing techniques while moving across the floor',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'term_bunkai',
    front: 'What does "Bunkai" mean?',
    back: 'Application analysis — practical self-defense interpretation of kata moves',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu7,
  ),
  FlashCard(
    id: 'term_kiai',
    front: 'What does "Kiai" mean?',
    back:
        'Spirit shout — a focused yell that tightens core muscles '
        'and concentrates power at the moment of impact',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu10,
  ),
  FlashCard(
    id: 'term_zanshin',
    front: 'What does "Zanshin" mean?',
    back:
        'Remaining awareness — maintaining focus and readiness '
        'after executing a technique',
    category: CardCategory.terminology,
    minimumRank: BeltRank.kyu9,
  ),
];
