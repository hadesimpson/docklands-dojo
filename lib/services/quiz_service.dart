import 'dart:math';

import 'package:docklands_dojo/data/kata_data.dart';
import 'package:docklands_dojo/data/syllabus_data.dart';
import 'package:docklands_dojo/data/techniques_data.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/quiz.dart';
import 'package:docklands_dojo/models/technique.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/services/fuzzy_match_service.dart';

/// Service for generating and scoring grading preparation quizzes.
///
/// Generates quiz questions scoped to a target belt rank, drawing
/// from the technique pool required for that rank and all preceding
/// ranks. Supports multiple question types:
///
/// - Multiple choice: "What is the English name for [Japanese]?"
/// - Fill-in-blank: "[Japanese term] means ___" (with fuzzy matching)
/// - True/false: factual statements about techniques
/// - Match pairs: Japanese ↔ English term matching
///
/// Mock exam mode uses a fixed question count per belt rank
/// (see [QuizConfig.mockExamQuestionCount]) and requires ≥ 80% to pass.
///
/// ```dart
/// final service = QuizService();
/// final result = service.generateQuiz(
///   QuizConfig(targetRank: BeltRank.kyu10),
/// );
/// ```
class QuizService {
  /// Fuzzy match service for fill-in-blank answer scoring.
  final FuzzyMatchService _fuzzyMatchService;

  /// Random number generator for question shuffling.
  final Random _random;

  /// Creates a [QuizService] with optional dependency injection.
  QuizService({FuzzyMatchService? fuzzyMatchService, Random? random})
    : _fuzzyMatchService = fuzzyMatchService ?? FuzzyMatchService(),
      _random = random ?? Random();

  /// Generates a quiz based on the given [config].
  ///
  /// Returns [Success] with a list of [QuizQuestion]s, or [Failure]
  /// if there are insufficient techniques for the target rank.
  ///
  /// Questions are randomized and deduplicated. The effective question
  /// count respects mock exam overrides.
  Result<List<QuizQuestion>> generateQuiz(QuizConfig config) {
    try {
      final techniques = _getTechniquesForRank(config.targetRank);

      if (techniques.isEmpty) {
        return const Failure('No techniques found for the target belt rank');
      }

      final effectiveCount = config.effectiveQuestionCount;

      // Generate a pool of candidate questions.
      final candidateQuestions = <QuizQuestion>[];

      // Generate questions from techniques.
      for (final technique in techniques) {
        // Filter by categories if specified.
        if (config.categories.isNotEmpty &&
            !config.categories.contains(technique.category.name)) {
          continue;
        }
        candidateQuestions.addAll(
          _generateQuestionsForTechnique(technique, config.targetRank),
        );
      }

      // Generate kata-related questions.
      final kataQuestions = _generateKataQuestions(config.targetRank);
      if (config.categories.isEmpty || config.categories.contains('kata')) {
        candidateQuestions.addAll(kataQuestions);
      }

      if (candidateQuestions.isEmpty) {
        return const Failure(
          'No questions could be generated for the specified categories',
        );
      }

      // Shuffle and deduplicate.
      candidateQuestions.shuffle(_random);

      // Remove duplicates by question text.
      final seen = <String>{};
      final uniqueQuestions = <QuizQuestion>[];
      for (final q in candidateQuestions) {
        if (seen.add(q.questionText)) {
          uniqueQuestions.add(q);
        }
      }

      // Take the requested number of questions.
      final count = min(effectiveCount, uniqueQuestions.length);
      final selectedQuestions = uniqueQuestions.take(count).toList();

      // Re-assign sequential IDs.
      final finalQuestions = <QuizQuestion>[];
      for (var i = 0; i < selectedQuestions.length; i++) {
        final q = selectedQuestions[i];
        finalQuestions.add(
          QuizQuestion(
            id: 'q_${i + 1}',
            type: q.type,
            questionText: q.questionText,
            options: q.options,
            correctAnswer: q.correctAnswer,
            explanation: q.explanation,
            targetRank: q.targetRank,
            category: q.category,
          ),
        );
      }

      return Success(finalQuestions);
    } catch (e) {
      return Failure('Failed to generate quiz', e);
    }
  }

