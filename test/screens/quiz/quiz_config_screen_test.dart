import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/quiz.dart';
import 'package:docklands_dojo/screens/quiz/quiz_config_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuizConfigScreen', () {
    late QuizConfig? capturedConfig;

    Widget buildSubject({BeltRank? initialBeltRank}) {
      capturedConfig = null;
      return MaterialApp(
        home: QuizConfigScreen(
          onStartQuiz: (config) => capturedConfig = config,
          initialBeltRank: initialBeltRank,
        ),
      );
    }

    testWidgets('renders all configuration sections', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Quiz Setup'), findsOneWidget);
      expect(find.text('Target Belt'), findsOneWidget);
      expect(find.text('Mock Exam Mode'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('shows question count slider in practice mode', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Questions'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('hides question count slider in mock exam mode', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Toggle mock exam mode on.
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsNothing);
    });

    testWidgets('starts quiz with default config', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Scroll to bottom to find Start Quiz button.
      await tester.scrollUntilVisible(
        find.text('Start Quiz'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Quiz'));
      await tester.pumpAndSettle();

      expect(capturedConfig, isNotNull);
      expect(capturedConfig!.targetRank, BeltRank.kyu10);
      expect(capturedConfig!.isMockExam, false);
      expect(capturedConfig!.questionCount, 20);
      expect(capturedConfig!.categories, isEmpty);
    });

    testWidgets('starts mock exam with correct config', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Toggle mock exam.
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Scroll to the start button.
      await tester.scrollUntilVisible(
        find.text('Start Mock Exam'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Mock Exam'));
      await tester.pumpAndSettle();

      expect(capturedConfig, isNotNull);
      expect(capturedConfig!.isMockExam, true);
    });

    testWidgets('pre-selects initial belt rank', (tester) async {
      await tester.pumpWidget(buildSubject(initialBeltRank: BeltRank.kyu7));
      await tester.pumpAndSettle();

      // The dropdown should show the initial rank.
      expect(find.text('7th Kyu — Blue'), findsOneWidget);
    });

    testWidgets('category filter chips are rendered', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Scroll to see categories.
      await tester.scrollUntilVisible(
        find.text('Stances (Dachi)'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.byType(FilterChip), findsWidgets);
      expect(find.text('Stances (Dachi)'), findsOneWidget);
      expect(find.text('Kicks (Geri)'), findsOneWidget);
    });

    testWidgets('selecting a category includes it in config', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Scroll to "Kicks (Geri)" chip.
      await tester.scrollUntilVisible(
        find.text('Kicks (Geri)'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kicks (Geri)'));
      await tester.pumpAndSettle();

      // Scroll to start button.
      await tester.scrollUntilVisible(
        find.text('Start Quiz'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Quiz'));
      await tester.pumpAndSettle();

      expect(capturedConfig, isNotNull);
      expect(capturedConfig!.categories, contains('geri'));
    });
  });
}
