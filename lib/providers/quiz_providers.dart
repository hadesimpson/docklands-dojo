import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/quiz.dart';
import 'package:docklands_dojo/services/quiz_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_providers.g.dart';

/// Provides a singleton [QuizService] instance.
@riverpod
QuizService quizService(Ref ref) {
  return QuizService();
}

/// State for an in-progress quiz session.
///
/// Tracks the current question index, user answers, and elapsed time.
class ActiveQuizState {
  /// The quiz questions for this session.
  final List<QuizQuestion> questions;

  /// The quiz configuration used to generate this quiz.
  final QuizConfig config;

  /// Index of the current question (0-based).
  final int currentIndex;

  /// Map of question ID to user's answer.
  final Map<String, String> answers;

  /// When the quiz session started.
  final DateTime startTime;

  /// Whether the quiz has been completed.
  final bool isComplete;

  /// Creates an [ActiveQuizState].
  const ActiveQuizState({
    required this.questions,
    required this.config,
    this.currentIndex = 0,
    this.answers = const {},
    required this.startTime,
    this.isComplete = false,
  });

  /// The current question, or `null` if the quiz is complete.
  QuizQuestion? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  /// The total number of questions.
  int get totalQuestions => questions.length;

  /// Progress as a fraction (0.0 to 1.0).
  double get progress =>
      totalQuestions > 0 ? currentIndex / totalQuestions : 0.0;

  /// Whether there are more questions remaining.
  bool get hasNext => currentIndex < questions.length - 1;

  /// Creates a copy with the given fields replaced.
  ActiveQuizState copyWith({
    List<QuizQuestion>? questions,
    QuizConfig? config,
    int? currentIndex,
    Map<String, String>? answers,
    DateTime? startTime,
    bool? isComplete,
  }) {
    return ActiveQuizState(
      questions: questions ?? this.questions,
      config: config ?? this.config,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      startTime: startTime ?? this.startTime,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

/// Manages the state of an in-progress quiz session.
///
/// Provides methods to start a quiz, submit answers, navigate
/// between questions, and complete the quiz.
class ActiveQuizNotifier extends StateNotifier<ActiveQuizState?> {
  final QuizService _quizService;

  /// Creates an [ActiveQuizNotifier] with the given [QuizService].
  ActiveQuizNotifier(this._quizService) : super(null);

  /// Starts a new quiz with the given [config].
  ///
  /// Returns `true` if the quiz was successfully generated, `false` otherwise.
  bool startQuiz(QuizConfig config) {
    final result = _quizService.generateQuiz(config);
    switch (result) {
      case Success(:final data):
        state = ActiveQuizState(
          questions: data,
          config: config,
          startTime: DateTime.now(),
        );
        return true;
      case Failure():
        return false;
    }
  }

  /// Submits an [answer] for the current question and advances.
  void submitAnswer(String answer) {
    final current = state;
    if (current == null || current.isComplete) return;

    final question = current.currentQuestion;
    if (question == null) return;

    final updatedAnswers = Map<String, String>.from(current.answers)
      ..[question.id] = answer;

    final isLastQuestion = !current.hasNext;

    state = current.copyWith(
      answers: updatedAnswers,
      currentIndex: isLastQuestion
          ? current.currentIndex
          : current.currentIndex + 1,
      isComplete: isLastQuestion,
    );
  }

  /// Completes the quiz and returns the scored result.
  QuizAttemptResult? completeQuiz() {
    final current = state;
    if (current == null) return null;

    final duration = DateTime.now().difference(current.startTime);

    final result = _quizService.scoreQuiz(
      questions: current.questions,
      answers: current.answers,
      duration: duration,
      isMockExam: current.config.isMockExam,
    );

    state = current.copyWith(isComplete: true);

    return result;
  }

  /// Resets the quiz state, clearing the current session.
  void reset() {
    state = null;
  }
}

/// Provides the [ActiveQuizNotifier] for managing in-progress quizzes.
final activeQuizProvider =
    StateNotifierProvider<ActiveQuizNotifier, ActiveQuizState?>((ref) {
      final quizService = ref.watch(quizServiceProvider);
      return ActiveQuizNotifier(quizService);
    });

/// Provides the history of quiz attempts.
///
/// In-memory only for now; will be backed by Drift in a future CL.
class QuizHistoryNotifier extends StateNotifier<List<QuizAttemptResult>> {
  /// Creates a [QuizHistoryNotifier] with an empty history.
  QuizHistoryNotifier() : super([]);

  /// Adds a quiz attempt result to the history.
  void addResult(QuizAttemptResult result) {
    state = [...state, result];
  }

  /// Returns the number of times a mock exam for [rank] has been passed.
  int mockExamPassCount(BeltRank rank) {
    return state
        .where((r) => r.isMockExam && r.targetRank == rank && r.passed)
        .length;
  }

  /// Whether the user is "ready for grading" at [rank].
  ///
  /// Requires passing the mock exam 3 times per PRD spec.
  bool isReadyForGrading(BeltRank rank) {
    return mockExamPassCount(rank) >= 3;
  }

  /// Clears all quiz history.
  void clear() {
    state = [];
  }
}

/// Provides the quiz history notifier.
final quizHistoryProvider =
    StateNotifierProvider<QuizHistoryNotifier, List<QuizAttemptResult>>((ref) {
      return QuizHistoryNotifier();
    });
