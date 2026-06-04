import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/quiz.dart';
import 'package:docklands_dojo/screens/quiz/quiz_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuizResultScreen', () {
    QuizAttemptResult buildResult({
      double scorePercentage = 0.85,
      bool isMockExam = false,
      List<String> weakAreas = const [],
      Map<String, double> categoryScores = const {},
    }) {
      const total = 20;
      final correct = (total * scorePercentage).round();
      return QuizAttemptResult(
        timestamp: DateTime(2024, 1, 15),
        targetRank: BeltRank.kyu10,
        isMockExam: isMockExam,
        totalQuestions: total,
        correctAnswers: correct,
        duration: const Duration(minutes: 5, seconds: 30),
        categoryScores: categoryScores,
        weakAreas: weakAreas,
        questionResults: [],
      );
    }

    Widget buildSubject(QuizAttemptResult result) {
      return MaterialApp(home: QuizResultScreen(result: result));
    }

    testWidgets('displays score percentage', (tester) async {
      final result = buildResult(scorePercentage: 0.85);
      await tester.pumpWidget(buildSubject(result));
      await tester.pumpAndSettle();

      expect(find.text('85%'), findsOneWidget);
      expect(find.text('Quiz Results'), findsOneWidget);
    });

    testWidgets('shows pass badge for passing mock exam', (tester) async {
      final result = buildResult(scorePercentage: 0.90, isMockExam: true);
      await tester.pumpWidget(buildSubject(result));
      await tester.pumpAndSettle();

      expect(find.textContaining('PASSED'), findsOneWidget);
    });

    testWidgets('shows fail badge for failing mock exam', (tester) async {
      final result = buildResult(scorePercentage: 0.60, isMockExam: true);
      await tester.pumpWidget(buildSubject(result));
      await tester.pumpAndSettle();

      expect(find.textContaining('NOT YET'), findsOneWidget);
    });

    testWidgets('displays category breakdown', (tester) async {
      final result = buildResult(categoryScores: {'geri': 0.9, 'tsuki': 0.6});
      await tester.pumpWidget(buildSubject(result));
      await tester.pumpAndSettle();

      expect(find.text('Category Breakdown'), findsOneWidget);
      expect(find.text('Kicks'), findsOneWidget);
      expect(find.text('Punches'), findsOneWidget);
    });

    testWidgets('highlights weak areas', (tester) async {
      final result = buildResult(
        weakAreas: ['tsuki', 'kata'],
        categoryScores: {'tsuki': 0.5, 'kata': 0.6, 'geri': 0.9},
      );
      await tester.pumpWidget(buildSubject(result));
      await tester.pumpAndSettle();

      expect(find.text('Weak Areas'), findsOneWidget);
      expect(find.text('Punches'), findsWidgets);
      expect(find.text('Kata'), findsWidgets);
    });

    testWidgets('shows duration stats', (tester) async {
      final result = buildResult();
      await tester.pumpWidget(buildSubject(result));
      await tester.pumpAndSettle();

      expect(find.text('5m 30s'), findsOneWidget);
    });

    testWidgets('shows try again and done buttons', (tester) async {
      final result = buildResult();
      await tester.pumpWidget(buildSubject(result));
      await tester.pumpAndSettle();

      expect(find.text('Try Again'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('done button pops navigation', (tester) async {
      final result = buildResult();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => QuizResultScreen(result: result),
                      ),
                    );
                  },
                  child: const Text('Go'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.text('Quiz Results'), findsOneWidget);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.text('Quiz Results'), findsNothing);
    });

    testWidgets('no pass/fail badge in practice mode', (tester) async {
      final result = buildResult(isMockExam: false);
      await tester.pumpWidget(buildSubject(result));
      await tester.pumpAndSettle();

      expect(find.textContaining('PASSED'), findsNothing);
      expect(find.textContaining('NOT YET'), findsNothing);
    });
  });
}
