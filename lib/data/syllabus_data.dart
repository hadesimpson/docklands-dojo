import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/belt_requirement.dart';
import 'package:docklands_dojo/models/fitness.dart';
import 'package:docklands_dojo/models/kumite.dart';

/// Belt requirements for all 11 ranks in the IKO-1 Kyokushin syllabus.
///
/// Each [BeltRequirement] defines the complete set of requirements a
/// student must demonstrate to grade at that level, including kihon
/// (basics), kata, kumite (sparring), fitness standards, terminology,
/// and ido geiko (moving combinations).
///
/// Fitness numbers follow the IKO-1 standard table (see PRD §5).
/// All data is AI-generated and must be expert-validated. See
/// `CONTENT_REVIEW.md` for validation status.
const List<BeltRequirement> allBeltRequirements = [
  // ============================================================
  // 10th Kyu — White Belt
  // ============================================================
  BeltRequirement(
    rank: BeltRank.kyu10,
    japaneseName: 'Jūkyū',
    colorDescription: 'White',
    requiredKihon: [
      // Stances
      'heisoku_dachi',
      'musubi_dachi',
      'heiko_dachi',
      'shizen_tai',
      'uchi_hachiji_dachi',
      'zenkutsu_dachi',
      'kiba_dachi',
      // Punches
      'seiken_chudan_tsuki',
      'seiken_jodan_tsuki',
      // Kicks
      'mae_geri_chudan',
      'mawashi_geri_chudan',
      'kin_geri',
      'mae_keage',
      // Blocks
      'seiken_jodan_uke',
      'seiken_chudan_soto_uke',
      'seiken_chudan_uchi_uke',
      'seiken_gedan_barai',
      // Strikes
      'uraken_shomen_uchi',
    ],
    requiredKata: [
      'taikyoku_sono_ichi',
      'taikyoku_sono_ni',
      'taikyoku_sono_san',
    ],
    kumiteRequirements: [],
    fitnessRequirements: [
      FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 20,
        unit: 'reps',
        notes: 'On knuckles (seiken)',
      ),
      FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 30,
        unit: 'reps',
      ),
      FitnessRequirement(exerciseName: 'Squats', targetCount: 20, unit: 'reps'),
    ],
    terminology: [
      'Osu',
      'Dojo',
      'Sensei',
      'Senpai',
      'Seiza',
      'Mokuso',
      'Rei',
      'Yoi',
      'Hajime',
      'Yame',
      'Mawate',
      'Naore',
    ],
    idoGeiko: [
      'Zenkutsu dachi — seiken chudan oi tsuki (advancing)',
      'Zenkutsu dachi — seiken jodan oi tsuki (advancing)',
      'Zenkutsu dachi — mae geri chudan (advancing)',
      'Zenkutsu dachi — seiken jodan uke (advancing)',
      'Zenkutsu dachi — seiken gedan barai (advancing)',
    ],
    minimumTimeInGrade: Duration(days: 90),
    minimumTrainingSessions: 20,
  ),

  // ============================================================
  // 9th Kyu — Orange Belt
  // ============================================================
  BeltRequirement(
    rank: BeltRank.kyu9,
    japaneseName: 'Kukyū',
    colorDescription: 'Orange',
    requiredKihon: [
      // Stances (new)
      'sanchin_dachi',
      'kokutsu_dachi',
      // Punches (new)
      'seiken_ago_uchi',
      'seiken_shita_tsuki',
      // Kicks (new)
      'mae_geri_jodan',
      'mawashi_geri_jodan',
      'yoko_geri_keage',
      'yoko_geri_kekomi',
      // Strikes (new)
      'uraken_sayu_uchi',
      'uraken_shomen_uchi',
    ],
    requiredKata: [
      'sokugi_taikyoku_sono_ichi',
      'sokugi_taikyoku_sono_ni',
      'sokugi_taikyoku_sono_san',
    ],
    kumiteRequirements: [],
    fitnessRequirements: [
      FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 25,
        unit: 'reps',
        notes: 'On knuckles (seiken)',
      ),
      FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 35,
        unit: 'reps',
      ),
      FitnessRequirement(exerciseName: 'Squats', targetCount: 25, unit: 'reps'),
    ],
    terminology: [
      'Ichi',
      'Ni',
      'San',
      'Shi',
      'Go',
      'Roku',
      'Shichi',
      'Hachi',
      'Ku',
      'Jū',
      'Jodan',
      'Chudan',
      'Gedan',
    ],
    idoGeiko: [
      'Zenkutsu dachi — mae geri jodan (advancing)',
      'Zenkutsu dachi — mawashi geri chudan (advancing)',
      'Zenkutsu dachi — yoko geri keage (advancing)',
      'Kokutsu dachi — seiken chudan gyaku tsuki (advancing)',
      'Sanchin dachi — seiken chudan tsuki (advancing with ibuki)',
    ],
    minimumTimeInGrade: Duration(days: 90),
    minimumTrainingSessions: 25,
  ),

  // ============================================================
  // 8th Kyu — Orange with Blue Stripe
  // ============================================================
  BeltRequirement(
    rank: BeltRank.kyu8,
    japaneseName: 'Hachikyū',
    colorDescription: 'Orange with Blue stripe',
    requiredKihon: [
      // Punches (new)
      'seiken_kagi_tsuki',
      'seiken_ago_uchi',
      'seiken_shita_tsuki',
      // Kicks (review + new)
      'mae_geri_jodan',
      'mawashi_geri_jodan',
      'yoko_geri_keage',
      'yoko_geri_kekomi',
      // Blocks (new)
      'shuto_mawashi_uke',
      'shuto_jodan_uke',
      // Strikes (new)
      'uraken_hizo_uchi',
      'uraken_oroshi_uchi',
      'shuto_sakotsu_uchi',
      'tettsui_oroshi_uchi',
    ],
    requiredKata: ['pinan_sono_ichi', 'pinan_sono_ni'],
    kumiteRequirements: [],
    fitnessRequirements: [
      FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 25,
        unit: 'reps',
        notes: 'On knuckles (seiken)',
      ),
      FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 35,
        unit: 'reps',
      ),
      FitnessRequirement(exerciseName: 'Squats', targetCount: 25, unit: 'reps'),
    ],
    terminology: [
      'Hidari',
      'Migi',
      'Mae',
      'Ushiro',
      'Yoko',
      'Oi tsuki',
      'Gyaku tsuki',
      'Shuto',
      'Uraken',
    ],
    idoGeiko: [
      'Zenkutsu dachi — jodan uke + chudan gyaku tsuki (advancing)',
      'Zenkutsu dachi — chudan soto uke + chudan gyaku tsuki (advancing)',
      'Zenkutsu dachi — gedan barai + chudan gyaku tsuki (advancing)',
      'Zenkutsu dachi — mae geri + chudan oi tsuki (advancing)',
      'Kokutsu dachi — shuto mawashi uke (advancing)',
    ],
    minimumTimeInGrade: Duration(days: 90),
    minimumTrainingSessions: 25,
  ),

  // ============================================================
  // 7th Kyu — Blue Belt
  // ============================================================
  BeltRequirement(
    rank: BeltRank.kyu7,
    japaneseName: 'Nanakyū',
    colorDescription: 'Blue',
    requiredKihon: [
      // Stances (review + new)
      'neko_ashi_dachi',
      'tsuru_ashi_dachi',
      'sanchin_dachi',
      'kokutsu_dachi',
      // Punches (new)
      'morote_tsuki',
      'ura_tsuki',
      'seiken_kagi_tsuki',
      // Kicks (new)
      'ushiro_geri',
      'kansetsu_geri',
      // Blocks (new + review)
      'shuto_mawashi_uke',
      'shuto_jodan_uke',
      'morote_uke',
      // Strikes (new)
      'uraken_mawashi_uchi',
      'shuto_sakotsu_uchi_komi',
      'shuto_hizo_uchi',
      'tettsui_komi_uchi',
      // Elbow (new)
      'hiji_chudan_ate',
      'hiji_jodan_ate',
      // Knee (new)
      'mae_hiza_geri',
    ],
    requiredKata: ['pinan_sono_san', 'sanchin'],
    kumiteRequirements: [
      KumiteRequirement(
        type: KumiteType.yakusoku,
        description: 'Prearranged sparring with set attack-defense sequences',
        rounds: 3,
        roundDuration: Duration(minutes: 1, seconds: 30),
      ),
      KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Full-contact free sparring',
        rounds: 3,
        roundDuration: Duration(minutes: 1, seconds: 30),
      ),
    ],
    fitnessRequirements: [
      FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 30,
        unit: 'reps',
        notes: 'On knuckles (seiken)',
      ),
      FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 40,
        unit: 'reps',
      ),
      FitnessRequirement(exerciseName: 'Squats', targetCount: 30, unit: 'reps'),
    ],
    terminology: [
      'Ibuki',
      'Nogare',
      'Kiai',
      'Kumite',
      'Jiyu kumite',
      'Yakusoku kumite',
      'Mokuso',
      'Senpai ni rei',
      'Sensei ni rei',
    ],
    idoGeiko: [
      'Zenkutsu dachi — mae geri + mawashi geri chudan (advancing)',
      'Zenkutsu dachi — ushiro geri (advancing)',
      'Kokutsu dachi — shuto mawashi uke + nukite (advancing)',
      'Sanchin dachi — sanchin tsuki with ibuki (advancing)',
      'Kiba dachi — yoko geri keage + uraken sayu uchi (advancing)',
    ],
    minimumTimeInGrade: Duration(days: 120),
    minimumTrainingSessions: 30,
  ),

  // ============================================================
  // 6th Kyu — Blue with Yellow Stripe
  // ============================================================
  BeltRequirement(
    rank: BeltRank.kyu6,
    japaneseName: 'Rokkyū',
    colorDescription: 'Blue with Yellow stripe',
    requiredKihon: [
      // Punches (new)
      'furi_tsuki',
      'age_tsuki',
      'morote_tsuki',
      'ura_tsuki',
      // Kicks (new)
      'ushiro_geri',
      'kansetsu_geri',
      // Blocks (new)
      'koken_uke',
      'juji_uke',
      'shotei_uke',
      // Strikes (new)
      'uraken_mawashi_uchi',
      'shuto_sakotsu_uchi_komi',
      'shuto_hizo_uchi',
      'shuto_jodan_uchi',
      'shotei_uchi',
      'tettsui_komi_uchi',
      // Elbow (new + review)
      'hiji_chudan_ate',
      'hiji_jodan_ate',
      'hiji_oroshi_ate',
      'hiji_ushiro_ate',
      // Knee (new)
      'mae_hiza_geri',
      'mawashi_hiza_geri',
    ],
    requiredKata: ['pinan_sono_yon', 'tsuki_no_kata'],
    kumiteRequirements: [
      KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Full-contact free sparring',
        rounds: 3,
        roundDuration: Duration(minutes: 1, seconds: 30),
      ),
    ],
    fitnessRequirements: [
      FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 35,
        unit: 'reps',
        notes: 'On knuckles (seiken)',
      ),
      FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 45,
        unit: 'reps',
      ),
      FitnessRequirement(exerciseName: 'Squats', targetCount: 35, unit: 'reps'),
    ],
    terminology: [
      'Dojo Kun (first two precepts)',
      'Tameshiwari',
      'Kanku',
      'Oss no seishin',
      'Sosai',
      'Shihan',
      'Sempai',
    ],
    idoGeiko: [
      'Zenkutsu dachi — mae geri + mawashi geri + ushiro geri (advancing)',
      'Kokutsu dachi — shuto mawashi uke + nukite + mae geri (advancing)',
      'Kiba dachi — yoko geri kekomi + uraken mawashi uchi (advancing)',
      'Zenkutsu dachi — hiji chudan ate (advancing)',
      'Zenkutsu dachi — mae hiza geri (advancing)',
    ],
    minimumTimeInGrade: Duration(days: 120),
    minimumTrainingSessions: 35,
  ),

  // ============================================================
  // 5th Kyu — Yellow Belt
  // ============================================================
  BeltRequirement(
    rank: BeltRank.kyu5,
    japaneseName: 'Gokyū',
    colorDescription: 'Yellow',
    requiredKihon: [
      // Stances (review)
      'neko_ashi_dachi',
      'tsuru_ashi_dachi',
      // Punches (new)
      'tate_tsuki',
      'shotei_tsuki',
      // Kicks (new)
      'ushiro_mawashi_geri',
      'tobi_mae_geri',
      // Blocks (review)
      'koken_uke',
      'juji_uke',
      'shotei_uke',
      // Strikes (new)
      'shuto_jodan_uchi',
      'shotei_uchi',
      // Elbow (new)
      'mae_hiji_ate',
      'age_hiji_ate',
      'hiji_oroshi_ate',
      'hiji_ushiro_ate',
      // Knee (new)
      'mawashi_hiza_geri',
      'hiza_ganmen_geri',
    ],
    requiredKata: ['pinan_sono_go', 'yantsu'],
    kumiteRequirements: [
      KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Full-contact free sparring',
        rounds: 4,
        roundDuration: Duration(minutes: 2),
      ),
    ],
    fitnessRequirements: [
      FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 40,
        unit: 'reps',
        notes: 'On knuckles (seiken)',
      ),
      FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 50,
        unit: 'reps',
      ),
      FitnessRequirement(exerciseName: 'Squats', targetCount: 40, unit: 'reps'),
    ],
    terminology: [
      'Dojo Kun (all five precepts)',
      'Kata no bunkai',
      'Kime',
      'Zanshin',
      'Ma-ai',
      'Tai sabaki',
    ],
    idoGeiko: [
      'Zenkutsu dachi — ushiro mawashi geri (advancing)',
      'Zenkutsu dachi — mae geri + mawashi geri + ushiro geri (combination)',
      'Neko ashi dachi — shuto mawashi uke + mae geri + shuto sakotsu uchi',
      'Kiba dachi — yoko geri kekomi + empi uchi (advancing)',
      'Zenkutsu dachi — mawashi hiza geri + hiji chudan ate (advancing)',
    ],
    minimumTimeInGrade: Duration(days: 180),
    minimumTrainingSessions: 40,
  ),

  // ============================================================
  // 4th Kyu — Yellow with Green Stripe
  // ============================================================
  BeltRequirement(
    rank: BeltRank.kyu4,
    japaneseName: 'Yonkyū',
    colorDescription: 'Yellow with Green stripe',
    requiredKihon: [
      // Punches (new)
      'nukite',
      'tate_tsuki',
      'shotei_tsuki',
      // Kicks (new)
      'ushiro_mawashi_geri',
      'tobi_mae_geri',
      'tobi_mawashi_geri',
      // Elbow (new)
      'mae_hiji_ate',
      'age_hiji_ate',
      // Knee (new)
      'hiza_ganmen_geri',
      'tobi_hiza_geri',
    ],
    requiredKata: ['saifa', 'gekisai_dai'],
    kumiteRequirements: [
      KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Full-contact free sparring',
        rounds: 4,
        roundDuration: Duration(minutes: 2),
      ),
    ],
    fitnessRequirements: [
      FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 45,
        unit: 'reps',
        notes: 'On knuckles (seiken)',
      ),
      FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 60,
        unit: 'reps',
      ),
      FitnessRequirement(exerciseName: 'Squats', targetCount: 45, unit: 'reps'),
    ],
    terminology: ['Bunkai', 'Oyo', 'Henka', 'Tai sabaki', 'Irimi', 'Nagashi'],
    idoGeiko: [
      'Zenkutsu dachi — tobi mae geri (advancing)',
      'Zenkutsu dachi — mawashi geri + ushiro mawashi geri (combination)',
      'Kiba dachi — yoko geri kekomi + hiji chudan ate (advancing)',
      'Zenkutsu dachi — mae geri + mawashi geri + ushiro geri + ushiro mawashi geri (four-kick combination)',
      'Neko ashi dachi — shuto mawashi uke + mae geri + shuto sakotsu uchi komi (advancing)',
    ],
    minimumTimeInGrade: Duration(days: 180),
    minimumTrainingSessions: 45,
  ),

  // ============================================================
  // 3rd Kyu — Green Belt
  // ============================================================
  BeltRequirement(
    rank: BeltRank.kyu3,
    japaneseName: 'Sankyū',
    colorDescription: 'Green',
    requiredKihon: [
      // Kicks (new)
      'tobi_mawashi_geri',
      'tobi_ushiro_geri',
      // All previous techniques refined
      'nukite',
      // Knee (new)
      'tobi_hiza_geri',
    ],
    requiredKata: ['gekisai_sho', 'tensho'],
    kumiteRequirements: [
      KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Full-contact free sparring',
        rounds: 5,
        roundDuration: Duration(minutes: 2),
      ),
    ],
    fitnessRequirements: [
      FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 50,
        unit: 'reps',
        notes: 'On knuckles (seiken)',
      ),
      FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 70,
        unit: 'reps',
      ),
      FitnessRequirement(exerciseName: 'Squats', targetCount: 50, unit: 'reps'),
    ],
    terminology: [
      'Tensho',
      'Ibuki',
      'Nogare',
      'Shime',
      'Kihon',
      'Ido geiko',
      'Renraku',
    ],
    idoGeiko: [
      'Zenkutsu dachi — tobi mawashi geri (advancing)',
      'Zenkutsu dachi — tobi ushiro geri (advancing)',
      'Complex combination: mae geri + mawashi geri + ushiro geri + ushiro mawashi geri + tobi mae geri',
      'Kiba dachi — yoko geri kekomi + empi uchi + uraken mawashi uchi',
      'Sanchin dachi — tensho hand movements with ibuki',
    ],
    minimumTimeInGrade: Duration(days: 180),
    minimumTrainingSessions: 50,
  ),

  // ============================================================
  // 2nd Kyu — Brown Belt
  // ============================================================
  BeltRequirement(
    rank: BeltRank.kyu2,
    japaneseName: 'Nikyū',
    colorDescription: 'Brown',
    requiredKihon: [
      // Advanced kicks
      'tobi_ushiro_geri',
      // Breaking (introduced)
      'tameshiwari_seiken',
      // All previous techniques must be demonstrated at high level
    ],
    requiredKata: ['seienchin'],
    kumiteRequirements: [
      KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Full-contact free sparring — consecutive rounds',
        rounds: 7,
        roundDuration: Duration(minutes: 2),
      ),
    ],
    fitnessRequirements: [
      FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 60,
        unit: 'reps',
        notes: 'On knuckles (seiken)',
      ),
      FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 80,
        unit: 'reps',
      ),
      FitnessRequirement(exerciseName: 'Squats', targetCount: 60, unit: 'reps'),
    ],
    terminology: [
      'Seienchin meaning',
      'Naha-te',
      'Shuri-te',
      'Tomari-te',
      'Sosai Mas Oyama history',
      'Mt. Minobu training',
    ],
    idoGeiko: [
      'All previous ido geiko at full speed and power',
      'Free-form combination creation (student-designed)',
      'Five-kick combination with spinning techniques',
      'Elbow and knee combination sequences',
      'Close-range fighting combinations (clinch work)',
    ],
    minimumTimeInGrade: Duration(days: 270),
    minimumTrainingSessions: 60,
  ),

  // ============================================================
  // 1st Kyu — Brown Belt
  // ============================================================
  BeltRequirement(
    rank: BeltRank.kyu1,
    japaneseName: 'Ikkyū',
    colorDescription: 'Brown',
    requiredKihon: [
      // Breaking (expanded)
      'tameshiwari_seiken',
      'tameshiwari_shuto',
      'tameshiwari_hiji',
      // All techniques must be demonstrated at instructor level
    ],
    requiredKata: ['garyu'],
    kumiteRequirements: [
      KumiteRequirement(
        type: KumiteType.jiyu,
        description: 'Full-contact free sparring — consecutive rounds',
        rounds: 10,
        roundDuration: Duration(minutes: 2),
      ),
    ],
    fitnessRequirements: [
      FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 70,
        unit: 'reps',
        notes: 'On knuckles (seiken)',
      ),
      FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 100,
        unit: 'reps',
      ),
      FitnessRequirement(exerciseName: 'Squats', targetCount: 70, unit: 'reps'),
    ],
    terminology: [
      'Garyu meaning',
      'Kanku dai meaning',
      'History of 100-man kumite',
      'Bull fighting legend',
      'Kyokushin kaikan history',
      'IKO organizational structure',
    ],
    idoGeiko: [
      'All ido geiko must be demonstrated at instructor level',
      'Student must create and demonstrate original combination',
      'Continuous kicking combination (7+ kicks without stopping)',
      'Advanced elbow-knee-sweep combinations',
      'Instructor-level demonstration of all basic ido geiko',
    ],
    minimumTimeInGrade: Duration(days: 365),
    minimumTrainingSessions: 80,
  ),

  // ============================================================
  // Shodan — Black Belt (1st Dan)
  // ============================================================
  BeltRequirement(
    rank: BeltRank.shodan,
    japaneseName: 'Shodan',
    colorDescription: 'Black',
    requiredKihon: [
      // All 72 techniques must be demonstrated at expert level
      // Breaking required
      'tameshiwari_seiken',
      'tameshiwari_shuto',
      'tameshiwari_hiji',
    ],
    requiredKata: ['kanku_dai', 'seipai'],
    kumiteRequirements: [
      KumiteRequirement(
        type: KumiteType.jiyu,
        description:
            'Full-contact free sparring — 20 consecutive rounds '
            '(hyakunin kumite spirit)',
        rounds: 20,
        roundDuration: Duration(minutes: 2),
      ),
    ],
    fitnessRequirements: [
      FitnessRequirement(
        exerciseName: 'Push-ups',
        targetCount: 100,
        unit: 'reps',
        notes: 'On knuckles (seiken), consecutive',
      ),
      FitnessRequirement(
        exerciseName: 'Sit-ups',
        targetCount: 150,
        unit: 'reps',
      ),
      FitnessRequirement(
        exerciseName: 'Squats',
        targetCount: 100,
        unit: 'reps',
      ),
    ],
    terminology: [
      'Complete Dojo Kun in Japanese',
      'Kyokushin oath (Seisan)',
      'History of Kyokushin worldwide',
      'All Japanese counting to 100',
      'All body target terminology',
      'All technique names in Japanese',
      'Tournament judging terminology',
    ],
    idoGeiko: [
      'All ido geiko at expert level',
      'Original kata creation and demonstration',
      'Continuous fighting combinations (10+ technique sequences)',
      'Advanced jumping and spinning combinations',
      'Demonstration of all techniques with bunkai applications',
    ],
    minimumTimeInGrade: Duration(days: 730),
    minimumTrainingSessions: 100,
  ),
];
