import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/technique.dart';

/// All Kyokushin techniques in the IKO-1 syllabus.
///
/// Contains 72 techniques across 9 categories:
/// - Stances (dachi): 11
/// - Punches (tsuki): 12
/// - Kicks (geri): 14
/// - Blocks (uke): 10
/// - Strikes (uchi): 12
/// - Elbow strikes (hiji): 6
/// - Knee strikes (hiza): 4
/// - Breaking (tameshiwari): 3
///
/// All data is AI-generated and must be expert-validated against
/// the IKO-1 syllabus. See `CONTENT_REVIEW.md` for validation status.
const List<Technique> allTechniques = [
  // ============================================================
  // STANCES (Dachi) — 11 techniques
  // ============================================================
  Technique(
    id: 'heisoku_dachi',
    japaneseName: '閉足立ち',
    englishName: 'Closed foot stance',
    romajiName: 'Heisoku dachi',
    category: TechniqueCategory.dachi,
    description:
        'Feet together, toes pointing forward. This is the formal attention '
        'stance used at the beginning and end of training, during bowing, '
        'and when receiving instruction from the sensei.',
    keyPoints: [
      'Feet completely together with no gap',
      'Weight distributed evenly on both feet',
      'Back straight, shoulders relaxed',
      'Arms naturally at sides or fists at hips',
    ],
    commonMistakes: [
      'Feet slightly apart instead of touching',
      'Leaning forward or backward',
      'Shoulders tense and raised',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['musubi_dachi', 'heiko_dachi'],
  ),
  Technique(
    id: 'musubi_dachi',
    japaneseName: '結び立ち',
    englishName: 'Knot stance',
    romajiName: 'Musubi dachi',
    category: TechniqueCategory.dachi,
    description:
        'Heels together with toes pointing outward at approximately 45 degrees. '
        'This formal stance is used during the opening and closing ceremonies '
        'of class, and when performing mokuso (meditation).',
    keyPoints: [
      'Heels touching, toes at 45-degree angle',
      'Knees straight but not locked',
      'Weight evenly distributed',
      'Hands in fists at sides or open at thighs',
    ],
    commonMistakes: [
      'Toes spread too wide or too narrow',
      'Heels apart',
      'Swaying or shifting weight',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['heisoku_dachi', 'shizen_tai'],
  ),
  Technique(
    id: 'heiko_dachi',
    japaneseName: '平行立ち',
    englishName: 'Parallel stance',
    romajiName: 'Heikō dachi',
    category: TechniqueCategory.dachi,
    description:
        'Feet shoulder-width apart, toes pointing forward. A natural and '
        'relaxed ready stance used as a base position for many basic '
        'techniques and during warm-up exercises.',
    keyPoints: [
      'Feet shoulder-width apart',
      'Toes pointing directly forward',
      'Knees slightly bent',
      'Weight centered between both feet',
    ],
    commonMistakes: [
      'Feet too wide or too narrow',
      'Toes turned outward',
      'Standing too upright with locked knees',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['shizen_tai', 'uchi_hachiji_dachi'],
  ),
  Technique(
    id: 'shizen_tai',
    japaneseName: '自然体',
    englishName: 'Natural stance',
    romajiName: 'Shizen tai',
    category: TechniqueCategory.dachi,
    description:
        'A natural standing position with feet shoulder-width apart and body '
        'relaxed. This is the most natural combat-ready position, allowing '
        'quick movement in any direction.',
    keyPoints: [
      'Feet shoulder-width apart, natural angle',
      'Body relaxed but alert',
      'Weight slightly on balls of feet',
      'Hands in a natural guard position',
    ],
    commonMistakes: [
      'Too rigid or too relaxed',
      'Weight on heels instead of balls of feet',
      'Shoulders hunched',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['heiko_dachi', 'uchi_hachiji_dachi'],
  ),
  Technique(
    id: 'uchi_hachiji_dachi',
    japaneseName: '内八字立ち',
    englishName: 'Inverted open leg stance',
    romajiName: 'Uchi hachiji dachi',
    category: TechniqueCategory.dachi,
    description:
        'Feet shoulder-width apart with toes turned slightly inward. This '
        'pigeon-toed stance protects the groin and strengthens the inner '
        'thigh muscles. Commonly used in Sanchin kata practice.',
    keyPoints: [
      'Feet shoulder-width apart',
      'Toes turned inward approximately 30 degrees',
      'Knees slightly bent and pushed inward',
      'Groin protected by knee alignment',
    ],
    commonMistakes: [
      'Toes turned in too much, causing instability',
      'Knees not following the line of the toes',
      'Standing too tall without bending knees',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['sanchin_dachi', 'heiko_dachi'],
  ),
  Technique(
    id: 'sanchin_dachi',
    japaneseName: '三戦立ち',
    englishName: 'Three battles stance',
    romajiName: 'Sanchin dachi',
    category: TechniqueCategory.dachi,
    description:
        'A strong, rooted stance with feet one shoulder-width apart, toes '
        'turned inward, and the front foot one foot-length ahead. The stance '
        'builds internal tension and stability, essential for the Sanchin kata.',
    keyPoints: [
      'Front foot one foot-length ahead of rear foot',
      'Both toes turned inward',
      'Knees bent and squeezed inward',
      'Core engaged with dynamic tension throughout body',
      'Weight distributed 50/50',
    ],
    commonMistakes: [
      'Stance too wide or too narrow',
      'Rear heel lifting off the ground',
      'Losing dynamic tension in the core',
    ],
    requiredForBelts: [BeltRank.kyu9, BeltRank.kyu7],
    relatedTechniqueIds: ['uchi_hachiji_dachi', 'zenkutsu_dachi'],
  ),
  Technique(
    id: 'zenkutsu_dachi',
    japaneseName: '前屈立ち',
    englishName: 'Front stance',
    romajiName: 'Zenkutsu dachi',
    category: TechniqueCategory.dachi,
    description:
        'A long forward-leaning stance with the front knee bent at 90 degrees '
        'and the rear leg straight. The primary stance for delivering powerful '
        'forward techniques and is used extensively in the Taikyoku and Pinan kata.',
    keyPoints: [
      'Front knee bent at approximately 90 degrees',
      'Rear leg straight with heel firmly on ground',
      'Hips square and facing forward',
      'Weight distribution approximately 60% front, 40% rear',
      'Stance approximately two shoulder-widths long',
    ],
    commonMistakes: [
      'Front knee extending past the toes',
      'Rear heel lifting off the floor',
      'Hips not square to the front',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['kokutsu_dachi', 'kiba_dachi'],
  ),
  Technique(
    id: 'kiba_dachi',
    japaneseName: '騎馬立ち',
    englishName: 'Horse riding stance',
    romajiName: 'Kiba dachi',
    category: TechniqueCategory.dachi,
    description:
        'A wide stance with feet parallel, knees bent, as if sitting on a '
        'horse. This stance develops strong legs and a stable base. '
        'Used extensively in Kyokushin training for conditioning and '
        'side-facing techniques.',
    keyPoints: [
      'Feet approximately two shoulder-widths apart',
      'Toes pointing forward or slightly outward',
      'Knees bent deeply, thighs approaching parallel to ground',
      'Back straight and upright',
      'Weight evenly distributed',
    ],
    commonMistakes: [
      'Knees caving inward instead of over toes',
      'Leaning forward at the waist',
      'Stance not low enough',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['zenkutsu_dachi', 'kokutsu_dachi'],
  ),
  Technique(
    id: 'kokutsu_dachi',
    japaneseName: '後屈立ち',
    englishName: 'Back stance',
    romajiName: 'Kokutsu dachi',
    category: TechniqueCategory.dachi,
    description:
        'A defensive stance with approximately 70% of weight on the rear leg '
        'and 30% on the front leg. The rear knee is deeply bent while the '
        'front leg is lightly loaded, allowing quick front-leg kicks.',
    keyPoints: [
      'Weight distribution 70% rear, 30% front',
      'Rear knee deeply bent',
      'Front foot pointing forward, rear foot at 90 degrees',
      'Hips turned at 45 degrees',
      'Front leg ready for quick kicks',
    ],
    commonMistakes: [
      'Too much weight on the front leg',
      'Rear knee not bent enough',
      'Upper body leaning backward',
    ],
    requiredForBelts: [BeltRank.kyu9, BeltRank.kyu7],
    relatedTechniqueIds: ['zenkutsu_dachi', 'neko_ashi_dachi'],
  ),
  Technique(
    id: 'neko_ashi_dachi',
    japaneseName: '猫足立ち',
    englishName: 'Cat foot stance',
    romajiName: 'Neko ashi dachi',
    category: TechniqueCategory.dachi,
    description:
        'A light, mobile stance with approximately 90% of weight on the rear '
        'leg. The front foot rests on the ball with the heel raised, like a '
        'cat ready to pounce. Allows instant front-leg kicks and quick retreats.',
    keyPoints: [
      'Weight distribution 90% rear, 10% front',
      'Front foot on ball of foot, heel raised',
      'Rear knee deeply bent for stability',
      'Back straight and centered over rear leg',
      'Guard hands up protecting centerline',
    ],
    commonMistakes: [
      'Putting too much weight on the front foot',
      'Front heel touching the ground',
      'Standing too upright with rear leg straight',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu5],
    relatedTechniqueIds: ['kokutsu_dachi', 'tsuru_ashi_dachi'],
  ),
  Technique(
    id: 'tsuru_ashi_dachi',
    japaneseName: '鶴足立ち',
    englishName: 'Crane foot stance',
    romajiName: 'Tsuru ashi dachi',
    category: TechniqueCategory.dachi,
    description:
        'A one-legged stance where all weight is on one leg with the other '
        'foot raised to the supporting knee. Named after the crane, this '
        'stance develops balance and is the preparatory position for many kicks.',
    keyPoints: [
      'All weight on the supporting leg',
      'Raised foot placed against supporting knee',
      'Supporting knee slightly bent',
      'Back straight, eyes forward',
      'Arms in guard position for balance',
    ],
    commonMistakes: [
      'Leaning to one side for balance',
      'Supporting leg too straight and locked',
      'Raised foot not tucked properly against knee',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu5],
    relatedTechniqueIds: ['neko_ashi_dachi', 'mae_geri_chudan'],
  ),

  // ============================================================
  // PUNCHES (Tsuki) — 12 techniques
  // ============================================================
  Technique(
    id: 'seiken_chudan_tsuki',
    japaneseName: '正拳中段突き',
    englishName: 'Middle-level straight punch',
    romajiName: 'Seiken chūdan tsuki',
    category: TechniqueCategory.tsuki,
    description:
        'The most fundamental Kyokushin punch. A straight punch to the solar '
        'plexus or mid-section using the first two knuckles (seiken). '
        'Develops proper hip rotation and hikite (pulling hand).',
    keyPoints: [
      'Strike with the first two knuckles (index and middle finger)',
      'Full hip rotation drives the punch',
      'Hikite — pull the opposite hand to the hip',
      'Wrist straight and aligned with forearm',
      'Exhale sharply on impact with kiai',
    ],
    commonMistakes: [
      'Striking with the wrong knuckles',
      'No hip rotation, punching with arm only',
      'Wrist bent on impact risking injury',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['seiken_jodan_tsuki', 'seiken_shita_tsuki'],
  ),
  Technique(
    id: 'seiken_jodan_tsuki',
    japaneseName: '正拳上段突き',
    englishName: 'Upper-level straight punch',
    romajiName: 'Seiken jōdan tsuki',
    category: TechniqueCategory.tsuki,
    description:
        'A straight punch targeting the face or jaw level using the first '
        'two knuckles. Same mechanics as chudan tsuki but aimed at the upper '
        'level. In Kyokushin full-contact rules, this targets the face area.',
    keyPoints: [
      'Aim at chin or nose height',
      'Same hip rotation as chudan tsuki',
      'Slight upward trajectory from guard position',
      'Keep opposite hand protecting face',
      'Snap the punch back quickly after impact',
    ],
    commonMistakes: [
      'Dropping the guard hand when punching',
      'Telegraphing by pulling the fist back before punching',
      'Over-extending and losing balance',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['seiken_chudan_tsuki', 'seiken_ago_uchi'],
  ),
  Technique(
    id: 'seiken_ago_uchi',
    japaneseName: '正拳顎打ち',
    englishName: 'Jaw strike',
    romajiName: 'Seiken ago uchi',
    category: TechniqueCategory.tsuki,
    description:
        'A close-range uppercut-style strike to the jaw using the seiken '
        '(forefist). The punch travels vertically upward into the chin, '
        'making it effective in close-quarters fighting.',
    keyPoints: [
      'Drive upward from the hip using leg power',
      'Strike the underside of the chin',
      'Keep elbow close to the body',
      'Use the first two knuckles',
      'Rotate hips upward with the strike',
    ],
    commonMistakes: [
      'Swinging the arm wide instead of straight up',
      'Leaning back during the strike',
      'Not using hip power for the upward drive',
    ],
    requiredForBelts: [BeltRank.kyu9, BeltRank.kyu8],
    relatedTechniqueIds: ['seiken_jodan_tsuki', 'age_tsuki'],
  ),
  Technique(
    id: 'seiken_shita_tsuki',
    japaneseName: '正拳下突き',
    englishName: 'Lower-level punch',
    romajiName: 'Seiken shita tsuki',
    category: TechniqueCategory.tsuki,
    description:
        'A short-range punch targeting the lower abdomen or groin area. '
        'The fist is driven forward and slightly downward with a twist. '
        'Effective as a body shot in close-range fighting.',
    keyPoints: [
      'Fist palm-up at the start, twists on impact',
      'Short, compact motion from the hip',
      'Target is below the navel',
      'Keep elbow close to the body',
      'Drive with the hips, not just the arm',
    ],
    commonMistakes: [
      'Punching too far downward instead of forward',
      'Leaving the face unguarded',
      'Over-extending the arm',
    ],
    requiredForBelts: [BeltRank.kyu9, BeltRank.kyu8],
    relatedTechniqueIds: ['seiken_chudan_tsuki', 'ura_tsuki'],
  ),
  Technique(
    id: 'seiken_kagi_tsuki',
    japaneseName: '正拳鉤突き',
    englishName: 'Hook punch',
    romajiName: 'Seiken kagi tsuki',
    category: TechniqueCategory.tsuki,
    description:
        'A horizontal hook punch using the seiken, targeting the side of '
        'the head or the floating ribs. The arm travels in a circular arc '
        'with the elbow bent at approximately 90 degrees.',
    keyPoints: [
      'Elbow bent at 90 degrees throughout the strike',
      'Rotate the entire body to generate power',
      'Strike with the first two knuckles',
      'Keep the non-striking hand in guard',
      'Follow through with hip rotation',
    ],
    commonMistakes: [
      'Swinging from the shoulder without hip rotation',
      'Arm too straight, turning it into a wide swing',
      'Dropping the other hand during the hook',
    ],
    requiredForBelts: [BeltRank.kyu8, BeltRank.kyu7],
    relatedTechniqueIds: ['furi_tsuki', 'seiken_chudan_tsuki'],
  ),
  Technique(
    id: 'morote_tsuki',
    japaneseName: '諸手突き',
    englishName: 'Double-fist punch',
    romajiName: 'Morote tsuki',
    category: TechniqueCategory.tsuki,
    description:
        'A simultaneous two-fist punch, typically one chudan and one jodan, '
        'or both at the same level. Used to overwhelm an opponent with a '
        'double impact at close range.',
    keyPoints: [
      'Both fists strike simultaneously',
      'Strong forward drive from the hips',
      'Maintain balance with a solid stance',
      'Both wrists straight on impact',
    ],
    commonMistakes: [
      'One fist arriving before the other',
      'Leaning too far forward and losing balance',
      'Not committing hip rotation to the double strike',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['seiken_chudan_tsuki', 'seiken_jodan_tsuki'],
  ),
  Technique(
    id: 'ura_tsuki',
    japaneseName: '裏突き',
    englishName: 'Inverted punch',
    romajiName: 'Ura tsuki',
    category: TechniqueCategory.tsuki,
    description:
        'A close-range punch delivered with the fist palm-up (inverted). '
        'The punch does not rotate on impact, keeping the palm facing '
        'upward. Highly effective for short-distance body attacks.',
    keyPoints: [
      'Fist stays palm-up throughout the punch',
      'Short, explosive motion from the hip',
      'Effective at very close range',
      'Drive forward with hip thrust',
    ],
    commonMistakes: [
      'Rotating the fist over like a regular tsuki',
      'Extending too far and losing the close-range advantage',
      'Not engaging the hips for power',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['seiken_shita_tsuki', 'tate_tsuki'],
  ),
  Technique(
    id: 'furi_tsuki',
    japaneseName: '振り突き',
    englishName: 'Swinging punch',
    romajiName: 'Furi tsuki',
    category: TechniqueCategory.tsuki,
    description:
        'A wide circular punch similar to a haymaker, swinging from the '
        'outside inward. While less precise than a straight punch, it '
        'generates tremendous power through centrifugal force.',
    keyPoints: [
      'Wide circular path from outside to center',
      'Full body rotation drives the punch',
      'Strike with the first two knuckles',
      'Maintain a tight fist throughout',
    ],
    commonMistakes: [
      'Telegraphing the punch with a big wind-up',
      'Losing balance due to the wide swing',
      'Forgetting to protect the open side during the swing',
    ],
    requiredForBelts: [BeltRank.kyu6, BeltRank.kyu5],
    relatedTechniqueIds: ['seiken_kagi_tsuki', 'uraken_mawashi_uchi'],
  ),
  Technique(
    id: 'age_tsuki',
    japaneseName: '上げ突き',
    englishName: 'Rising punch',
    romajiName: 'Age tsuki',
    category: TechniqueCategory.tsuki,
    description:
        'An uppercut punch that rises from low to high, targeting the chin '
        'or solar plexus. The punch follows a vertical arc upward, using '
        'the legs and hips to drive the fist into the target.',
    keyPoints: [
      'Start low and drive upward',
      'Use leg and hip power to generate upward force',
      'Strike with the first two knuckles',
      'Keep the elbow close to the body',
    ],
    commonMistakes: [
      'Leaning back during the rising motion',
      'Only using arm strength without body mechanics',
      'Dropping the guard hand during the punch',
    ],
    requiredForBelts: [BeltRank.kyu6, BeltRank.kyu5],
    relatedTechniqueIds: ['seiken_ago_uchi', 'seiken_jodan_tsuki'],
  ),
  Technique(
    id: 'tate_tsuki',
    japaneseName: '立て突き',
    englishName: 'Vertical fist punch',
    romajiName: 'Tate tsuki',
    category: TechniqueCategory.tsuki,
    description:
        'A punch delivered with the fist vertical (thumb on top) rather '
        'than the traditional horizontal fist. The vertical fist aligns '
        'the wrist more naturally and is effective at medium range.',
    keyPoints: [
      'Fist held vertically with thumb on top',
      'Natural wrist alignment reduces injury risk',
      'Straight trajectory to the target',
      'Hip rotation drives the punch',
    ],
    commonMistakes: [
      'Fist rotating to horizontal during the punch',
      'Not keeping the wrist straight',
      'Insufficient hip rotation',
    ],
    requiredForBelts: [BeltRank.kyu5, BeltRank.kyu4],
    relatedTechniqueIds: ['ura_tsuki', 'seiken_chudan_tsuki'],
  ),
  Technique(
    id: 'shotei_tsuki',
    japaneseName: '掌底突き',
    englishName: 'Palm heel thrust',
    romajiName: 'Shotei tsuki',
    category: TechniqueCategory.tsuki,
    description:
        'A thrust using the palm heel (base of the palm) instead of the '
        'fist. The fingers are pulled back and the wrist is extended. '
        'Lower risk of hand injury and effective against hard targets like the face.',
    keyPoints: [
      'Strike with the base of the palm',
      'Fingers pulled back tightly',
      'Wrist extended, not bent',
      'Drive from the hips like a regular tsuki',
      'Can target chin, nose, or solar plexus',
    ],
    commonMistakes: [
      'Fingers not pulled back far enough',
      'Hitting with the fingers instead of the palm base',
      'Wrist collapsing on impact',
    ],
    requiredForBelts: [BeltRank.kyu5, BeltRank.kyu4],
    relatedTechniqueIds: ['shotei_uchi', 'shotei_uke'],
  ),
  Technique(
    id: 'nukite',
    japaneseName: '貫手',
    englishName: 'Spear hand thrust',
    romajiName: 'Nukite',
    category: TechniqueCategory.tsuki,
    description:
        'A penetrating thrust using the tips of the extended fingers. '
        'The hand is held flat with fingers tightly together, striking '
        'soft targets like the throat, solar plexus, or eyes. Requires '
        'strong finger conditioning.',
    keyPoints: [
      'Fingers tightly together and extended',
      'Thumb tucked against the side of the hand',
      'Target soft areas only (throat, solar plexus)',
      'Drive straight forward like a spear',
      'Condition fingers gradually to prevent injury',
    ],
    commonMistakes: [
      'Fingers spread apart on impact',
      'Striking hard targets with unconditioned fingers',
      'Bending the wrist on impact',
    ],
    requiredForBelts: [BeltRank.kyu4, BeltRank.kyu3],
    relatedTechniqueIds: ['shotei_tsuki', 'seiken_chudan_tsuki'],
  ),

  // ============================================================
  // KICKS (Geri) — 14 techniques
  // ============================================================
  Technique(
    id: 'mae_geri_chudan',
    japaneseName: '前蹴り中段',
    englishName: 'Middle-level front kick',
    romajiName: 'Mae geri chūdan',
    category: TechniqueCategory.geri,
    description:
        'A straight front kick targeting the midsection (solar plexus or '
        'stomach). The knee is raised first, then the leg snaps forward, '
        'striking with the ball of the foot (chusoku). The most fundamental '
        'kick in Kyokushin.',
    keyPoints: [
      'Chamber the knee high before extending',
      'Strike with the ball of the foot (chusoku)',
      'Pull toes back to expose the striking surface',
      'Snap the kick back after impact',
      'Keep guard hands up throughout',
    ],
    commonMistakes: [
      'Not chambering the knee before kicking',
      'Kicking with the toes instead of ball of foot',
      'Dropping hands during the kick',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['mae_geri_jodan', 'kin_geri', 'mae_keage'],
  ),
  Technique(
    id: 'mae_geri_jodan',
    japaneseName: '前蹴り上段',
    englishName: 'Upper-level front kick',
    romajiName: 'Mae geri jōdan',
    category: TechniqueCategory.geri,
    description:
        'A front kick targeting the face or chin. Requires greater '
        'flexibility than chudan mae geri. The kick snaps upward using '
        'the ball of the foot or the heel as the striking surface.',
    keyPoints: [
      'High knee chamber is essential for height',
      'Requires good hip flexibility',
      'Strike with ball of foot or heel',
      'Lean the upper body slightly back for balance',
      'Snap back quickly to avoid the leg being caught',
    ],
    commonMistakes: [
      'Insufficient flexibility causing poor form',
      'Leaning too far back and losing balance',
      'Not chambering the knee, resulting in a push kick',
    ],
    requiredForBelts: [BeltRank.kyu9, BeltRank.kyu8],
    relatedTechniqueIds: ['mae_geri_chudan', 'mawashi_geri_jodan'],
  ),
  Technique(
    id: 'mawashi_geri_chudan',
    japaneseName: '回し蹴り中段',
    englishName: 'Middle-level roundhouse kick',
    romajiName: 'Mawashi geri chūdan',
    category: TechniqueCategory.geri,
    description:
        'A circular kick targeting the ribs or body using the instep '
        '(haisoku) or ball of foot. The kicking leg travels in a horizontal '
        'arc, powered by hip rotation. The signature scoring kick in '
        'Kyokushin tournaments.',
    keyPoints: [
      'Pivot on the supporting foot to allow full hip rotation',
      'Chamber the knee to the side before extending',
      'Strike with the instep or ball of the foot',
      'Drive through the target with the hip',
      'Return the leg to chamber after the kick',
    ],
    commonMistakes: [
      'Not pivoting on the supporting foot',
      'Kicking with the shin at chudan level (appropriate for muay thai, not standard kihon)',
      'Dropping hands during the kick',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['mawashi_geri_jodan', 'ushiro_mawashi_geri'],
  ),
  Technique(
    id: 'mawashi_geri_jodan',
    japaneseName: '回し蹴り上段',
    englishName: 'Upper-level roundhouse kick',
    romajiName: 'Mawashi geri jōdan',
    category: TechniqueCategory.geri,
    description:
        'A high roundhouse kick targeting the head. Requires excellent '
        'flexibility and hip rotation. The most spectacular scoring '
        'technique in Kyokushin competition — a clean jodan mawashi geri '
        'can result in ippon (full point).',
    keyPoints: [
      'Full pivot on supporting foot',
      'High knee chamber with the hip turned over',
      'Strike with the instep to the temple or jaw',
      'Lean the body slightly away for height and balance',
      'Snap the leg back immediately after impact',
    ],
    commonMistakes: [
      'Not turning the hip over, limiting height',
      'Telegraphing by dropping the hands first',
      'Losing balance after the kick',
    ],
    requiredForBelts: [BeltRank.kyu9, BeltRank.kyu8],
    relatedTechniqueIds: ['mawashi_geri_chudan', 'ushiro_mawashi_geri'],
  ),
  Technique(
    id: 'yoko_geri_keage',
    japaneseName: '横蹴り蹴上げ',
    englishName: 'Side snap kick',
    romajiName: 'Yoko geri keage',
    category: TechniqueCategory.geri,
    description:
        'A snapping side kick that travels upward to the target. The kick '
        'is delivered from a chambered position with a fast snap, using '
        'the edge of the foot (sokuto) as the striking surface.',
    keyPoints: [
      'Chamber the knee across the body',
      'Snap the foot outward and upward',
      'Strike with the edge of the foot (sokuto)',
      'Keep the supporting foot planted and pivoted',
      'Snap the leg back quickly after impact',
    ],
    commonMistakes: [
      'Kicking with the bottom of the foot instead of the edge',
      'Not snapping back after the kick',
      'Leaning too far away from the kick',
    ],
    requiredForBelts: [BeltRank.kyu9, BeltRank.kyu8],
    relatedTechniqueIds: ['yoko_geri_kekomi', 'mae_keage'],
  ),
  Technique(
    id: 'yoko_geri_kekomi',
    japaneseName: '横蹴り蹴込み',
    englishName: 'Side thrust kick',
    romajiName: 'Yoko geri kekomi',
    category: TechniqueCategory.geri,
    description:
        'A powerful thrusting side kick that drives through the target. '
        'Unlike keage (snap), kekomi pushes through with the heel or edge '
        'of the foot. One of the most powerful kicks in Kyokushin.',
    keyPoints: [
      'Chamber the knee high across the body',
      'Thrust the foot outward in a straight line',
      'Strike with the heel or edge of the foot',
      'Drive the hip forward through the target',
      'Lean the upper body away for counterbalance',
    ],
    commonMistakes: [
      'Not thrusting the hip into the kick',
      'Kicking upward instead of outward',
      'Insufficient lean causing loss of balance',
    ],
    requiredForBelts: [BeltRank.kyu9, BeltRank.kyu8],
    relatedTechniqueIds: ['yoko_geri_keage', 'ushiro_geri'],
  ),
  Technique(
    id: 'ushiro_geri',
    japaneseName: '後ろ蹴り',
    englishName: 'Back kick',
    romajiName: 'Ushiro geri',
    category: TechniqueCategory.geri,
    description:
        'A powerful straight kick delivered backward using the heel. The '
        'practitioner turns to look at the target over the shoulder, then '
        'thrusts the heel directly backward. Extremely powerful due to '
        'the body weight behind it.',
    keyPoints: [
      'Look over the shoulder at the target before kicking',
      'Chamber the knee before thrusting backward',
      'Strike with the heel',
      'Drive in a straight line behind you',
      'Keep the upper body low for balance',
    ],
    commonMistakes: [
      'Not looking at the target before kicking',
      'Kicking to the side instead of straight back',
      'Standing too upright, losing power and balance',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['yoko_geri_kekomi', 'ushiro_mawashi_geri'],
  ),
  Technique(
    id: 'ushiro_mawashi_geri',
    japaneseName: '後ろ回し蹴り',
    englishName: 'Spinning back roundhouse kick',
    romajiName: 'Ushiro mawashi geri',
    category: TechniqueCategory.geri,
    description:
        'A spinning heel kick targeting the head. The practitioner spins '
        'the body 360 degrees, using the heel to strike the opponent\'s '
        'temple. One of the most devastating techniques in Kyokushin '
        'when landed cleanly.',
    keyPoints: [
      'Initiate the spin with the shoulders and hips',
      'Keep the spinning leg chambered until the last moment',
      'Strike with the heel at head height',
      'Spot the target by looking over the shoulder during the spin',
      'Follow through and recover to a fighting stance',
    ],
    commonMistakes: [
      'Spinning too slowly and telegraphing the technique',
      'Not spotting the target during the spin',
      'Losing balance after the kick',
    ],
    requiredForBelts: [BeltRank.kyu5, BeltRank.kyu4],
    relatedTechniqueIds: ['ushiro_geri', 'mawashi_geri_jodan'],
  ),
  Technique(
    id: 'kansetsu_geri',
    japaneseName: '関節蹴り',
    englishName: 'Joint kick',
    romajiName: 'Kansetsu geri',
    category: TechniqueCategory.geri,
    description:
        'A low stamping kick targeting the opponent\'s knee joint from the '
        'side or front. Delivered by raising the knee and stamping '
        'downward at an angle. A pragmatic self-defense technique that '
        'can end a confrontation quickly.',
    keyPoints: [
      'Target the side or front of the opponent\'s knee',
      'Stamp downward at an angle',
      'Use the edge or bottom of the foot',
      'Quick, short motion — not a big wind-up',
    ],
    commonMistakes: [
      'Kicking too high — this is a low technique',
      'Using too much force in training (injury risk)',
      'Not controlling the technique in partner drills',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['mae_geri_chudan', 'kin_geri'],
  ),
  Technique(
    id: 'kin_geri',
    japaneseName: '金蹴り',
    englishName: 'Groin kick',
    romajiName: 'Kin geri',
    category: TechniqueCategory.geri,
    description:
        'A snapping kick to the groin using the instep. The leg swings '
        'upward in a pendulum motion, making contact with the top of '
        'the foot. A fundamental self-defense technique taught early in '
        'the syllabus.',
    keyPoints: [
      'Swing the leg upward in a pendulum arc',
      'Strike with the instep (top of the foot)',
      'Quick snapping motion from the knee',
      'Pull the kick back immediately after contact',
    ],
    commonMistakes: [
      'Over-swinging and losing balance',
      'Kicking with the toes instead of the instep',
      'Telegraphing the kick by leaning back too early',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['mae_geri_chudan', 'mae_keage'],
  ),
  Technique(
    id: 'mae_keage',
    japaneseName: '前蹴上げ',
    englishName: 'Front rising kick',
    romajiName: 'Mae keage',
    category: TechniqueCategory.geri,
    description:
        'A stretching/rising front kick where the straight leg swings '
        'upward as high as possible. Primarily a conditioning and '
        'flexibility exercise rather than a combat technique, developing '
        'the hamstring flexibility needed for high kicks.',
    keyPoints: [
      'Keep the kicking leg straight throughout',
      'Swing upward as high as flexibility allows',
      'Keep the supporting leg straight and stable',
      'Point the toes or pull them back depending on variant',
    ],
    commonMistakes: [
      'Bending the kicking knee during the swing',
      'Leaning backward to compensate for lack of flexibility',
      'Sacrificing form for height',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['mae_geri_chudan', 'mae_geri_jodan'],
  ),
  Technique(
    id: 'tobi_mae_geri',
    japaneseName: '飛び前蹴り',
    englishName: 'Jumping front kick',
    romajiName: 'Tobi mae geri',
    category: TechniqueCategory.geri,
    description:
        'A front kick delivered while jumping. The practitioner leaps '
        'upward, chambers the kicking knee in the air, and snaps the kick '
        'to the target at the peak of the jump. Combines timing, power, '
        'and athleticism.',
    keyPoints: [
      'Drive upward off the supporting leg',
      'Chamber the knee at the peak of the jump',
      'Strike with the ball of the foot',
      'Land with knees bent to absorb impact',
      'Maintain guard position in the air',
    ],
    commonMistakes: [
      'Not jumping high enough before kicking',
      'Kicking on the way up instead of at the peak',
      'Landing stiffly with straight legs',
    ],
    requiredForBelts: [BeltRank.kyu5, BeltRank.kyu4],
    relatedTechniqueIds: ['mae_geri_chudan', 'tobi_mawashi_geri'],
  ),
  Technique(
    id: 'tobi_mawashi_geri',
    japaneseName: '飛び回し蹴り',
    englishName: 'Jumping roundhouse kick',
    romajiName: 'Tobi mawashi geri',
    category: TechniqueCategory.geri,
    description:
        'A mawashi geri (roundhouse kick) delivered in the air. The '
        'practitioner jumps, rotates the hip, and delivers a circular '
        'kick at head height while airborne. A spectacular technique '
        'requiring excellent athletic ability.',
    keyPoints: [
      'Jump and rotate simultaneously',
      'Turn the hip over at the peak of the jump',
      'Strike with the instep at head height',
      'Land balanced in a fighting stance',
    ],
    commonMistakes: [
      'Insufficient jump height',
      'Not rotating the hip fully in the air',
      'Landing off-balance after the kick',
    ],
    requiredForBelts: [BeltRank.kyu4, BeltRank.kyu3],
    relatedTechniqueIds: ['mawashi_geri_jodan', 'tobi_mae_geri'],
  ),
  Technique(
    id: 'tobi_ushiro_geri',
    japaneseName: '飛び後ろ蹴り',
    englishName: 'Jumping back kick',
    romajiName: 'Tobi ushiro geri',
    category: TechniqueCategory.geri,
    description:
        'A back kick delivered while jumping and spinning. The practitioner '
        'jumps, spins in the air, and thrusts the heel backward at the '
        'target. One of the most advanced kicks, requiring precise timing '
        'and spatial awareness.',
    keyPoints: [
      'Jump and spin simultaneously',
      'Spot the target by looking over the shoulder',
      'Thrust the heel directly at the target',
      'Land in a stable position facing the opponent',
    ],
    commonMistakes: [
      'Losing spatial orientation during the spin',
      'Not generating enough height in the jump',
      'Landing with the back to the opponent',
    ],
    requiredForBelts: [BeltRank.kyu3, BeltRank.kyu2],
    relatedTechniqueIds: ['ushiro_geri', 'tobi_mawashi_geri'],
  ),

  // ============================================================
  // BLOCKS (Uke) — 10 techniques
  // ============================================================
  Technique(
    id: 'seiken_jodan_uke',
    japaneseName: '正拳上段受け',
    englishName: 'Upper-level block',
    romajiName: 'Seiken jōdan uke',
    category: TechniqueCategory.uke,
    description:
        'A rising block using the forearm to deflect attacks aimed at the '
        'head. The arm sweeps upward from the opposite hip, rotating the '
        'forearm to deflect the strike above the head. The most fundamental '
        'upper block in Kyokushin.',
    keyPoints: [
      'Start from the opposite hip',
      'Sweep the arm upward in a diagonal arc',
      'Forearm finishes above and in front of the forehead',
      'Rotate the forearm to deflect with the outer edge',
      'Keep the opposite hand at the hip (hikite)',
    ],
    commonMistakes: [
      'Block ending too far from the head, leaving gaps',
      'Not rotating the forearm during the sweep',
      'Blocking too far forward instead of above the head',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['seiken_chudan_soto_uke', 'seiken_gedan_barai'],
  ),
  Technique(
    id: 'seiken_chudan_soto_uke',
    japaneseName: '正拳中段外受け',
    englishName: 'Middle-level outside block',
    romajiName: 'Seiken chūdan soto uke',
    category: TechniqueCategory.uke,
    description:
        'A block that sweeps from outside to inside across the body to '
        'deflect mid-level attacks. The forearm swings inward from the '
        'shoulder, using the outer edge to redirect incoming punches '
        'or strikes.',
    keyPoints: [
      'Start with the blocking arm raised to the opposite ear',
      'Sweep the forearm inward across the body',
      'Block with the outer edge of the forearm',
      'Stop at the center line of the body',
      'Twist the forearm on completion',
    ],
    commonMistakes: [
      'Sweeping too far past the center line',
      'Not starting from a high enough position',
      'Using only the arm without body rotation',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['seiken_chudan_uchi_uke', 'seiken_jodan_uke'],
  ),
  Technique(
    id: 'seiken_chudan_uchi_uke',
    japaneseName: '正拳中段内受け',
    englishName: 'Middle-level inside block',
    romajiName: 'Seiken chūdan uchi uke',
    category: TechniqueCategory.uke,
    description:
        'A block that sweeps from inside to outside to deflect mid-level '
        'attacks. The forearm swings outward from the center of the body, '
        'redirecting incoming strikes away from the centerline.',
    keyPoints: [
      'Start with the fist near the opposite hip',
      'Sweep the forearm outward from center to the side',
      'Block with the inner edge of the forearm',
      'Rotate the forearm during the block',
      'Keep the elbow approximately one fist-width from the body',
    ],
    commonMistakes: [
      'Over-extending the arm to the side',
      'Not keeping the elbow close enough to the body',
      'Blocking with a floppy wrist',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['seiken_chudan_soto_uke', 'morote_uke'],
  ),
  Technique(
    id: 'seiken_gedan_barai',
    japaneseName: '正拳下段払い',
    englishName: 'Lower-level sweep block',
    romajiName: 'Seiken gedan barai',
    category: TechniqueCategory.uke,
    description:
        'A downward sweeping block to deflect kicks or low punches. The '
        'arm sweeps from the opposite shoulder diagonally downward across '
        'the body, ending with the fist just above the front knee. The '
        'most common block used in Taikyoku kata.',
    keyPoints: [
      'Start from the opposite shoulder',
      'Sweep diagonally downward across the body',
      'End with the fist one fist-width above the front knee',
      'Keep the blocking arm slightly bent',
      'Hikite with the opposite hand',
    ],
    commonMistakes: [
      'Sweeping too far to the side instead of across the body',
      'Arm ending too high — not covering the lower area',
      'Using only the arm without hip rotation',
    ],
    requiredForBelts: [BeltRank.kyu10],
    relatedTechniqueIds: ['seiken_jodan_uke', 'seiken_chudan_soto_uke'],
  ),
  Technique(
    id: 'shuto_mawashi_uke',
    japaneseName: '手刀回し受け',
    englishName: 'Knife-hand circular block',
    romajiName: 'Shuto mawashi uke',
    category: TechniqueCategory.uke,
    description:
        'A flowing circular block using the knife-hand (shuto). The open '
        'hand sweeps in a circular motion to redirect attacks. This block '
        'is characteristic of the Pinan kata series and combines defense '
        'with a simultaneous counter-strike potential.',
    keyPoints: [
      'Use the open hand with fingers together',
      'Sweep in a smooth circular motion',
      'Block with the edge of the hand (knife-hand)',
      'The circular motion allows continuous flow',
      'Transition smoothly into a counter-technique',
    ],
    commonMistakes: [
      'Fingers spread apart during the block',
      'Making the circle too large and slow',
      'Stopping the motion instead of flowing through',
    ],
    requiredForBelts: [BeltRank.kyu8, BeltRank.kyu7],
    relatedTechniqueIds: ['shuto_jodan_uke', 'shuto_sakotsu_uchi'],
  ),
  Technique(
    id: 'shuto_jodan_uke',
    japaneseName: '手刀上段受け',
    englishName: 'Upper-level knife-hand block',
    romajiName: 'Shuto jōdan uke',
    category: TechniqueCategory.uke,
    description:
        'An upper-level block using the open knife-hand. Similar to seiken '
        'jodan uke but performed with an open hand, allowing for immediate '
        'grabbing or striking after the block.',
    keyPoints: [
      'Open hand with fingers tightly together',
      'Sweep upward like jodan uke but with open hand',
      'Block with the outer edge of the forearm/hand',
      'Hand position allows immediate grab or strike',
    ],
    commonMistakes: [
      'Fingers loose and spread',
      'Block too far from the head',
      'Thumb not tucked properly',
    ],
    requiredForBelts: [BeltRank.kyu8, BeltRank.kyu7],
    relatedTechniqueIds: ['seiken_jodan_uke', 'shuto_mawashi_uke'],
  ),
  Technique(
    id: 'koken_uke',
    japaneseName: '弧拳受け',
    englishName: 'Wrist block',
    romajiName: 'Kōken uke',
    category: TechniqueCategory.uke,
    description:
        'A block using the back of the bent wrist (koken). The wrist is '
        'bent sharply and the back of the wrist is used to deflect '
        'attacks. Effective for circular deflections and commonly used '
        'in advanced kata.',
    keyPoints: [
      'Bend the wrist sharply to expose the back of the wrist',
      'Use a circular motion to deflect',
      'Effective against straight punches and kicks',
      'Can be used at jodan, chudan, or gedan level',
    ],
    commonMistakes: [
      'Wrist not bent enough, reducing the blocking surface',
      'Using too much force instead of deflecting',
      'Fingers not pulled back tightly',
    ],
    requiredForBelts: [BeltRank.kyu6, BeltRank.kyu5],
    relatedTechniqueIds: ['shuto_jodan_uke', 'shotei_uke'],
  ),
  Technique(
    id: 'morote_uke',
    japaneseName: '諸手受け',
    englishName: 'Augmented block',
    romajiName: 'Morote uke',
    category: TechniqueCategory.uke,
    description:
        'A reinforced block where one arm blocks while the other supports '
        'it. The supporting hand is placed on the inside of the blocking '
        'arm\'s forearm. This double-arm block provides extra strength '
        'against powerful attacks.',
    keyPoints: [
      'Primary arm performs the block (chudan or jodan)',
      'Supporting hand grips or touches the blocking forearm',
      'Both arms work together for strength',
      'Body rotation reinforces the block',
    ],
    commonMistakes: [
      'Supporting hand not properly bracing the blocking arm',
      'Both arms too rigid, preventing fluid movement',
      'Not rotating the body with the block',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['seiken_chudan_soto_uke', 'juji_uke'],
  ),
  Technique(
    id: 'juji_uke',
    japaneseName: '十字受け',
    englishName: 'Cross block',
    romajiName: 'Jūji uke',
    category: TechniqueCategory.uke,
    description:
        'A block using both arms crossed at the wrists in an X-shape. '
        'The crossed arms can block upward (jodan) or downward (gedan), '
        'providing a strong double barrier against powerful attacks.',
    keyPoints: [
      'Cross the wrists to form an X',
      'Can be used in jodan (upward) or gedan (downward) position',
      'Absorb the impact with both forearms',
      'Separate the arms after blocking to counter',
    ],
    commonMistakes: [
      'Arms not properly crossed, leaving gaps',
      'Only using arm strength without bracing the body',
      'Forgetting to separate and counter after blocking',
    ],
    requiredForBelts: [BeltRank.kyu6, BeltRank.kyu5],
    relatedTechniqueIds: ['morote_uke', 'seiken_jodan_uke'],
  ),
  Technique(
    id: 'shotei_uke',
    japaneseName: '掌底受け',
    englishName: 'Palm heel block',
    romajiName: 'Shotei uke',
    category: TechniqueCategory.uke,
    description:
        'A block using the palm heel (base of the palm). The hand is open '
        'with fingers pulled back, using the firm base of the palm to '
        'deflect attacks. Can be used to push away or redirect incoming '
        'techniques.',
    keyPoints: [
      'Open hand with fingers pulled back',
      'Block with the hard base of the palm',
      'Push or redirect rather than hard-stop the attack',
      'Wrist firm and extended',
    ],
    commonMistakes: [
      'Fingers not pulled back, risking finger injury',
      'Using the fingers instead of the palm base',
      'Wrist collapsing on impact',
    ],
    requiredForBelts: [BeltRank.kyu6, BeltRank.kyu5],
    relatedTechniqueIds: ['shotei_tsuki', 'koken_uke'],
  ),

  // ============================================================
  // STRIKES (Uchi) — 12 techniques
  // ============================================================
  Technique(
    id: 'uraken_shomen_uchi',
    japaneseName: '裏拳正面打ち',
    englishName: 'Back-fist front strike',
    romajiName: 'Uraken shōmen uchi',
    category: TechniqueCategory.uchi,
    description:
        'A snapping back-fist strike to the front of the face. The fist '
        'travels outward in a straight line and snaps from the wrist, '
        'striking with the back of the first two knuckles. A fast '
        'technique used as a counter-attack.',
    keyPoints: [
      'Snap the fist outward from the wrist',
      'Strike with the back of the two large knuckles',
      'Quick whipping motion for speed',
      'Pull the fist back immediately after striking',
      'Keep the elbow relatively stable',
    ],
    commonMistakes: [
      'Using the whole arm instead of snapping from the wrist',
      'Not pulling the fist back after the strike',
      'Striking with the wrong part of the hand',
    ],
    requiredForBelts: [BeltRank.kyu10, BeltRank.kyu9],
    relatedTechniqueIds: ['uraken_sayu_uchi', 'uraken_mawashi_uchi'],
  ),
  Technique(
    id: 'uraken_sayu_uchi',
    japaneseName: '裏拳左右打ち',
    englishName: 'Back-fist side strike',
    romajiName: 'Uraken sayu uchi',
    category: TechniqueCategory.uchi,
    description:
        'A back-fist strike delivered to the side, targeting the temple '
        'or the side of the jaw. The fist snaps outward from the center '
        'line to the side using a horizontal whipping motion.',
    keyPoints: [
      'Snap horizontally from the center outward',
      'Strike with the back of the knuckles',
      'Use hip rotation to add power',
      'Keep the non-striking hand in guard position',
    ],
    commonMistakes: [
      'Winding up the arm before striking',
      'Not using hip rotation for power',
      'Striking with the wrist instead of the knuckles',
    ],
    requiredForBelts: [BeltRank.kyu9, BeltRank.kyu8],
    relatedTechniqueIds: ['uraken_shomen_uchi', 'uraken_hizo_uchi'],
  ),
  Technique(
    id: 'uraken_hizo_uchi',
    japaneseName: '裏拳脾臓打ち',
    englishName: 'Back-fist spleen strike',
    romajiName: 'Uraken hizō uchi',
    category: TechniqueCategory.uchi,
    description:
        'A back-fist strike targeting the spleen (left side of the body) '
        'or liver (right side). The fist snaps downward and outward to '
        'the opponent\'s floating ribs area.',
    keyPoints: [
      'Target the floating rib area (spleen/liver)',
      'Snap from the wrist with a downward angle',
      'Use body rotation to reach the target',
      'Quick retraction after impact',
    ],
    commonMistakes: [
      'Striking too high — target is the floating ribs',
      'Not enough snap, making it a push instead of a strike',
      'Leaving the head unguarded during the strike',
    ],
    requiredForBelts: [BeltRank.kyu8, BeltRank.kyu7],
    relatedTechniqueIds: ['uraken_sayu_uchi', 'uraken_oroshi_uchi'],
  ),
  Technique(
    id: 'uraken_oroshi_uchi',
    japaneseName: '裏拳落とし打ち',
    englishName: 'Back-fist downward strike',
    romajiName: 'Uraken oroshi uchi',
    category: TechniqueCategory.uchi,
    description:
        'A downward striking back-fist aimed at the bridge of the nose '
        'or the top of the head. The fist is raised overhead and snapped '
        'downward, using gravity and wrist snap for impact.',
    keyPoints: [
      'Raise the fist above the head',
      'Snap downward using gravity and wrist action',
      'Strike with the back of the knuckles',
      'Aim for the bridge of the nose or crown of head',
    ],
    commonMistakes: [
      'Using a slow hammering motion instead of a snap',
      'Not raising the fist high enough before striking',
      'Leaning forward into the strike and losing balance',
    ],
    requiredForBelts: [BeltRank.kyu8, BeltRank.kyu7],
    relatedTechniqueIds: ['uraken_hizo_uchi', 'tettsui_oroshi_uchi'],
  ),
  Technique(
    id: 'uraken_mawashi_uchi',
    japaneseName: '裏拳回し打ち',
    englishName: 'Back-fist circular strike',
    romajiName: 'Uraken mawashi uchi',
    category: TechniqueCategory.uchi,
    description:
        'A circular back-fist strike where the fist swings in a wide '
        'horizontal arc to strike the temple. Often used after spinning '
        'or as a follow-up to a body technique.',
    keyPoints: [
      'Swing in a smooth horizontal arc',
      'Strike with the back of the knuckles',
      'Use full body rotation for maximum speed',
      'Snap the wrist at the point of impact',
    ],
    commonMistakes: [
      'Telegraphing by dropping the opposite hand first',
      'Swinging too wide and losing control',
      'Not snapping the wrist on impact',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['uraken_sayu_uchi', 'furi_tsuki'],
  ),
  Technique(
    id: 'shuto_sakotsu_uchi',
    japaneseName: '手刀鎖骨打ち',
    englishName: 'Knife-hand collarbone strike',
    romajiName: 'Shuto sakotsu uchi',
    category: TechniqueCategory.uchi,
    description:
        'A downward knife-hand strike targeting the collarbone. The open '
        'hand strikes with the edge (little finger side) in a diagonal '
        'downward motion. A powerful strike capable of breaking the '
        'collarbone.',
    keyPoints: [
      'Strike with the edge of the hand (knife-hand)',
      'Fingers tightly together, thumb tucked',
      'Diagonal downward motion to the collarbone',
      'Use hip rotation and gravity',
      'Follow through into the target',
    ],
    commonMistakes: [
      'Fingers spread on impact',
      'Striking with the flat of the hand instead of the edge',
      'Not enough downward angle on the strike',
    ],
    requiredForBelts: [BeltRank.kyu8, BeltRank.kyu7],
    relatedTechniqueIds: ['shuto_sakotsu_uchi_komi', 'shuto_hizo_uchi'],
  ),
  Technique(
    id: 'shuto_sakotsu_uchi_komi',
    japaneseName: '手刀鎖骨打ち込み',
    englishName: 'Knife-hand collarbone driving strike',
    romajiName: 'Shuto sakotsu uchi komi',
    category: TechniqueCategory.uchi,
    description:
        'A driving knife-hand strike to the collarbone, penetrating deeper '
        'than the regular shuto sakotsu uchi. The hand drives inward and '
        'downward with a thrusting motion into the collarbone area.',
    keyPoints: [
      'Drive the knife-hand inward with a thrust',
      'Penetrate through the target',
      'Use forward body momentum',
      'Fingers tight, thumb tucked',
    ],
    commonMistakes: [
      'Not driving through the target',
      'Using a slapping motion instead of a thrust',
      'Fingers loose on impact',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['shuto_sakotsu_uchi', 'shuto_jodan_uchi'],
  ),
  Technique(
    id: 'shuto_hizo_uchi',
    japaneseName: '手刀脾臓打ち',
    englishName: 'Knife-hand spleen strike',
    romajiName: 'Shuto hizō uchi',
    category: TechniqueCategory.uchi,
    description:
        'A horizontal knife-hand strike targeting the spleen or floating '
        'ribs. The open hand sweeps horizontally from the outside, striking '
        'with the edge of the hand. Can cause significant damage to the '
        'internal organs.',
    keyPoints: [
      'Strike horizontally with the edge of the hand',
      'Target the floating ribs and spleen area',
      'Use full body rotation for power',
      'Maintain a firm, flat hand throughout',
    ],
    commonMistakes: [
      'Striking too high — target is below the ribs',
      'Hand not firm on impact',
      'Insufficient body rotation',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['shuto_sakotsu_uchi', 'uraken_hizo_uchi'],
  ),
  Technique(
    id: 'shuto_jodan_uchi',
    japaneseName: '手刀上段打ち',
    englishName: 'Upper-level knife-hand strike',
    romajiName: 'Shuto jōdan uchi',
    category: TechniqueCategory.uchi,
    description:
        'A knife-hand strike to the neck or temple at the upper level. '
        'The open hand sweeps in a circular or straight motion, targeting '
        'the carotid artery area on the side of the neck.',
    keyPoints: [
      'Target the side of the neck (carotid area)',
      'Strike with the edge of the hand',
      'Smooth, fast motion with hip rotation',
      'Fingers tightly together',
    ],
    commonMistakes: [
      'Striking too high (above the neck)',
      'Hand relaxing on impact',
      'Not following through the target',
    ],
    requiredForBelts: [BeltRank.kyu6, BeltRank.kyu5],
    relatedTechniqueIds: ['shuto_sakotsu_uchi', 'shuto_hizo_uchi'],
  ),
  Technique(
    id: 'tettsui_oroshi_uchi',
    japaneseName: '鉄槌落とし打ち',
    englishName: 'Iron hammer downward strike',
    romajiName: 'Tettsui oroshi uchi',
    category: TechniqueCategory.uchi,
    description:
        'A downward strike using the bottom of the closed fist, like '
        'swinging a hammer. The fist strikes downward onto the target '
        '(bridge of nose, collarbone, or back of hand) with a powerful '
        'dropping motion.',
    keyPoints: [
      'Strike with the bottom of the fist (hammer fist)',
      'Raise the arm high and drive downward',
      'Use gravity and hip drop for power',
      'Keep the wrist straight and firm',
    ],
    commonMistakes: [
      'Not raising the fist high enough before striking',
      'Bending the wrist on impact',
      'Using only arm strength without body weight',
    ],
    requiredForBelts: [BeltRank.kyu8, BeltRank.kyu7],
    relatedTechniqueIds: ['tettsui_komi_uchi', 'uraken_oroshi_uchi'],
  ),
  Technique(
    id: 'tettsui_komi_uchi',
    japaneseName: '鉄槌込み打ち',
    englishName: 'Iron hammer driving strike',
    romajiName: 'Tettsui komi uchi',
    category: TechniqueCategory.uchi,
    description:
        'A sideways hammer-fist strike driven horizontally into the '
        'target. The closed fist swings from the side, striking with '
        'the bottom of the fist into the ribs or temple. Powerful and '
        'difficult to block.',
    keyPoints: [
      'Swing the closed fist horizontally',
      'Strike with the bottom of the fist',
      'Use hip rotation for power',
      'Aim for the ribs or temple',
    ],
    commonMistakes: [
      'Over-swinging and losing balance',
      'Not striking with the correct part of the fist',
      'Insufficient hip rotation reducing power',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['tettsui_oroshi_uchi', 'uraken_mawashi_uchi'],
  ),
  Technique(
    id: 'shotei_uchi',
    japaneseName: '掌底打ち',
    englishName: 'Palm heel strike',
    romajiName: 'Shotei uchi',
    category: TechniqueCategory.uchi,
    description:
        'A strike using the base of the palm to the face, chin, or body. '
        'The open hand with fingers pulled back delivers a powerful impact '
        'with lower risk of hand injury compared to a closed fist strike.',
    keyPoints: [
      'Strike with the hard base of the palm',
      'Fingers pulled back tightly',
      'Drive through the target with the hips',
      'Can target chin, nose, or solar plexus',
    ],
    commonMistakes: [
      'Hitting with the fingers instead of the palm base',
      'Wrist collapsing on impact',
      'Not pulling fingers back far enough',
    ],
    requiredForBelts: [BeltRank.kyu6, BeltRank.kyu5],
    relatedTechniqueIds: ['shotei_tsuki', 'shotei_uke'],
  ),

  // ============================================================
  // ELBOW STRIKES (Hiji) — 6 techniques
  // ============================================================
  Technique(
    id: 'hiji_chudan_ate',
    japaneseName: '肘中段当て',
    englishName: 'Middle-level elbow strike',
    romajiName: 'Hiji chūdan ate',
    category: TechniqueCategory.hiji,
    description:
        'A horizontal elbow strike to the midsection delivered by swinging '
        'the bent arm across the body. One of the most powerful short-range '
        'techniques in Kyokushin, generating tremendous force from the '
        'compact motion and hip rotation.',
    keyPoints: [
      'Keep the arm tightly bent throughout the strike',
      'Drive horizontally across the body',
      'Full hip rotation is essential for power',
      'Strike with the point of the elbow',
      'Follow through the target',
    ],
    commonMistakes: [
      'Arm not bent tightly enough',
      'No hip rotation, using only arm strength',
      'Not following through the target',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['hiji_jodan_ate', 'mae_hiji_ate'],
  ),
  Technique(
    id: 'hiji_jodan_ate',
    japaneseName: '肘上段当て',
    englishName: 'Upper-level elbow strike',
    romajiName: 'Hiji jōdan ate',
    category: TechniqueCategory.hiji,
    description:
        'An upward elbow strike targeting the chin or jaw. The elbow '
        'drives upward vertically using the legs and hips to power the '
        'strike. Devastating at close range.',
    keyPoints: [
      'Drive the elbow straight upward',
      'Use leg extension and hip thrust for power',
      'Target the underside of the chin',
      'Keep the opposite hand in guard position',
    ],
    commonMistakes: [
      'Leaning backward during the upward strike',
      'Not using the legs to drive the motion',
      'Striking with the forearm instead of the elbow point',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['hiji_chudan_ate', 'age_hiji_ate'],
  ),
  Technique(
    id: 'hiji_oroshi_ate',
    japaneseName: '肘落とし当て',
    englishName: 'Downward elbow strike',
    romajiName: 'Hiji oroshi ate',
    category: TechniqueCategory.hiji,
    description:
        'A downward elbow strike dropping the point of the elbow onto '
        'the target (typically the back of the head or spine of a bent-over '
        'opponent). Uses gravity and body weight for devastating impact.',
    keyPoints: [
      'Raise the elbow high above the target',
      'Drop the elbow straight down using body weight',
      'Strike with the point of the elbow',
      'Can be combined with a jumping motion for extra power',
    ],
    commonMistakes: [
      'Not raising the elbow high enough',
      'Striking with the forearm instead of the elbow point',
      'Leaning forward and losing balance',
    ],
    requiredForBelts: [BeltRank.kyu6, BeltRank.kyu5],
    relatedTechniqueIds: ['hiji_chudan_ate', 'tettsui_oroshi_uchi'],
  ),
  Technique(
    id: 'hiji_ushiro_ate',
    japaneseName: '肘後ろ当て',
    englishName: 'Rear elbow strike',
    romajiName: 'Hiji ushiro ate',
    category: TechniqueCategory.hiji,
    description:
        'An elbow strike delivered to the rear, targeting an opponent '
        'behind you. The elbow is driven straight backward into the solar '
        'plexus or ribs of an attacker from behind. Essential for '
        'self-defense scenarios.',
    keyPoints: [
      'Drive the elbow straight back from the hip',
      'Target the solar plexus or ribs',
      'Use hip rotation to drive the strike rearward',
      'Look over the shoulder at the target',
    ],
    commonMistakes: [
      'Not looking at the target behind you',
      'Elbow going sideways instead of straight back',
      'Not using hip rotation for power',
    ],
    requiredForBelts: [BeltRank.kyu6, BeltRank.kyu5],
    relatedTechniqueIds: ['hiji_chudan_ate', 'ushiro_geri'],
  ),
  Technique(
    id: 'mae_hiji_ate',
    japaneseName: '前肘当て',
    englishName: 'Forward elbow strike',
    romajiName: 'Mae hiji ate',
    category: TechniqueCategory.hiji,
    description:
        'A forward-driving elbow strike where the elbow thrusts directly '
        'forward into the face or chest. Stepping forward with the strike '
        'adds body weight behind the technique.',
    keyPoints: [
      'Drive the elbow straight forward',
      'Step forward with the same-side leg for power',
      'Keep the fist close to the shoulder',
      'Target face, chest, or solar plexus',
    ],
    commonMistakes: [
      'Arm too loose, losing the compact elbow position',
      'Not stepping into the strike',
      'Elbow drifting sideways instead of straight forward',
    ],
    requiredForBelts: [BeltRank.kyu5, BeltRank.kyu4],
    relatedTechniqueIds: ['hiji_chudan_ate', 'hiji_jodan_ate'],
  ),
  Technique(
    id: 'age_hiji_ate',
    japaneseName: '上げ肘当て',
    englishName: 'Rising elbow strike',
    romajiName: 'Age hiji ate',
    category: TechniqueCategory.hiji,
    description:
        'A rising elbow strike that sweeps upward from a low position '
        'to strike the chin, jaw, or underside of the nose. The motion '
        'is similar to an uppercut but uses the much harder elbow point.',
    keyPoints: [
      'Start from a low position near the hip',
      'Sweep the elbow upward in an arc',
      'Strike with the point of the elbow',
      'Drive upward using the legs',
    ],
    commonMistakes: [
      'Not starting low enough to generate the rising motion',
      'Using only the arm instead of the legs to drive upward',
      'Missing the target by going too far past the chin',
    ],
    requiredForBelts: [BeltRank.kyu5, BeltRank.kyu4],
    relatedTechniqueIds: ['hiji_jodan_ate', 'seiken_ago_uchi'],
  ),

  // ============================================================
  // KNEE STRIKES (Hiza) — 4 techniques
  // ============================================================
  Technique(
    id: 'mae_hiza_geri',
    japaneseName: '前膝蹴り',
    englishName: 'Front knee kick',
    romajiName: 'Mae hiza geri',
    category: TechniqueCategory.hiza,
    description:
        'A powerful forward knee strike targeting the midsection or '
        'thigh. The knee is driven straight upward and forward into '
        'the opponent, often while grabbing their head or shoulders '
        'for control. A devastating close-range technique.',
    keyPoints: [
      'Drive the knee straight upward and forward',
      'Use the hips to thrust the knee into the target',
      'Rise on the supporting foot for extra height',
      'Can grab the opponent\'s head to pull into the strike',
      'Strike with the top of the knee',
    ],
    commonMistakes: [
      'Not driving the hips forward with the knee',
      'Rising on the supporting foot too late',
      'Leaning too far back during the strike',
    ],
    requiredForBelts: [BeltRank.kyu7, BeltRank.kyu6],
    relatedTechniqueIds: ['mawashi_hiza_geri', 'hiza_ganmen_geri'],
  ),
  Technique(
    id: 'mawashi_hiza_geri',
    japaneseName: '回し膝蹴り',
    englishName: 'Roundhouse knee kick',
    romajiName: 'Mawashi hiza geri',
    category: TechniqueCategory.hiza,
    description:
        'A circular knee strike targeting the ribs or inner thigh. The '
        'knee swings in a horizontal arc similar to a mawashi geri but '
        'at close range. Extremely powerful against the floating ribs.',
    keyPoints: [
      'Swing the knee in a horizontal arc',
      'Pivot on the supporting foot',
      'Target the floating ribs or inner thigh',
      'Use hip rotation to drive the knee',
    ],
    commonMistakes: [
      'Not pivoting on the supporting foot',
      'Swinging from too far away, reducing power',
      'Not rotating the hip through the strike',
    ],
    requiredForBelts: [BeltRank.kyu6, BeltRank.kyu5],
    relatedTechniqueIds: ['mae_hiza_geri', 'mawashi_geri_chudan'],
  ),
  Technique(
    id: 'hiza_ganmen_geri',
    japaneseName: '膝顔面蹴り',
    englishName: 'Knee face kick',
    romajiName: 'Hiza ganmen geri',
    category: TechniqueCategory.hiza,
    description:
        'A knee strike targeting the face, typically applied while pulling '
        'the opponent\'s head downward into the rising knee. A clinch '
        'technique commonly used when the opponent is bent forward.',
    keyPoints: [
      'Pull the opponent\'s head downward',
      'Drive the knee upward to meet the descending head',
      'Rise on the supporting foot for maximum height',
      'Explosive, rapid motion is key',
    ],
    commonMistakes: [
      'Not pulling the head down to meet the knee',
      'Knee not rising high enough',
      'Losing balance on the supporting leg',
    ],
    requiredForBelts: [BeltRank.kyu5, BeltRank.kyu4],
    relatedTechniqueIds: ['mae_hiza_geri', 'hiji_jodan_ate'],
  ),
  Technique(
    id: 'tobi_hiza_geri',
    japaneseName: '飛び膝蹴り',
    englishName: 'Jumping knee kick',
    romajiName: 'Tobi hiza geri',
    category: TechniqueCategory.hiza,
    description:
        'A jumping knee strike where the practitioner leaps upward and '
        'drives the knee into the opponent\'s face or chest. One of the '
        'most spectacular and devastating close-range techniques in '
        'Kyokushin fighting.',
    keyPoints: [
      'Jump explosively upward off the rear leg',
      'Drive the front knee upward at the peak of the jump',
      'Aim for the face, chest, or solar plexus',
      'Use the arms for upward momentum',
      'Land in a stable fighting stance',
    ],
    commonMistakes: [
      'Not jumping high enough before striking',
      'Kneeing on the way up instead of at the peak',
      'Landing off-balance after the technique',
    ],
    requiredForBelts: [BeltRank.kyu4, BeltRank.kyu3],
    relatedTechniqueIds: ['mae_hiza_geri', 'tobi_mae_geri'],
  ),

  // ============================================================
  // BREAKING (Tameshiwari) — 3 techniques
  // ============================================================
  Technique(
    id: 'tameshiwari_seiken',
    japaneseName: '試し割り正拳',
    englishName: 'Fist breaking',
    romajiName: 'Tameshiwari seiken',
    category: TechniqueCategory.tameshiwari,
    description:
        'Breaking boards or tiles using the forefist (seiken). The '
        'fundamental breaking technique, testing the practitioner\'s '
        'power, focus, and conditioning. Required for Dan grading in '
        'Kyokushin to demonstrate real striking power.',
    keyPoints: [
      'Strike with the first two knuckles (seiken)',
      'Focus on driving through the target, not at it',
      'Maximum hip rotation and body commitment',
      'Kiai (spirit shout) at the moment of impact',
      'Conditioning the knuckles through makiwara training',
    ],
    commonMistakes: [
      'Aiming at the surface instead of through the target',
      'Hesitating at the point of impact',
      'Striking with unconditioned or incorrect knuckles',
    ],
    requiredForBelts: [BeltRank.kyu2, BeltRank.kyu1, BeltRank.shodan],
    relatedTechniqueIds: ['tameshiwari_shuto', 'tameshiwari_hiji'],
  ),
  Technique(
    id: 'tameshiwari_shuto',
    japaneseName: '試し割り手刀',
    englishName: 'Knife-hand breaking',
    romajiName: 'Tameshiwari shuto',
    category: TechniqueCategory.tameshiwari,
    description:
        'Breaking boards using the knife-hand (edge of the open hand). '
        'Demonstrates precise targeting and hand conditioning. The hand '
        'must be perfectly conditioned to avoid injury.',
    keyPoints: [
      'Strike with the edge of the hand (little finger side)',
      'Fingers tightly together for structural integrity',
      'Drive through the target with full body weight',
      'Condition the hand gradually over months of training',
      'Relax the arm and tense only at the moment of impact',
    ],
    commonMistakes: [
      'Fingers spread on impact, risking finger injury',
      'Striking with an unconditioned hand',
      'Decelerating before impact due to fear',
    ],
    requiredForBelts: [BeltRank.kyu1, BeltRank.shodan],
    relatedTechniqueIds: ['tameshiwari_seiken', 'tameshiwari_hiji'],
  ),
  Technique(
    id: 'tameshiwari_hiji',
    japaneseName: '試し割り肘',
    englishName: 'Elbow breaking',
    romajiName: 'Tameshiwari hiji',
    category: TechniqueCategory.tameshiwari,
    description:
        'Breaking boards or tiles using the elbow. The hardest natural '
        'striking surface on the body, the elbow requires less '
        'conditioning than seiken or shuto. Demonstrates the devastating '
        'power of close-range techniques.',
    keyPoints: [
      'Strike with the point of the elbow',
      'Drive downward with full body weight',
      'Keep the arm tightly bent throughout',
      'Use hip rotation to add rotational force',
      'Commit fully — hesitation causes failure',
    ],
    commonMistakes: [
      'Striking with the forearm instead of the elbow point',
      'Not committing body weight to the downward motion',
      'Hesitating at the moment of impact',
    ],
    requiredForBelts: [BeltRank.kyu1, BeltRank.shodan],
    relatedTechniqueIds: ['tameshiwari_seiken', 'hiji_oroshi_ate'],
  ),
];
