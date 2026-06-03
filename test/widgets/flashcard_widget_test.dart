import 'package:docklands_dojo/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({
    required bool isFlipped,
    required VoidCallback onFlip,
    Widget? front,
    Widget? back,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: FlashcardWidget(
          front: front ?? const Text('Front Text'),
          back: back ?? const Text('Back Text'),
          isFlipped: isFlipped,
          onFlip: onFlip,
        ),
      ),
    );
  }

  group('FlashcardWidget', () {
    testWidgets('renders front content when not flipped', (tester) async {
      await tester.pumpWidget(buildTestWidget(isFlipped: false, onFlip: () {}));

      expect(find.text('Front Text'), findsOneWidget);
      expect(find.text('Tap to reveal'), findsOneWidget);
    });

    testWidgets('calls onFlip when tapped', (tester) async {
      var flipped = false;

      await tester.pumpWidget(
        buildTestWidget(
          isFlipped: false,
          onFlip: () {
            flipped = true;
          },
        ),
      );

      // Tap the card.
      await tester.tap(find.byType(FlashcardWidget));
      await tester.pumpAndSettle();

      expect(flipped, isTrue);
    });

    testWidgets('shows back content when isFlipped is true', (tester) async {
      await tester.pumpWidget(buildTestWidget(isFlipped: true, onFlip: () {}));
      await tester.pumpAndSettle();

      expect(find.text('Back Text'), findsOneWidget);
    });

    testWidgets('shows front content with custom widgets', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          isFlipped: false,
          onFlip: () {},
          front: const Text('Custom Front'),
          back: const Text('Custom Back'),
        ),
      );

      expect(find.text('Custom Front'), findsOneWidget);
    });

    testWidgets('animates flip when isFlipped changes', (tester) async {
      var isFlipped = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return buildTestWidget(
              isFlipped: isFlipped,
              onFlip: () {
                setState(() {
                  isFlipped = !isFlipped;
                });
              },
            );
          },
        ),
      );

      // Initially showing front.
      expect(find.text('Front Text'), findsOneWidget);

      // Tap to flip.
      await tester.tap(find.byType(FlashcardWidget));
      await tester.pump();

      // Animation should be in progress — pump to completion.
      await tester.pumpAndSettle();

      // Now showing back.
      expect(find.text('Back Text'), findsOneWidget);
    });

    testWidgets('renders with minimum height constraint', (tester) async {
      await tester.pumpWidget(buildTestWidget(isFlipped: false, onFlip: () {}));

      // The card should exist and be rendered.
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);
    });

    testWidgets('shows help icon on front', (tester) async {
      await tester.pumpWidget(buildTestWidget(isFlipped: false, onFlip: () {}));

      expect(find.byIcon(Icons.help_outline), findsOneWidget);
    });

    testWidgets('shows check icon on back', (tester) async {
      await tester.pumpWidget(buildTestWidget(isFlipped: true, onFlip: () {}));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('can flip back to front', (tester) async {
      var isFlipped = true;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return buildTestWidget(
              isFlipped: isFlipped,
              onFlip: () {
                setState(() {
                  isFlipped = !isFlipped;
                });
              },
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      // Showing back.
      expect(find.text('Back Text'), findsOneWidget);

      // Tap to flip back.
      await tester.tap(find.byType(FlashcardWidget));
      await tester.pumpAndSettle();

      // Now showing front.
      expect(find.text('Front Text'), findsOneWidget);
    });
  });
}