  /// Scores a completed quiz, comparing user [answers] to [questions].
  ///
  /// Uses fuzzy matching for fill-in-blank questions. Returns a
  /// [QuizAttemptResult] with per-question results, category breakdown,
  /// and weak area identification.
  QuizAttemptResult scoreQuiz({
    required List<QuizQuestion> questions,
    required Map<String, String> answers,
    required Duration duration,
    bool isMockExam = false,
  }) {
    final questionResults = <QuestionResult>[];
    final categoryCorrect = <String, int>{};
    final categoryTotal = <String, int>{};

    for (final question in questions) {
      final userAnswer = answers[question.id] ?? '';
      final isCorrect = _checkAnswer(question, userAnswer);

      questionResults.add(
        QuestionResult(
          question: question,
          userAnswer: userAnswer,
          isCorrect: isCorrect,
        ),
      );

      // Track per-category scores.
      categoryTotal[question.category] =
          (categoryTotal[question.category] ?? 0) + 1;
      if (isCorrect) {
        categoryCorrect[question.category] =
            (categoryCorrect[question.category] ?? 0) + 1;
      }
    }

    // Calculate category percentages.
    final categoryScores = <String, double>{};
    for (final category in categoryTotal.keys) {
      categoryScores[category] =
          (categoryCorrect[category] ?? 0) / categoryTotal[category]!;
    }

    // Identify weak areas (< 80%).
    final weakAreas =
        categoryScores.entries
            .where((e) => e.value < 0.8)
            .map((e) => e.key)
            .toList()
          ..sort();

    final correctCount = questionResults.where((r) => r.isCorrect).length;

    return QuizAttemptResult(
      timestamp: DateTime.now(),
      targetRank: questions.isNotEmpty
          ? questions.first.targetRank
          : BeltRank.kyu10,
      isMockExam: isMockExam,
      totalQuestions: questions.length,
      correctAnswers: correctCount,
      duration: duration,
      categoryScores: categoryScores,
      weakAreas: weakAreas,
      questionResults: questionResults,
    );
  }

  /// Gets all techniques required for [targetRank] and all lower ranks.
  ///
  /// This implements cumulative belt requirements: a student grading
  /// for 9th Kyu must also know all 10th Kyu techniques.
  List<Technique> _getTechniquesForRank(BeltRank targetRank) {
    final targetOrder = targetRank.order;
    return allTechniques
        .where(
          (t) => t.requiredForBelts.any((belt) => belt.order <= targetOrder),
        )
        .toList();
  }

