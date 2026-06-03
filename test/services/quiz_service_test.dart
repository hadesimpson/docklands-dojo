import 'dart:math';

import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/quiz.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/services/fuzzy_match_service.dart';
import 'package:docklands_dojo/services/quiz_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late QuizService quizService;

  setUp(() {
    quizService = QuizService(random: Random(42));
  });

  group('QuizService.generateQuiz', () {
    test('generates quiz for kyu10 with only white belt techniques', () {
      const config = QuizConfig(targetRank: BeltRank.kyu10, questionCount: 10);

      final result = quizService.generateQuiz(config);

      expect(result, isA<Success<List<QuizQuestion>>>());
      final questions = (result as Success<List<QuizQuestion>>).data;
      expect(questions, isNotEmpty);
      expect(questions.length, lessThanOrEqualTo(10));

      for (final q in questions) {
        expect(q.targetRank, BeltRank.kyu10);
      }
    });

    test('generates mock exam with correct question count for kyu10', () {
      const config = QuizConfig(targetRank: BeltRank.kyu10, isMockExam: true);

      final result = quizService.generateQuiz(config);

      expect(result, isA<Success<List<QuizQuestion>>>());
      final questions = (result as Success<List<QuizQuestion>>).data;
      expect(questions.length, lessThanOrEqualTo(20));
      expect(questions, isNotEmpty);
    });

    test('mock exam question counts follow PRD table', () {
      expect(
        const QuizConfig(
          targetRank: BeltRank.kyu10,
          isMockExam: true,
        ).effectiveQuestionCount,
        20,
      );
      expect(
        const QuizConfig(
          targetRank: BeltRank.kyu9,
          isMockExam: true,
        ).effectiveQuestionCount,
        25,
      );
      expect(
        const QuizConfig(
          targetRank: BeltRank.kyu8,
          isMockExam: true,
        ).effectiveQuestionCount,
        25,
      );
      expect(
        const QuizConfig(
          targetRank: BeltRank.kyu7,
          isMockExam: true,
        ).effectiveQuestionCount,
        30,
      );
      expect(
        const QuizConfig(
          targetRank: BeltRank.kyu5,
          isMockExam: true,
        ).effectiveQuestionCount,
        35,
      );
      expect(
        const QuizConfig(
          targetRank: BeltRank.kyu3,
          isMockExam: true,
        ).effectiveQuestionCount,
        40,
      );
      expect(
        const QuizConfig(
          targetRank: BeltRank.kyu1,
          isMockExam: true,
        ).effectiveQuestionCount,
        50,
      );
      expect(
        const QuizConfig(
          targetRank: BeltRank.shodan,
          isMockExam: true,
        ).effectiveQuestionCount,
        60,
      );
    });

    test('no duplicate questions in a single quiz', () {
      const config = QuizConfig(targetRank: BeltRank.kyu7, questionCount: 30);

      final result = quizService.generateQuiz(config);

      expect(result, isA<Success<List<QuizQuestion>>>());
      final questions = (result as Success<List<QuizQuestion>>).data;

      final ids = questions.map((q) => q.id).toSet();
      expect(
        ids.length,
        questions.length,
        reason: 'All question IDs should be unique',
      );

      final texts = questions.map((q) => q.questionText).toSet();
      expect(
        texts.length,
        questions.length,
        reason: 'All question texts should be unique',
      );
    });

    test('generates questions of multiple types', () {
      const config = QuizConfig(targetRank: BeltRank.kyu9, questionCount: 20);

      final result = quizService.generateQuiz(config);

      expect(result, isA<Success<List<QuizQuestion>>>());
      final questions = (result as Success<List<QuizQuestion>>).data;

      final types = questions.map((q) => q.type).toSet();
      expect(types, contains(QuestionType.multipleChoice));
      expect(types, contains(QuestionType.fillInBlank));
    });

    test('multiple choice questions have exactly 4 options', () {
      const config = QuizConfig(targetRank: BeltRank.kyu9, questionCount: 20);

      final result = quizService.generateQuiz(config);

      expect(result, isA<Success<List<QuizQuestion>>>());
      final questions = (result as Success<List<QuizQuestion>>).data;

      for (final q in questions.where(
        (q) => q.type == QuestionType.multipleChoice,
      )) {
        expect(
          q.options.length,
          4,
          reason: 'MC question "${q.questionText}" should have 4 options',
        );
        expect(
          q.options,
          contains(q.correctAnswer),
          reason: 'Options should contain the correct answer',
        );
      }
    });

    test('filters questions by categories', () {
      const config = QuizConfig(
        targetRank: BeltRank.kyu10,
        questionCount: 20,
        categories: ['geri'],
      );

      final result = quizService.generateQuiz(config);

      expect(result, isA<Success<List<QuizQuestion>>>());
      final questions = (result as Success<List<QuizQuestion>>).data;

      for (final q in questions) {
        expect(
          q.category,
          'geri',
          reason: 'Filtered quiz should only contain geri questions',
        );
      }
    });
  });

  group('QuizService.scoreQuiz', () {
    test('scores perfect quiz at 100%', () {
      const config = QuizConfig(targetRank: BeltRank.kyu10, questionCount: 5);

      final result = quizService.generateQuiz(config);
      final questions = (result as Success<List<QuizQuestion>>).data;

      final answers = <String, String>{};
      for (final q in questions) {
        answers[q.id] = q.correctAnswer;
      }

      final quizResult = quizService.scoreQuiz(
        questions: questions,
        answers: answers,
        duration: const Duration(minutes: 5),
      );

      expect(quizResult.correctAnswers, questions.length);
      expect(quizResult.scorePercentage, 1.0);
      expect(quizResult.weakAreas, isEmpty);
      expect(quizResult.questionResults.length, questions.length);
      for (final qr in quizResult.questionResults) {
        expect(qr.isCorrect, true);
      }
    });

    test('scores partial quiz with correct percentage', () {
      final questions = [
        const QuizQuestion(
          id: 'q1',
          type: QuestionType.multipleChoice,
          questionText: 'Q1',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'A',
          explanation: 'E1',
          targetRank: BeltRank.kyu10,
          category: 'tsuki',
        ),
        const QuizQuestion(
          id: 'q2',
          type: QuestionType.multipleChoice,
          questionText: 'Q2',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'B',
          explanation: 'E2',
          targetRank: BeltRank.kyu10,
          category: 'geri',
        ),
        const QuizQuestion(
          id: 'q3',
          type: QuestionType.multipleChoice,
          questionText: 'Q3',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'C',
          explanation: 'E3',
          targetRank: BeltRank.kyu10,
          category: 'tsuki',
        ),
        const QuizQuestion(
          id: 'q4',
          type: QuestionType.multipleChoice,
          questionText: 'Q4',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'D',
          explanation: 'E4',
          targetRank: BeltRank.kyu10,
          category: 'geri',
        ),
      ];

      final answers = {'q1': 'A', 'q2': 'A', 'q3': 'C', 'q4': 'A'};

      final quizResult = quizService.scoreQuiz(
        questions: questions,
        answers: answers,
        duration: const Duration(minutes: 3),
      );

      expect(quizResult.totalQuestions, 4);
      expect(quizResult.correctAnswers, 2);
      expect(quizResult.scorePercentage, 0.5);
    });

    test('calculates category breakdown correctly', () {
      final questions = [
        const QuizQuestion(
          id: 'q1',
          type: QuestionType.multipleChoice,
          questionText: 'Q1',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'A',
          explanation: 'E1',
          targetRank: BeltRank.kyu10,
          category: 'tsuki',
        ),
        const QuizQuestion(
          id: 'q2',
          type: QuestionType.multipleChoice,
          questionText: 'Q2',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'B',
          explanation: 'E2',
          targetRank: BeltRank.kyu10,
          category: 'geri',
        ),
        const QuizQuestion(
          id: 'q3',
          type: QuestionType.multipleChoice,
          questionText: 'Q3',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'C',
          explanation: 'E3',
          targetRank: BeltRank.kyu10,
          category: 'tsuki',
        ),
      ];

      final answers = {'q1': 'A', 'q2': 'B', 'q3': 'A'};

      final quizResult = quizService.scoreQuiz(
        questions: questions,
        answers: answers,
        duration: const Duration(minutes: 2),
      );

      expect(quizResult.categoryScores['tsuki'], 0.5);
      expect(quizResult.categoryScores['geri'], 1.0);
      expect(quizResult.weakAreas, contains('tsuki'));
      expect(quizResult.weakAreas, isNot(contains('geri')));
    });

    test('fill-in-blank fuzzy matching accepts exact answer', () {
      final questions = [
        const QuizQuestion(
          id: 'q1',
          type: QuestionType.fillInBlank,
          questionText: 'Mawashi geri chudan means ___',
          options: [],
          correctAnswer: 'Roundhouse kick (middle level)',
          explanation: 'Explanation',
          targetRank: BeltRank.kyu10,
          category: 'geri',
        ),
      ];

      final exactResult = quizService.scoreQuiz(
        questions: questions,
        answers: {'q1': 'Roundhouse kick (middle level)'},
        duration: const Duration(minutes: 1),
      );
      expect(exactResult.correctAnswers, 1);
    });

    test('fill-in-blank fuzzy matching uses 4-layer matching', () {
      final fuzzyService = FuzzyMatchService();

      expect(fuzzyService.isMatch('chudan', 'chūdan').isMatch, true);

      expect(fuzzyService.isMatch('mawasi geri', 'mawashi geri').isMatch, true);

      expect(fuzzyService.isMatch('tuki', 'tsuki').isMatch, true);

      expect(
        fuzzyService.isMatch('mawashi gri', 'mawashi geri').isMatch,
        true,
        reason: 'Single character omission should still match',
      );

      expect(
        fuzzyService.isMatch('completely wrong', 'mawashi geri').isMatch,
        false,
      );
    });

    test('true/false questions score correctly', () {
      final questions = [
        const QuizQuestion(
          id: 'q1',
          type: QuestionType.trueFalse,
          questionText: 'Mawashi geri is a roundhouse kick.',
          options: ['True', 'False'],
          correctAnswer: 'True',
          explanation: 'Correct!',
          targetRank: BeltRank.kyu10,
          category: 'geri',
        ),
        const QuizQuestion(
          id: 'q2',
          type: QuestionType.trueFalse,
          questionText: 'Mae geri is a side kick.',
          options: ['True', 'False'],
          correctAnswer: 'False',
          explanation: 'Mae geri is a front kick.',
          targetRank: BeltRank.kyu10,
          category: 'geri',
        ),
      ];

      final result = quizService.scoreQuiz(
        questions: questions,
        answers: {'q1': 'True', 'q2': 'False'},
        duration: const Duration(minutes: 1),
      );

      expect(result.correctAnswers, 2);
      expect(result.scorePercentage, 1.0);
    });

    test('mock exam pass/fail at 80% threshold', () {
      final questions = List.generate(
        10,
        (i) => QuizQuestion(
          id: 'q_$i',
          type: QuestionType.multipleChoice,
          questionText: 'Q$i',
          options: const ['A', 'B', 'C', 'D'],
          correctAnswer: 'A',
          explanation: 'E',
          targetRank: BeltRank.kyu10,
          category: 'tsuki',
        ),
      );

      final passAnswers = <String, String>{};
      for (var i = 0; i < 10; i++) {
        passAnswers['q_$i'] = i < 8 ? 'A' : 'B';
      }
      final passResult = quizService.scoreQuiz(
        questions: questions,
        answers: passAnswers,
        duration: const Duration(minutes: 5),
        isMockExam: true,
      );
      expect(passResult.passed, true);
      expect(passResult.isMockExam, true);

      final failAnswers = <String, String>{};
      for (var i = 0; i < 10; i++) {
        failAnswers['q_$i'] = i < 7 ? 'A' : 'B';
      }
      final failResult = quizService.scoreQuiz(
        questions: questions,
        answers: failAnswers,
        duration: const Duration(minutes: 5),
        isMockExam: true,
      );
      expect(failResult.passed, false);
    });

    test('unanswered questions are scored as incorrect', () {
      final questions = [
        const QuizQuestion(
          id: 'q1',
          type: QuestionType.multipleChoice,
          questionText: 'Q1',
          options: ['A', 'B', 'C', 'D'],
          correctAnswer: 'A',
          explanation: 'E1',
          targetRank: BeltRank.kyu10,
          category: 'tsuki',
        ),
      ];

      final result = quizService.scoreQuiz(
        questions: questions,
        answers: {},
        duration: const Duration(minutes: 1),
      );

      expect(result.correctAnswers, 0);
      expect(result.scorePercentage, 0.0);
    });
  });

  group('QuizConfig', () {
    test('effectiveQuestionCount returns questionCount for non-mock', () {
      const config = QuizConfig(targetRank: BeltRank.kyu10, questionCount: 15);
      expect(config.effectiveQuestionCount, 15);
    });

    test('effectiveQuestionCount returns mock count for mock exam', () {
      const config = QuizConfig(
        targetRank: BeltRank.kyu10,
        isMockExam: true,
        questionCount: 15,
      );
      expect(config.effectiveQuestionCount, 20);
    });
  });

  group('QuizAttemptResult', () {
    test('scorePercentage handles zero questions', () {
      final result = QuizAttemptResult(
        timestamp: DateTime(2024),
        targetRank: BeltRank.kyu10,
        isMockExam: false,
        totalQuestions: 0,
        correctAnswers: 0,
        duration: Duration.zero,
        categoryScores: const {},
        weakAreas: const [],
        questionResults: const [],
      );
      expect(result.scorePercentage, 0.0);
    });
  });

  group('FuzzyMatchService', () {
    late FuzzyMatchService fuzzyService;

    setUp(() {
      fuzzyService = FuzzyMatchService();
    });

    test('normalize strips macrons', () {
      expect(fuzzyService.normalize('chūdan'), 'chudan');
      expect(fuzzyService.normalize('jōdan'), 'jodan');
    });

    test('normalize strips hyphens and collapses whitespace', () {
      expect(fuzzyService.normalize('mae-geri'), 'mae geri');
      expect(fuzzyService.normalize('mae  geri'), 'mae geri');
    });

    test('romanization mapping converts Kunrei to Hepburn', () {
      expect(fuzzyService.applyRomanizationMapping('si'), 'shi');
      expect(fuzzyService.applyRomanizationMapping('ti'), 'chi');
      expect(fuzzyService.applyRomanizationMapping('tu'), 'tsu');
      expect(fuzzyService.applyRomanizationMapping('hu'), 'fu');
    });

    test('levenshteinDistance calculates correctly', () {
      expect(fuzzyService.levenshteinDistance('kitten', 'sitting'), 3);
      expect(fuzzyService.levenshteinDistance('', 'abc'), 3);
      expect(fuzzyService.levenshteinDistance('abc', 'abc'), 0);
    });

    test('similarity returns 1.0 for identical strings', () {
      expect(fuzzyService.similarity('mawashi', 'mawashi'), 1.0);
    });

    test('isMatch with exact match after normalization', () {
      final result = fuzzyService.isMatch('Mawashi Geri', 'mawashi geri');
      expect(result.isMatch, true);
      expect(result.wasExactMatch, true);
    });

    test('isMatch with romanization mapping', () {
      final result = fuzzyService.isMatch('mawasi geri', 'mawashi geri');
      expect(result.isMatch, true);
    });

    test('isMatch rejects completely different strings', () {
      final result = fuzzyService.isMatch('karate', 'mawashi geri');
      expect(result.isMatch, false);
    });
  });
}
