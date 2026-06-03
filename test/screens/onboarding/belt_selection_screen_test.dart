import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/screens/onboarding/belt_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BeltSelectionScreen', () {
    late BeltRank? selectedRank;

    setUp(() {
      selectedRank = null;
    });

    Widget buildSubject() {
      return MaterialApp(
        home: BeltSelectionScreen(
          onBeltSelected: (rank) => selectedRank = rank,
        ),
      );
    }

    testWidgets('renders header text', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text("What's your current belt?"), findsOneWidget);
    });

    testWidgets('renders all 11 belt options', (tester) async {
      await tester.pumpWidget(buildSubject());

      // The first option shows "I'm brand new" instead of display name.
      expect(find.text("I'm brand new"), findsOneWidget);

      // Scroll through and verify all Japanese names are present.
      for (final rank in BeltRank.values) {
        await tester.scrollUntilVisible(
          find.text(rank.japaneseName),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text(rank.japaneseName), findsOneWidget);
      }
    });

    testWidgets('renders IKO-1 disclaimer', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(
        find.text('Based on IKO-1 syllabus. Requirements may vary by dojo.'),
        findsOneWidget,
      );
    });

    testWidgets('Continue button disabled when no belt selected', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());

      // The button should exist but be disabled.
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('selecting a belt highlights it and enables Continue', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());

      // Tap the "I'm brand new" option (kyu10).
      await tester.tap(find.text("I'm brand new"));
      await tester.pump();

      // Check icon appears.
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Continue button should now be enabled.
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('tapping Continue fires callback with selected belt', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());

      // Select the first belt.
      await tester.tap(find.text("I'm brand new"));
      await tester.pump();

      // Tap Continue.
      await tester.tap(find.text('Continue'));
      await tester.pump();

      expect(selectedRank, BeltRank.kyu10);
    });

    testWidgets('can change selection', (tester) async {
      await tester.pumpWidget(buildSubject());

      // Select brand new.
      await tester.tap(find.text("I'm brand new"));
      await tester.pump();

      // Scroll to the Shodan row and tap its display name text.
      // Use the full display name to avoid ambiguity with the Japanese name.
      final shodanDisplayText = find.text('Shodan — Black Belt');
      await tester.scrollUntilVisible(
        shodanDisplayText,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(shodanDisplayText);
      await tester.pump();

      // Tap Continue.
      await tester.tap(find.text('Continue'));
      await tester.pump();

      expect(selectedRank, BeltRank.shodan);
    });
  });
}
