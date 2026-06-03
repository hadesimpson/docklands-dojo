import 'package:docklands_dojo/data/flashcards_data.dart';
import 'package:docklands_dojo/database/daos/review_dao.dart';
import 'package:docklands_dojo/providers/review_providers.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/screens/review/flashcard_screen.dart';
import 'package:docklands_dojo/services/srs/review_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewService extends Mock implements ReviewService {}

class MockReviewDao extends Mock implements ReviewDao {}

void main() {
  late MockReviewService mockService;
  late MockReviewDao mockDao;

  setUp(() {
    mockService = MockReviewService();
    mockDao = MockReviewDao();
  });

  Widget buildTestWidget({List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: [
        reviewServiceProvider.overrideWithValue(mockService),
        reviewDaoProvider.overrideWithValue(mockDao),
        ...overrides,
      ],
      child: const MaterialApp(home: FlashcardScreen()),
    );
  }

  CardReviewState createDueCard(String cardId) {
    return CardReviewState(
      cardId: cardId,
      easeFactor: 2.5,
      interval: 0,
      repetitions: 0,
      nextReviewDate: DateTime.now().subtract(const Duration(hours: 1)),
      lastReviewDate: DateTime.now().subtract(const Duration(days: 1)),
      totalReviews: 0,
      correctReviews: 0,
    );
  }

  group('FlashcardScreen', () {
    testWidgets('shows empty review screen when no cards due',
        (tester) async {
      when(() => mockService.getDueCards(any()))
          .thenAnswer((_) async => const Success([]));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('All caught up!'), findsOneWidget);
      expect(find.text('🎉'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      when(() => mockService.getDueCards(any())).thenAnswer(
        (_) => Future.delayed(
          const Duration(seconds: 1),
          () => const Success([]),
        ),
      );

      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error state on failure', (tester) async {
      when(() => mockService.getDueCards(any()))
          .thenAnswer((_) async => const Failure('Database error'));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Database error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows card front when cards are due', (tester) async {
      // Use the first flashcard ID so the screen can find it.
      final firstCard = allFlashCards.first;
      final dueCard = createDueCard(firstCard.id);

      when(() => mockService.getDueCards(any()))
          .thenAnswer((_) async => Success([dueCard]));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should show the card front text.
      expect(find.text(firstCard.front), findsOneWidget);
      expect(find.text('Tap the card to reveal the answer'), findsOneWidget);
    });

    testWidgets('shows progress bar and card counter', (tester) async {
      final cards = [
        createDueCard(allFlashCards[0].id),
        createDueCard(allFlashCards[1].id),
      ];

      when(() => mockService.getDueCards(any()))
          .thenAnswer((_) async => Success(cards));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Card counter in app bar.
      expect(find.text('Review (1/2)'), findsOneWidget);

      // Progress bar.
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows quality buttons after flipping card', (tester) async {
      final firstCard = allFlashCards.first;
      final dueCard = createDueCard(firstCard.id);

      when(() => mockService.getDueCards(any()))
          .thenAnswer((_) async => Success([dueCard]));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Quality buttons should not be visible before flip.
      expect(find.text('How well did you know this?'), findsNothing);

      // Tap the card to flip.
      await tester.tap(find.text(firstCard.front));
      await tester.pumpAndSettle();

      // Quality buttons should now be visible.
      expect(find.text('How well did you know this?'), findsOneWidget);
      expect(find.text('Blackout'), findsOneWidget);
      expect(find.text('Easy'), findsOneWidget);
    });

    testWidgets('rating card advances to next card', (tester) async {
      final cards = [
        createDueCard(allFlashCards[0].id),
        createDueCard(allFlashCards[1].id),
      ];

      when(() => mockService.getDueCards(any()))
          .thenAnswer((_) async => Success(cards));
      when(
        () => mockService.reviewCard(
          cardId: any(named: 'cardId'),
          quality: any(named: 'quality'),
          now: any(named: 'now'),
        ),
      ).thenAnswer(
        (_) async => Success(cards[0]),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should show first card.
      expect(find.text('Review (1/2)'), findsOneWidget);

      // Flip the card.
      await tester.tap(find.text(allFlashCards[0].front));
      await tester.pumpAndSettle();

      // Rate with quality 5.
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      // Should advance to second card.
      expect(find.text('Review (2/2)'), findsOneWidget);
    });
  });

  group('ReviewSummaryScreen', () {
    testWidgets('shows session statistics', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewSummaryScreen(
            cardsReviewed: 10,
            correctCount: 8,
            duration: Duration(minutes: 3, seconds: 45),
          ),
        ),
      );

      expect(find.text('Session Complete'), findsOneWidget);
      expect(find.text('10'), findsOneWidget); // cards reviewed
      expect(find.text('8 / 10'), findsOneWidget); // correct
      expect(find.text('80%'), findsOneWidget); // retention
      expect(find.text('3m 45s'), findsOneWidget); // duration
    });

    testWidgets('shows celebration for high retention', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewSummaryScreen(
            cardsReviewed: 10,
            correctCount: 9,
            duration: Duration(minutes: 2),
          ),
        ),
      );

      expect(find.text('Excellent work! 🔥'), findsOneWidget);
      expect(find.byIcon(Icons.celebration), findsOneWidget);
    });

    testWidgets('shows encouragement for low retention', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewSummaryScreen(
            cardsReviewed: 10,
            correctCount: 3,
            duration: Duration(minutes: 5),
          ),
        ),
      );

      expect(find.text('Keep training! 🥋'), findsOneWidget);
      expect(find.byIcon(Icons.school), findsOneWidget);
    });

    testWidgets('done button pops navigation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ReviewSummaryScreen(
                      cardsReviewed: 5,
                      correctCount: 4,
                      duration: Duration(minutes: 1),
                    ),
                  ),
                );
              },
              child: const Text('Open Summary'),
            ),
          ),
        ),
      );

      // Navigate to summary.
      await tester.tap(find.text('Open Summary'));
      await tester.pumpAndSettle();
      expect(find.text('Session Complete'), findsOneWidget);

      // Tap done.
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.text('Session Complete'), findsNothing);
    });
  });

  group('EmptyReviewScreen', () {
    testWidgets('renders celebration and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: EmptyReviewScreen()),
      );

      expect(find.text('🎉'), findsOneWidget);
      expect(find.text('All caught up!'), findsOneWidget);
      expect(
        find.text(
          'No cards are due for review right now.\n'
          'Come back later to keep your streak going!',
        ),
        findsOneWidget,
      );
    });

    testWidgets('go back button pops navigation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const EmptyReviewScreen(),
                  ),
                );
              },
              child: const Text('Open Empty'),
            ),
          ),
        ),
      );

      // Navigate to empty screen.
      await tester.tap(find.text('Open Empty'));
      await tester.pumpAndSettle();
      expect(find.text('All caught up!'), findsOneWidget);

      // Tap go back.
      await tester.tap(find.text('Go Back'));
      await tester.pumpAndSettle();
      expect(find.text('All caught up!'), findsNothing);
    });
  });
}