  /// Generates multiple question types for a single [technique].
  List<QuizQuestion> _generateQuestionsForTechnique(
    Technique technique,
    BeltRank targetRank,
  ) {
    final questions = <QuizQuestion>[];
    final categoryName = technique.category.name;

    // Type A: "What is the English name for [Japanese]?" (MC)
    final wrongAnswers = _getDistractors(technique, 3);
    if (wrongAnswers.length >= 3) {
      final options = [technique.englishName, ...wrongAnswers]
        ..shuffle(_random);
      questions.add(
        QuizQuestion(
          id: 'gen_mc_en_${technique.id}',
          type: QuestionType.multipleChoice,
          questionText: 'What is the English name for ${technique.romajiName}?',
          options: options,
          correctAnswer: technique.englishName,
          explanation:
              '${technique.romajiName} is the Japanese term for '
              '${technique.englishName.toLowerCase()}.',
          targetRank: targetRank,
          category: categoryName,
        ),
      );
    }

    // Type B: "Which technique is [description]?" (MC)
    if (wrongAnswers.length >= 3) {
      final wrongRomaji = allTechniques
          .where(
            (t) => t.category == technique.category && t.id != technique.id,
          )
          .take(3)
          .map((t) => t.romajiName)
          .toList();
      if (wrongRomaji.length >= 3) {
        final options = [technique.romajiName, ...wrongRomaji]
          ..shuffle(_random);
        questions.add(
          QuizQuestion(
            id: 'gen_mc_desc_${technique.id}',
            type: QuestionType.multipleChoice,
            questionText:
                'Which ${_categoryDisplayName(technique.category)} is '
                'described as: "${technique.englishName}"?',
            options: options,
            correctAnswer: technique.romajiName,
            explanation:
                '${technique.englishName} is the English translation of '
                '${technique.romajiName}.',
            targetRank: targetRank,
            category: categoryName,
          ),
        );
      }
    }

    // Type C: "[Japanese term] means ___" (fill in blank)
    questions.add(
      QuizQuestion(
        id: 'gen_fib_${technique.id}',
        type: QuestionType.fillInBlank,
        questionText: '${technique.romajiName} means ___',
        options: const [],
        correctAnswer: technique.englishName,
        explanation:
            '${technique.romajiName} translates to '
            '"${technique.englishName}".',
        targetRank: targetRank,
        category: categoryName,
      ),
    );

    // Type D: True/False statement
    final trueFalseQuestion = _generateTrueFalse(technique, targetRank);
    if (trueFalseQuestion != null) {
      questions.add(trueFalseQuestion);
    }

    return questions;
  }

  /// Generates a true/false question for a technique.
  ///
  /// Creates either a true statement about the technique or a false
  /// statement by pairing it with the wrong English name.
  QuizQuestion? _generateTrueFalse(Technique technique, BeltRank targetRank) {
    // 50/50 chance of true or false statement.
    final isTrue = _random.nextBool();

    if (isTrue) {
      return QuizQuestion(
        id: 'gen_tf_${technique.id}',
        type: QuestionType.trueFalse,
        questionText:
            '${technique.romajiName} is a '
            '${technique.englishName.toLowerCase()}.',
        options: const ['True', 'False'],
        correctAnswer: 'True',
        explanation:
            'Correct! ${technique.romajiName} is indeed '
            '${technique.englishName.toLowerCase()}.',
        targetRank: targetRank,
        category: technique.category.name,
      );
    } else {
      // Find a wrong English name from the same category.
      final others = allTechniques
          .where(
            (t) => t.category == technique.category && t.id != technique.id,
          )
          .toList();
      if (others.isEmpty) return null;
      final wrong = others[_random.nextInt(others.length)];
      return QuizQuestion(
        id: 'gen_tf_${technique.id}',
        type: QuestionType.trueFalse,
        questionText:
            '${technique.romajiName} is a '
            '${wrong.englishName.toLowerCase()}.',
        options: const ['True', 'False'],
        correctAnswer: 'False',
        explanation:
            '${technique.romajiName} is actually '
            '${technique.englishName.toLowerCase()}, not '
            '${wrong.englishName.toLowerCase()}.',
        targetRank: targetRank,
        category: technique.category.name,
      );
    }
  }

