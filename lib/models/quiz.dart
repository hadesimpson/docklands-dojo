import 'package:docklands_dojo/models/belt_rank.dart';

/// Types of quiz questions supported by the grading prep system.
///
/// Each type has different rendering and scoring behavior:
/// - [multipleChoice]: 4 options, exactly one correct
/// - [fillInBlank]: Free-text with fuzzy matching
/// - [trueFalse]: Binary true/false statement
/// - [matchPairs]: Match Japanese terms to English translations
enum QuestionType {
  /// Multiple choice with 4 options.
  multipleChoice,

  /// Free-text answer with fuzzy matching for Japanese romanization.
  fillInBlank,

  /// True or false statement about a technique or concept.
  trueFalse,

  /// Match Japanese terms to English translations.
  matchPairs,
}

/// A single quiz question for grading preparation.
///
/// Questions are generated dynamically by [QuizService] based on
/// the technique pool for a target belt rank. Each question has a
/// [type] that determines how it is rendered and scored.
///
/// ```dart
/// const question = QuizQuestion(
///   id: 'q1',
///   type: QuestionType.multipleChoice,
///   questionText: 'What is the English name for mawashi geri?',
///   options: ['Roundhouse kick', 'Front kick', 'Side kick', 'Back kick'],
///   correctAnswer: 'Roundhouse kick',
///   explanation: 'Mawashi geri is the Japanese term for roundhouse kick.',
///   targetRank: BeltRank.kyu10,
///   category: 'geri',
/// );
/// ```
class QuizQuestion {
  /// Unique identifier for this question instance.
  final String id;

  /// The type of question (determines rendering and scoring).
  final QuestionType type;

  /// The question text shown to the user.
  final String questionText;

  /// Answer options for multiple choice. Empty for other types.
  final List<String> options;

  /// The correct answer string.
  ///
  /// For [QuestionType.trueFalse], this is 'true' or 'false'.
  /// For [QuestionType.fillInBlank], fuzzy matching is applied.
  /// For [QuestionType.matchPairs], this is a pipe-separated list
  /// of correct pairs (e.g., 'term1=answer1|term2=answer2').
  final String correctAnswer;

  /// Explanation shown after answering (correct or incorrect).
  final String explanation;

  /// The belt rank this question targets.
  final BeltRank targetRank;

  /// Category of the question (e.g., 'tsuki', 'geri', 'terminology').
  final String category;

  /// Creates a [QuizQuestion] with the given parameters.
  const QuizQuestion({
    required this.id,
    required this.type,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.targetRank,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is QuizQuestion && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'QuizQuestion($id, $type, $category)';
}

/// Configuration for generating a quiz.
///
/// Controls the target belt rank, whether this is a mock exam,
/// the number of questions, and which categories to include.
class QuizConfig {
  /// The belt rank to generate questions for.
  ///
  /// Questions will be drawn from techniques required for this rank
  /// and all ranks up to and including it.
  final BeltRank targetRank;

  /// Whether this is a mock grading exam.
  ///
  /// Mock exams use a fixed question count per the PRD table
  /// and require 80% to pass.
  final bool isMockExam;

  /// Number of questions to generate.
  ///
  /// For mock exams, this is overridden by [mockExamQuestionCount].
  final int questionCount;

  /// Categories to include (empty means all categories).
  final List<String> categories;

  /// Creates a [QuizConfig] with the given parameters.
  const QuizConfig({
    required this.targetRank,
    this.isMockExam = false,
    this.questionCount = 10,
    this.categories = const [],
  });

  /// Returns the mock exam question count for the target rank.
  ///
  /// Follows the PRD table:
  /// - kyu10: 20, kyu9: 25, kyu8: 25, kyu7: 30, kyu6: 30
  /// - kyu5: 35, kyu4: 35, kyu3: 40, kyu2: 45, kyu1: 50, shodan: 60
  int get mockExamQuestionCount => switch (targetRank) {
    BeltRank.kyu10 => 20,
    BeltRank.kyu9 => 25,
    BeltRank.kyu8 => 25,
    BeltRank.kyu7 => 30,
    BeltRank.kyu6 => 30,
    BeltRank.kyu5 => 35,
    BeltRank.kyu4 => 35,
    BeltRank.kyu3 => 40,
    BeltRank.kyu2 => 45,
    BeltRank.kyu1 => 50,
    BeltRank.shodan => 60,
  };

  /// The effective question count (respects mock exam overrides).
  int get effectiveQuestionCount =>
      isMockExam ? mockExamQuestionCount : questionCount;

  @override
  String toString() =>
      'QuizConfig($targetRank, mock=$isMockExam, count=$effectiveQuestionCount)';
}

/// Result of answering a single quiz question.
class QuestionResult {
  /// The question that was answered.
  final QuizQuestion question;

  /// The user's answer.
  final String userAnswer;

  /// Whether the answer was correct (including fuzzy matching).
  final bool isCorrect;

  /// Creates a [QuestionResult].
  const QuestionResult({
    required this.question,
    required this.userAnswer,
    required this.isCorrect,
  });

  @override
  String toString() => 'QuestionResult(${question.id}, correct=$isCorrect)';
}

/// Complete result of a quiz attempt with per-question breakdown.
///
/// Extends the basic quiz attempt data with detailed per-question
/// results and category-level score breakdown for identifying
/// weak areas.
class QuizAttemptResult {
  /// Timestamp when the quiz was completed.
  final DateTime timestamp;

  /// The belt rank this quiz targeted.
  final BeltRank targetRank;

  /// Whether this was a mock grading exam.
  final bool isMockExam;

  /// Total number of questions in the quiz.
  final int totalQuestions;

  /// Number of correctly answered questions.
  final int correctAnswers;

  /// Time spent on the quiz.
  final Duration duration;

  /// Per-category score as a percentage (0.0 to 1.0).
  final Map<String, double> categoryScores;

  /// Categories where the user scored below 80%.
  final List<String> weakAreas;

  /// Per-question results for detailed review.
  final List<QuestionResult> questionResults;

  /// Creates a [QuizAttemptResult].
  const QuizAttemptResult({
    required this.timestamp,
    required this.targetRank,
    required this.isMockExam,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.duration,
    required this.categoryScores,
    required this.weakAreas,
    required this.questionResults,
  });

  /// The overall score as a percentage (0.0 to 1.0).
  double get scorePercentage =>
      totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;

  /// Whether the mock exam was passed (≥ 80%).
  bool get passed => scorePercentage >= 0.8;

  @override
  String toString() =>
      'QuizAttemptResult($targetRank, ${(scorePercentage * 100).toStringAsFixed(1)}%, '
      'mock=$isMockExam, passed=$passed)';
}
