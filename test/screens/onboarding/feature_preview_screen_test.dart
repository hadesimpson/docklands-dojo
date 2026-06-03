import 'package:docklands_dojo/screens/onboarding/feature_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeaturePreviewScreen', () {
    late bool finishCalled;

    setUp(() {
      finishCalled = false;
    });

    Widget buildSubject() {
      return MaterialApp(
        home: FeaturePreviewScreen(onFinish: () => finishCalled = true),
      );
    }

    testWidgets('renders section header', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('What you can do'), findsOneWidget);
    });

    testWidgets('renders Belt Progression feature', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Belt Progression'), findsOneWidget);
      expect(
        find.text('Track your journey from white to black belt'),
        findsOneWidget,
      );
    });

    testWidgets('renders Spaced Repetition feature', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Spaced Repetition'), findsOneWidget);
      expect(
        find.text('Master Japanese terminology with smart flashcards'),
        findsOneWidget,
      );
    });

    testWidgets('renders Grading Prep feature', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Grading Prep'), findsOneWidget);
      expect(
        find.text('Test yourself before your next grading'),
        findsOneWidget,
      );
    });

    testWidgets('renders all 3 feature emojis', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('🥋'), findsOneWidget);
      expect(find.text('🧠'), findsOneWidget);
      expect(find.text('📝'), findsOneWidget);
    });

    testWidgets('renders Let\'s Go! button', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text("Let's Go!"), findsOneWidget);
    });

    testWidgets('tapping Let\'s Go! triggers callback', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.tap(find.text("Let's Go!"));
      await tester.pump();

      expect(finishCalled, isTrue);
    });
  });
}
