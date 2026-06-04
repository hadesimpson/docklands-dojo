import 'package:docklands_dojo/database/daos/progress_dao.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/belt_requirement.dart';
import 'package:docklands_dojo/models/user_progress.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/services/progress_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProgressDao extends Mock implements ProgressDao {}

/// Minimal syllabus data for testing without real content dependencies.
const _testSyllabus = [
  BeltRequirement(
    rank: BeltRank.kyu10,
    japaneseName: 'Jūkyū',
    colorDescription: 'White',
    requiredKihon: ['technique_a', 'technique_b', 'technique_c'],
    requiredKata: ['kata_a'],
    kumiteRequirements: [],
    fitnessRequirements: [],
    terminology: [],
    idoGeiko: [],
    minimumTimeInGrade: Duration(days: 0),
    minimumTrainingSessions: 0,
  ),
  BeltRequirement(
    rank: BeltRank.kyu9,
    japaneseName: 'Kukyū',
    colorDescription: 'Orange',
    requiredKihon: ['technique_a', 'technique_b', 'technique_d'],
    requiredKata: ['kata_a', 'kata_b'],
    kumiteRequirements: [],
    fitnessRequirements: [],
    terminology: [],
    idoGeiko: [],
    minimumTimeInGrade: Duration(days: 90),
    minimumTrainingSessions: 20,
  ),
  BeltRequirement(
    rank: BeltRank.kyu8,
    japaneseName: 'Hachikyū',
    colorDescription: 'Orange with Blue stripe',
    requiredKihon: ['technique_a', 'technique_e'],
    requiredKata: ['kata_c'],
    kumiteRequirements: [],
    fitnessRequirements: [],
    terminology: [],
    idoGeiko: [],
    minimumTimeInGrade: Duration(days: 90),
    minimumTrainingSessions: 25,
  ),
];

