import 'package:docklands_dojo/models/technique.dart';
import 'package:docklands_dojo/screens/technique/technique_library_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget() {
    return const MaterialApp(home: TechniqueLibraryScreen());
  }

  group('TechniqueLibraryScreen', () {
    testWidgets('renders search bar', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search techniques...'), findsOneWidget);
    });

    testWidgets('renders technique and kata tabs', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Techniques'), findsOneWidget);
      expect(find.text('Kata'), findsOneWidget);
    });

    testWidgets('renders category filter chips', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // FilterChip widgets should be present (scrollable horizontally).
      expect(find.byType(FilterChip), findsWidgets);

      // First few categories should be visible without scrolling.
      expect(find.text('Stances'), findsOneWidget);
      expect(find.text('Punches'), findsOneWidget);
      expect(find.text('Kicks'), findsOneWidget);
    });

    testWidgets('renders technique cards in list', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Should render technique cards (at least a few visible).
      expect(find.byType(TechniqueCard), findsWidgets);
    });

    testWidgets('search filters techniques', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Enter search text.
      await tester.enterText(find.byType(TextField), 'mawashi');
      await tester.pumpAndSettle();

      // Should find mawashi geri techniques — list should be filtered.
      final cards = find.byType(TechniqueCard);
      expect(cards, findsWidgets);
    });

    testWidgets('clear button appears when search has text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Initially no clear button.
      expect(find.byIcon(Icons.clear), findsNothing);

      // Enter text.
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Clear button should appear.
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('clear button clears search', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Enter text.
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Tap clear.
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Search field should be empty.
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, isEmpty);
    });

    testWidgets('category chip toggles filter', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap "Kicks" filter chip.
      await tester.tap(find.text('Kicks'));
      await tester.pumpAndSettle();

      // All visible technique cards should be kicks.
      final cards = find.byType(TechniqueCard);
      for (var i = 0; i < tester.widgetList(cards).length; i++) {
        final card = tester.widget<TechniqueCard>(cards.at(i));
        expect(card.technique.category, equals(TechniqueCategory.geri));
      }
    });

    testWidgets('shows empty state for no results', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Enter nonsense query.
      await tester.enterText(find.byType(TextField), 'xyznonexistent123abc');
      await tester.pumpAndSettle();

      // Should show empty state.
      expect(find.text('No techniques found'), findsOneWidget);
      expect(find.text('Clear filters'), findsOneWidget);
    });

    testWidgets('empty state clear filters button works', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Enter nonsense query.
      await tester.enterText(find.byType(TextField), 'xyznonexistent123abc');
      await tester.pumpAndSettle();

      // Tap clear filters.
      await tester.tap(find.text('Clear filters'));
      await tester.pumpAndSettle();

      // Should show techniques again.
      expect(find.byType(TechniqueCard), findsWidgets);
    });

    testWidgets('tapping technique card navigates to detail', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Find first technique card and tap it.
      final firstCard = find.byType(TechniqueCard).first;
      await tester.tap(firstCard);
      await tester.pumpAndSettle();

      // Should navigate to detail screen.
      // The detail screen shows "Description" and "Key Points" sections.
      expect(find.text('Technique Library'), findsNothing);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Key Points'), findsOneWidget);
    });

    testWidgets('kata tab shows kata list', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap Kata tab.
      await tester.tap(find.text('Kata').last);
      await tester.pumpAndSettle();

      // Should show kata items.
      expect(find.text('Taikyoku Sono Ichi'), findsOneWidget);
    });
  });
}