  /// Generates quiz questions from kata data.
  List<QuizQuestion> _generateKataQuestions(BeltRank targetRank) {
    final questions = <QuizQuestion>[];
    final targetOrder = targetRank.order;

    final eligibleKata = allKata
        .where((k) => k.minimumRank.order <= targetOrder)
        .toList();

    // Get kata IDs required for the target rank from the syllabus.
    final requirement = allBeltRequirements
        .where((r) => r.rank == targetRank)
        .toList();
    final requiredKataIds = requirement.isNotEmpty
        ? requirement.first.requiredKata
        : <String>[];

    for (final kata in eligibleKata) {
      // "What does [kata name] mean?" (MC)
      final wrongMeanings = eligibleKata
          .where((k) => k.id != kata.id)
          .take(3)
          .map((k) => k.meaning)
          .toList();
      if (wrongMeanings.length >= 3) {
        final options = [kata.meaning, ...wrongMeanings]..shuffle(_random);
        questions.add(
          QuizQuestion(
            id: 'gen_kata_meaning_${kata.id}',
            type: QuestionType.multipleChoice,
            questionText: 'What is the meaning of ${kata.englishName}?',
            options: options,
            correctAnswer: kata.meaning,
            explanation: '${kata.englishName} means "${kata.meaning}".',
            targetRank: targetRank,
            category: 'kata',
          ),
        );
      }

      // "How many moves in [kata]?" (MC) - only for required kata
      if (requiredKataIds.contains(kata.id)) {
        final wrongCounts = [
          kata.moveCount + 2,
          kata.moveCount - 2,
          kata.moveCount + 5,
        ].map((c) => c.clamp(1, 200).toString()).toList();
        final options = [kata.moveCount.toString(), ...wrongCounts]
          ..shuffle(_random);
        questions.add(
          QuizQuestion(
            id: 'gen_kata_moves_${kata.id}',
            type: QuestionType.multipleChoice,
            questionText: 'How many moves are in ${kata.englishName}?',
            options: options,
            correctAnswer: kata.moveCount.toString(),
            explanation: '${kata.englishName} has ${kata.moveCount} moves.',
            targetRank: targetRank,
            category: 'kata',
          ),
        );
      }
    }

    return questions;
  }

  /// Gets distractor (wrong) answers for multiple choice questions.
  ///
  /// Returns English names of other techniques in the same category,
  /// falling back to any category if insufficient same-category options.
  List<String> _getDistractors(Technique technique, int count) {
    // Prefer same-category distractors.
    final sameCategory =
        allTechniques
            .where(
              (t) => t.category == technique.category && t.id != technique.id,
            )
            .map((t) => t.englishName)
            .toList()
          ..shuffle(_random);

    if (sameCategory.length >= count) {
      return sameCategory.take(count).toList();
    }

    // Fall back to other categories.
    final otherCategory =
        allTechniques
            .where((t) => t.id != technique.id)
            .map((t) => t.englishName)
            .toList()
          ..shuffle(_random);

    final distractors = <String>{...sameCategory};
    for (final name in otherCategory) {
      if (distractors.length >= count) break;
      distractors.add(name);
    }
    return distractors.take(count).toList();
  }

  /// Checks if [userAnswer] is correct for the given [question].
  ///
  /// Uses fuzzy matching for fill-in-blank questions and exact
  /// (case-insensitive) matching for other types.
  bool _checkAnswer(QuizQuestion question, String userAnswer) {
    switch (question.type) {
      case QuestionType.fillInBlank:
        return _checkFillInBlankAnswer(userAnswer, question.correctAnswer);
      case QuestionType.multipleChoice:
      case QuestionType.trueFalse:
        return userAnswer.toLowerCase().trim() ==
            question.correctAnswer.toLowerCase().trim();
      case QuestionType.matchPairs:
        return userAnswer.toLowerCase().trim() ==
            question.correctAnswer.toLowerCase().trim();
    }
  }

  /// Checks a fill-in-blank answer using the 4-layer fuzzy matching.
  bool _checkFillInBlankAnswer(String userAnswer, String correctAnswer) {
    if (userAnswer.trim().isEmpty) return false;
    final result = _fuzzyMatchService.isMatch(userAnswer, correctAnswer);
    return result.isMatch;
  }

  /// Returns a human-readable display name for a technique category.
  String _categoryDisplayName(TechniqueCategory category) => switch (category) {
    TechniqueCategory.dachi => 'stance',
    TechniqueCategory.tsuki => 'punch',
    TechniqueCategory.geri => 'kick',
    TechniqueCategory.uke => 'block',
    TechniqueCategory.uchi => 'strike',
    TechniqueCategory.hiji => 'elbow strike',
    TechniqueCategory.hiza => 'knee strike',
    TechniqueCategory.kata => 'kata',
    TechniqueCategory.tameshiwari => 'breaking technique',
  };
}