void main() {
  late MockProgressDao mockDao;
  late ProgressService service;

  setUp(() {
    mockDao = MockProgressDao();
    service = ProgressService(mockDao, syllabusData: _testSyllabus);

    // Register fallback values for mocktail.
    registerFallbackValue(
      UserProgress(
        currentRank: BeltRank.kyu10,
        completedTechniques: const {},
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024),
      ),
    );
    registerFallbackValue(
      BeltAdvancement(
        fromRank: BeltRank.kyu10,
        toRank: BeltRank.kyu9,
        date: DateTime(2024),
      ),
    );
    registerFallbackValue(
      TrainingSession(date: DateTime(2024), duration: const Duration(hours: 1)),
    );
  });

  group('getCurrentProgress', () {
    test('returns null when no progress exists', () async {
      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => const Success<UserProgress?>(null));

      final result = await service.getCurrentProgress();
      expect(result, isA<Success<UserProgress?>>());
      expect((result as Success<UserProgress?>).data, isNull);
    });

    test('returns enriched progress with history and sessions', () async {
      final progress = UserProgress(
        currentRank: BeltRank.kyu9,
        completedTechniques: const {'technique_a': true},
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024, 1, 1),
      );
      final advancement = BeltAdvancement(
        fromRank: BeltRank.kyu10,
        toRank: BeltRank.kyu9,
        date: DateTime(2024, 6, 1),
      );
      final session = TrainingSession(
        date: DateTime(2024, 5, 15),
        duration: const Duration(hours: 1),
      );

      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => Success<UserProgress?>(progress));
      when(
        () => mockDao.getAdvancementHistory(),
      ).thenAnswer((_) async => Success([advancement]));
      when(
        () => mockDao.getTrainingSessions(),
      ).thenAnswer((_) async => Success([session]));

      final result = await service.getCurrentProgress();
      expect(result, isA<Success<UserProgress?>>());
      final data = (result as Success<UserProgress?>).data!;
      expect(data.currentRank, BeltRank.kyu9);
      expect(data.advancementHistory, hasLength(1));
      expect(data.trainingLog, hasLength(1));
    });

    test('returns Failure when DAO fails', () async {
      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => const Failure<UserProgress?>('db error'));

      final result = await service.getCurrentProgress();
      expect(result, isA<Failure<UserProgress?>>());
      expect((result as Failure<UserProgress?>).message, 'db error');
    });

    test('gracefully handles history/session failures', () async {
      final progress = UserProgress(
        currentRank: BeltRank.kyu10,
        completedTechniques: const {},
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024),
      );

      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => Success<UserProgress?>(progress));
      when(() => mockDao.getAdvancementHistory()).thenAnswer(
        (_) async => const Failure<List<BeltAdvancement>>('history error'),
      );
      when(() => mockDao.getTrainingSessions()).thenAnswer(
        (_) async => const Failure<List<TrainingSession>>('sessions error'),
      );

      final result = await service.getCurrentProgress();
      expect(result, isA<Success<UserProgress?>>());
      final data = (result as Success<UserProgress?>).data!;
      expect(data.advancementHistory, isEmpty);
      expect(data.trainingLog, isEmpty);
    });
  });

  group('updateCurrentBelt', () {
    test('updates rank for existing progress', () async {
      final existingProgress = UserProgress(
        currentRank: BeltRank.kyu10,
        completedTechniques: const {'technique_a': true},
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024),
      );

      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => Success<UserProgress?>(existingProgress));
      when(
        () => mockDao.saveProgress(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await service.updateCurrentBelt(BeltRank.kyu9);
      expect(result, isA<Success<void>>());

      final captured = verify(
        () => mockDao.saveProgress(captureAny()),
      ).captured;
      final savedProgress = captured.first as UserProgress;
      expect(savedProgress.currentRank, BeltRank.kyu9);
      expect(savedProgress.completedTechniques, {'technique_a': true});
    });

    test('creates new progress when none exists', () async {
      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => const Success<UserProgress?>(null));
      when(
        () => mockDao.saveProgress(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await service.updateCurrentBelt(BeltRank.kyu7);
      expect(result, isA<Success<void>>());

      final captured = verify(
        () => mockDao.saveProgress(captureAny()),
      ).captured;
      final savedProgress = captured.first as UserProgress;
      expect(savedProgress.currentRank, BeltRank.kyu7);
      expect(savedProgress.completedTechniques, isEmpty);
    });

    test('returns Failure when DAO fails', () async {
      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => const Failure<UserProgress?>('db error'));

      final result = await service.updateCurrentBelt(BeltRank.kyu9);
      expect(result, isA<Failure<void>>());
    });
  });

  group('addTrainingSession', () {
    test('delegates to DAO', () async {
      when(
        () => mockDao.addTrainingSession(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await service.addTrainingSession(
        const Duration(hours: 1, minutes: 30),
        notes: 'Kata practice',
      );
      expect(result, isA<Success<void>>());

      final captured = verify(
        () => mockDao.addTrainingSession(captureAny()),
      ).captured;
      final session = captured.first as TrainingSession;
      expect(session.duration, const Duration(hours: 1, minutes: 30));
      expect(session.notes, 'Kata practice');
    });

    test('returns Failure when DAO fails', () async {
      when(
        () => mockDao.addTrainingSession(any()),
      ).thenAnswer((_) async => const Failure<void>('db error'));

      final result = await service.addTrainingSession(const Duration(hours: 1));
      expect(result, isA<Failure<void>>());
    });
  });

  group('getAdvancementHistory', () {
    test('returns history from DAO', () async {
      final advancements = [
        BeltAdvancement(
          fromRank: BeltRank.kyu10,
          toRank: BeltRank.kyu9,
          date: DateTime(2024, 3, 1),
        ),
        BeltAdvancement(
          fromRank: BeltRank.kyu9,
          toRank: BeltRank.kyu8,
          date: DateTime(2024, 9, 1),
        ),
      ];

      when(
        () => mockDao.getAdvancementHistory(),
      ).thenAnswer((_) async => Success(advancements));

      final result = await service.getAdvancementHistory();
      expect(result, isA<Success<List<BeltAdvancement>>>());
      expect((result as Success<List<BeltAdvancement>>).data, hasLength(2));
    });
  });

  group('getTrainingSessions', () {
    test('returns all sessions when no range specified', () async {
      final sessions = [
        TrainingSession(
          date: DateTime(2024, 5, 1),
          duration: const Duration(hours: 1),
        ),
        TrainingSession(
          date: DateTime(2024, 6, 1),
          duration: const Duration(hours: 2),
        ),
      ];

      when(
        () => mockDao.getTrainingSessions(),
      ).thenAnswer((_) async => Success(sessions));

      final result = await service.getTrainingSessions();
      expect(result, isA<Success<List<TrainingSession>>>());
      expect((result as Success<List<TrainingSession>>).data, hasLength(2));
    });

    test('filters sessions by date range', () async {
      final sessions = [
        TrainingSession(
          date: DateTime(2024, 3, 15),
          duration: const Duration(hours: 1),
        ),
        TrainingSession(
          date: DateTime(2024, 5, 10),
          duration: const Duration(hours: 1),
        ),
        TrainingSession(
          date: DateTime(2024, 7, 20),
          duration: const Duration(hours: 1),
        ),
      ];

      when(
        () => mockDao.getTrainingSessions(),
      ).thenAnswer((_) async => Success(sessions));

      final result = await service.getTrainingSessions(
        start: DateTime(2024, 4, 1),
        end: DateTime(2024, 6, 30),
      );

      expect(result, isA<Success<List<TrainingSession>>>());
      final data = (result as Success<List<TrainingSession>>).data;
      expect(data, hasLength(1));
      expect(data.first.date, DateTime(2024, 5, 10));
    });
  });

  group('calculateCompletionPercentage', () {
    test('returns 0.0 when no techniques completed', () {
      final pct = service.calculateCompletionPercentage(
        BeltRank.kyu10,
        const {},
      );
      expect(pct, 0.0);
    });

    test('returns correct ratio for partial completion', () {
      // kyu10 requires: technique_a, technique_b, technique_c, kata_a = 4
      final pct = service.calculateCompletionPercentage(BeltRank.kyu10, const {
        'technique_a': true,
        'technique_b': true,
      });
      expect(pct, closeTo(0.5, 0.001)); // 2/4
    });

    test('returns 1.0 when all techniques completed', () {
      final pct = service.calculateCompletionPercentage(BeltRank.kyu10, const {
        'technique_a': true,
        'technique_b': true,
        'technique_c': true,
        'kata_a': true,
      });
      expect(pct, 1.0);
    });

    test('ignores techniques marked false', () {
      final pct = service.calculateCompletionPercentage(BeltRank.kyu10, const {
        'technique_a': true,
        'technique_b': false,
        'technique_c': true,
        'kata_a': true,
      });
      expect(pct, closeTo(0.75, 0.001)); // 3/4
    });

    test('returns 0.0 for unknown rank', () {
      // shodan not in test syllabus
      final pct = service.calculateCompletionPercentage(BeltRank.shodan, const {
        'technique_a': true,
      });
      expect(pct, 0.0);
    });
  });

  group('canAdvanceTo', () {
    test('returns true when all requirements met and rank is next', () async {
      final progress = UserProgress(
        currentRank: BeltRank.kyu10,
        completedTechniques: const {
          'technique_a': true,
          'technique_b': true,
          'technique_d': true,
          'kata_a': true,
          'kata_b': true,
        },
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024),
      );

      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => Success<UserProgress?>(progress));
      when(
        () => mockDao.getAdvancementHistory(),
      ).thenAnswer((_) async => const Success<List<BeltAdvancement>>([]));
      when(
        () => mockDao.getTrainingSessions(),
      ).thenAnswer((_) async => const Success<List<TrainingSession>>([]));

      final result = await service.canAdvanceTo(BeltRank.kyu9);
      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isTrue);
    });

    test('returns false when requirements not met', () async {
      final progress = UserProgress(
        currentRank: BeltRank.kyu10,
        completedTechniques: const {'technique_a': true},
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024),
      );

      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => Success<UserProgress?>(progress));
      when(
        () => mockDao.getAdvancementHistory(),
      ).thenAnswer((_) async => const Success<List<BeltAdvancement>>([]));
      when(
        () => mockDao.getTrainingSessions(),
      ).thenAnswer((_) async => const Success<List<TrainingSession>>([]));

      final result = await service.canAdvanceTo(BeltRank.kyu9);
      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isFalse);
    });

    test('returns false when skipping ranks', () async {
      final progress = UserProgress(
        currentRank: BeltRank.kyu10,
        completedTechniques: const {
          'technique_a': true,
          'technique_e': true,
          'kata_c': true,
        },
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024),
      );

      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => Success<UserProgress?>(progress));
      when(
        () => mockDao.getAdvancementHistory(),
      ).thenAnswer((_) async => const Success<List<BeltAdvancement>>([]));
      when(
        () => mockDao.getTrainingSessions(),
      ).thenAnswer((_) async => const Success<List<TrainingSession>>([]));

      // kyu8 is two ranks up from kyu10
      final result = await service.canAdvanceTo(BeltRank.kyu8);
      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isFalse);
    });

    test('returns false when no progress exists', () async {
      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => const Success<UserProgress?>(null));

      final result = await service.canAdvanceTo(BeltRank.kyu9);
      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isFalse);
    });

    test('returns Failure when DAO fails', () async {
      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => const Failure<UserProgress?>('db error'));

      final result = await service.canAdvanceTo(BeltRank.kyu9);
      expect(result, isA<Failure<bool>>());
    });
  });

  group('advanceBelt', () {
    test('records advancement and updates rank', () async {
      final progress = UserProgress(
        currentRank: BeltRank.kyu10,
        completedTechniques: const {
          'technique_a': true,
          'technique_b': true,
          'technique_d': true,
          'kata_a': true,
          'kata_b': true,
        },
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024),
      );

      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => Success<UserProgress?>(progress));
      when(
        () => mockDao.getAdvancementHistory(),
      ).thenAnswer((_) async => const Success<List<BeltAdvancement>>([]));
      when(
        () => mockDao.getTrainingSessions(),
      ).thenAnswer((_) async => const Success<List<TrainingSession>>([]));
      when(
        () => mockDao.addBeltAdvancement(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      when(
        () => mockDao.saveProgress(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await service.advanceBelt(
        BeltRank.kyu9,
        notes: 'First grading',
      );
      expect(result, isA<Success<void>>());

      // Verify advancement was recorded.
      final advCapture = verify(
        () => mockDao.addBeltAdvancement(captureAny()),
      ).captured;
      final advancement = advCapture.first as BeltAdvancement;
      expect(advancement.fromRank, BeltRank.kyu10);
      expect(advancement.toRank, BeltRank.kyu9);
      expect(advancement.notes, 'First grading');

      // Verify rank was updated.
      final saveCapture = verify(
        () => mockDao.saveProgress(captureAny()),
      ).captured;
      final saved = saveCapture.first as UserProgress;
      expect(saved.currentRank, BeltRank.kyu9);
    });

    test('returns Failure when no progress exists', () async {
      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => const Success<UserProgress?>(null));

      final result = await service.advanceBelt(BeltRank.kyu9);
      expect(result, isA<Failure<void>>());
      expect(
        (result as Failure<void>).message,
        contains('Prerequisites not met'),
      );
    });

    test('returns Failure when advancement insert fails', () async {
      final progress = UserProgress(
        currentRank: BeltRank.kyu10,
        completedTechniques: const {},
        advancementHistory: const [],
        trainingLog: const [],
        startDate: DateTime(2024),
      );

      when(
        () => mockDao.getProgress(),
      ).thenAnswer((_) async => Success<UserProgress?>(progress));
      when(
        () => mockDao.getAdvancementHistory(),
      ).thenAnswer((_) async => const Success<List<BeltAdvancement>>([]));
      when(
        () => mockDao.getTrainingSessions(),
      ).thenAnswer((_) async => const Success<List<TrainingSession>>([]));
      when(
        () => mockDao.addBeltAdvancement(any()),
      ).thenAnswer((_) async => const Failure<void>('insert failed'));

      final result = await service.advanceBelt(BeltRank.kyu9);
      expect(result, isA<Failure<void>>());
    });
  });
}
