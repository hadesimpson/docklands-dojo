import 'package:docklands_dojo/database/daos/review_dao.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/services/srs/review_service.dart';
import 'package:docklands_dojo/services/srs/sm2_algorithm.dart';
import 'package:docklands_dojo/services/srs/srs_algorithm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewDao extends Mock implements ReviewDao {}

class FakeCardReviewState extends Fake implements CardReviewState {}

void main() {
  late MockReviewDao mockDao;
  late ReviewService service;
  final now = DateTime(2026, 6, 3, 12, 0);

  setUp(() {
    mockDao = MockReviewDao();
    service = ReviewService(dao: mockDao);
  });

  setUpAll(() {
    registerFallbackValue(FakeCardReviewState());
  });

  CardReviewState makeCard({
    String cardId = 'card_1',
    double easeFactor = 2.5,
    int interval = 0,
    int repetitions = 0,
    DateTime? nextReviewDate,
    DateTime? lastReviewDate,
    int totalReviews = 0,
    int correctReviews = 0,
  }) => CardReviewState(
    cardId: cardId,
    easeFactor: easeFactor,
    interval: interval,
    repetitions: repetitions,
    nextReviewDate: nextReviewDate ?? now,
    lastReviewDate: lastReviewDate ?? now,
    totalReviews: totalReviews,
    correctReviews: correctReviews,
  );

  group('getDueCards', () {
    test('delegates to DAO', () async {
      final cards = [makeCard(cardId: 'a'), makeCard(cardId: 'b')];
      when(
        () => mockDao.getDueCards(now),
      ).thenAnswer((_) async => Success(cards));

      final result = await service.getDueCards(now);

      switch (result) {
        case Success(:final data):
          expect(data.length, 2);
          expect(data[0].cardId, 'a');
          expect(data[1].cardId, 'b');
        case Failure(:final message):
          fail('Expected success but got: $message');
      }
      verify(() => mockDao.getDueCards(now)).called(1);
    });

    test('returns Failure when DAO fails', () async {
      when(
        () => mockDao.getDueCards(now),
      ).thenAnswer((_) async => const Failure('DB error'));

      final result = await service.getDueCards(now);

      expect(result, isA<Failure<List<CardReviewState>>>());
    });
  });

  group('reviewCard', () {
    test('updates card state after correct answer (q=4)', () async {
      final card = makeCard(
        cardId: 'card_1',
        easeFactor: 2.5,
        interval: 1,
        repetitions: 1,
        totalReviews: 5,
        correctReviews: 4,
      );

      when(
        () => mockDao.getReviewState('card_1'),
      ).thenAnswer((_) async => Success(card));
      when(
        () => mockDao.saveReviewState(any()),
      ).thenAnswer((_) async => const Success(null));

      final result = await service.reviewCard(
        cardId: 'card_1',
        quality: 4,
        now: now,
      );

      switch (result) {
        case Success(:final data):
          expect(data.cardId, 'card_1');
          // EF stays at 2.5 for q=4
          expect(data.easeFactor, closeTo(2.5, 0.001));
          expect(data.repetitions, 2);
          expect(data.interval, 6);
          expect(data.totalReviews, 6);
          expect(data.correctReviews, 5);
          expect(data.lastReviewDate, now);
          expect(data.nextReviewDate, now.add(const Duration(days: 6)));
        case Failure(:final message):
          fail('Expected success but got: $message');
      }

      verify(() => mockDao.saveReviewState(any())).called(1);
    });

    test('resets on incorrect answer (q=1)', () async {
      final card = makeCard(
        cardId: 'card_2',
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
        totalReviews: 3,
        correctReviews: 3,
      );

      when(
        () => mockDao.getReviewState('card_2'),
      ).thenAnswer((_) async => Success(card));
      when(
        () => mockDao.saveReviewState(any()),
      ).thenAnswer((_) async => const Success(null));

      final result = await service.reviewCard(
        cardId: 'card_2',
        quality: 1,
        now: now,
      );

      switch (result) {
        case Success(:final data):
          expect(data.repetitions, 0);
          expect(data.interval, 1);
          expect(data.totalReviews, 4);
          // correctReviews unchanged for incorrect answer
          expect(data.correctReviews, 3);
          expect(data.nextReviewDate, now.add(const Duration(days: 1)));
        case Failure(:final message):
          fail('Expected success but got: $message');
      }
    });

    test('returns Failure when card not found', () async {
      when(
        () => mockDao.getReviewState('missing'),
      ).thenAnswer((_) async => const Success(null));

      final result = await service.reviewCard(
        cardId: 'missing',
        quality: 4,
        now: now,
      );

      expect(result, isA<Failure<CardReviewState>>());
      switch (result) {
        case Failure(:final message):
          expect(message, contains('not found'));
        default:
          fail('Expected Failure');
      }
    });

    test('returns Failure when DAO getReviewState fails', () async {
      when(
        () => mockDao.getReviewState('card_1'),
      ).thenAnswer((_) async => const Failure('DB read error'));

      final result = await service.reviewCard(
        cardId: 'card_1',
        quality: 4,
        now: now,
      );

      expect(result, isA<Failure<CardReviewState>>());
    });

    test('returns Failure when DAO saveReviewState fails', () async {
      final card = makeCard(cardId: 'card_1');
      when(
        () => mockDao.getReviewState('card_1'),
      ).thenAnswer((_) async => Success(card));
      when(
        () => mockDao.saveReviewState(any()),
      ).thenAnswer((_) async => const Failure('DB write error'));

      final result = await service.reviewCard(
        cardId: 'card_1',
        quality: 5,
        now: now,
      );

      expect(result, isA<Failure<CardReviewState>>());
    });
  });

  group('createCard', () {
    test('creates card with default SM-2 state', () async {
      when(
        () => mockDao.saveReviewState(any()),
      ).thenAnswer((_) async => const Success(null));

      final result = await service.createCard('new_card', now: now);

      expect(result, isA<Success<void>>());

      final captured =
          verify(() => mockDao.saveReviewState(captureAny())).captured.single
              as CardReviewState;

      expect(captured.cardId, 'new_card');
      expect(captured.easeFactor, SM2Algorithm.defaultEaseFactor);
      expect(captured.interval, 0);
      expect(captured.repetitions, 0);
      expect(captured.totalReviews, 0);
      expect(captured.correctReviews, 0);
      expect(captured.nextReviewDate, now);
      expect(captured.lastReviewDate, now);
    });
  });

  group('getReviewStats', () {
    test('computes aggregate stats from all cards', () async {
      final cards = [
        makeCard(cardId: 'a', totalReviews: 10, correctReviews: 8),
        makeCard(cardId: 'b', totalReviews: 5, correctReviews: 5),
      ];
      final dueCards = [makeCard(cardId: 'a')];

      when(
        () => mockDao.getAllReviewStates(),
      ).thenAnswer((_) async => Success(cards));
      when(
        () => mockDao.getDueCards(any()),
      ).thenAnswer((_) async => Success(dueCards));

      final result = await service.getReviewStats(now: now);

      switch (result) {
        case Success(:final data):
          expect(data.totalReviews, 15);
          expect(data.correctReviews, 13);
          expect(data.totalCards, 2);
          expect(data.dueCards, 1);
          expect(data.retentionRate, closeTo(13 / 15, 0.001));
        case Failure(:final message):
          fail('Expected success but got: $message');
      }
    });

    test('returns zero stats when no cards exist', () async {
      when(
        () => mockDao.getAllReviewStates(),
      ).thenAnswer((_) async => const Success([]));
      when(
        () => mockDao.getDueCards(any()),
      ).thenAnswer((_) async => const Success([]));

      final result = await service.getReviewStats(now: now);

      switch (result) {
        case Success(:final data):
          expect(data.totalReviews, 0);
          expect(data.correctReviews, 0);
          expect(data.totalCards, 0);
          expect(data.dueCards, 0);
          expect(data.retentionRate, 0.0);
        case Failure(:final message):
          fail('Expected success but got: $message');
      }
    });

    test('returns Failure when DAO fails', () async {
      when(
        () => mockDao.getAllReviewStates(),
      ).thenAnswer((_) async => const Failure('DB error'));

      final result = await service.getReviewStats(now: now);

      expect(result, isA<Failure<ReviewStats>>());
    });
  });

  group('getTotalCardsReviewed', () {
    test('sums total reviews across all cards', () async {
      final cards = [
        makeCard(cardId: 'a', totalReviews: 10),
        makeCard(cardId: 'b', totalReviews: 5),
        makeCard(cardId: 'c', totalReviews: 3),
      ];
      when(
        () => mockDao.getAllReviewStates(),
      ).thenAnswer((_) async => Success(cards));

      final total = await service.getTotalCardsReviewed();

      expect(total, 18);
    });

    test('returns 0 when DAO fails', () async {
      when(
        () => mockDao.getAllReviewStates(),
      ).thenAnswer((_) async => const Failure('DB error'));

      final total = await service.getTotalCardsReviewed();

      expect(total, 0);
    });
  });

  group('getRetentionRate', () {
    test('computes correct/total ratio', () async {
      final cards = [
        makeCard(cardId: 'a', totalReviews: 10, correctReviews: 8),
        makeCard(cardId: 'b', totalReviews: 10, correctReviews: 6),
      ];
      when(
        () => mockDao.getAllReviewStates(),
      ).thenAnswer((_) async => Success(cards));

      final rate = await service.getRetentionRate();

      expect(rate, closeTo(14 / 20, 0.001));
    });

    test('returns 0.0 when no reviews', () async {
      when(
        () => mockDao.getAllReviewStates(),
      ).thenAnswer((_) async => const Success([]));

      final rate = await service.getRetentionRate();

      expect(rate, 0.0);
    });

    test('returns 0.0 on DAO failure', () async {
      when(
        () => mockDao.getAllReviewStates(),
      ).thenAnswer((_) async => const Failure('DB error'));

      final rate = await service.getRetentionRate();

      expect(rate, 0.0);
    });
  });

  group('ReviewStats', () {
    test('retentionRate computes correctly', () {
      const stats = ReviewStats(
        totalReviews: 20,
        correctReviews: 15,
        totalCards: 10,
        dueCards: 3,
      );

      expect(stats.retentionRate, closeTo(0.75, 0.001));
    });

    test('retentionRate returns 0.0 when no reviews', () {
      const stats = ReviewStats(
        totalReviews: 0,
        correctReviews: 0,
        totalCards: 0,
        dueCards: 0,
      );

      expect(stats.retentionRate, 0.0);
    });

    test('equality works', () {
      const a = ReviewStats(
        totalReviews: 10,
        correctReviews: 8,
        totalCards: 5,
        dueCards: 2,
      );
      const b = ReviewStats(
        totalReviews: 10,
        correctReviews: 8,
        totalCards: 5,
        dueCards: 2,
      );

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('toString is descriptive', () {
      const stats = ReviewStats(
        totalReviews: 10,
        correctReviews: 8,
        totalCards: 5,
        dueCards: 2,
      );

      expect(stats.toString(), contains('10'));
      expect(stats.toString(), contains('80.0'));
    });
  });

  group('algorithm injection', () {
    test('uses custom algorithm when provided', () async {
      final customAlgorithm = _ConstantAlgorithm();
      final customService = ReviewService(
        dao: mockDao,
        algorithm: customAlgorithm,
      );

      final card = makeCard(
        cardId: 'card_1',
        totalReviews: 0,
        correctReviews: 0,
      );
      when(
        () => mockDao.getReviewState('card_1'),
      ).thenAnswer((_) async => Success(card));
      when(
        () => mockDao.saveReviewState(any()),
      ).thenAnswer((_) async => const Success(null));

      final result = await customService.reviewCard(
        cardId: 'card_1',
        quality: 5,
        now: now,
      );

      switch (result) {
        case Success(:final data):
          // Custom algorithm always returns interval=42
          expect(data.interval, 42);
          expect(data.easeFactor, 9.9);
        case Failure(:final message):
          fail('Expected success but got: $message');
      }
    });
  });
}

/// Constant-output algorithm for testing injection.
class _ConstantAlgorithm implements SrsAlgorithm {
  @override
  ReviewResult calculateNextReview({
    required int quality,
    required double easeFactor,
    required int interval,
    required int repetitions,
  }) {
    return const ReviewResult(
      easeFactor: 9.9,
      interval: 42,
      repetitions: 99,
      isCorrect: true,
    );
  }
}
