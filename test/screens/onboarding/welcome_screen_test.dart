import 'package:docklands_dojo/screens/onboarding/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WelcomeScreen', () {
    late bool getStartedCalled;

    setUp(() {
      getStartedCalled = false;
    });

    Widget buildSubject() {
      return MaterialApp(
        home: WelcomeScreen(onGetStarted: () => getStartedCalled = true),
      );
    }

    testWidgets('renders greeting title', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Osu! 🥋'), findsOneWidget);
    });

    testWidgets('renders app name', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Docklands Dojo'), findsOneWidget);
    });

    testWidgets('renders tagline', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(
        find.text('Your Kyokushin Karate training companion'),
        findsOneWidget,
      );
    });

    testWidgets('renders Get Started button', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('tapping Get Started triggers callback', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.tap(find.text('Get Started'));
      await tester.pump();

      expect(getStartedCalled, isTrue);
    });
  });
}
