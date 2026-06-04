import 'dart:async';

import 'package:docklands_dojo/models/quiz.dart';
import 'package:docklands_dojo/providers/quiz_providers.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/screens/quiz/quiz_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Active quiz screen displaying questions one at a time.
///
/// Supports four question types:
/// - Multiple choice: four tappable option buttons
/// - Fill-in-blank: text field with submit button
/// - True/false: two large buttons
///
/// Includes a progress indicator, timer (for mock exams), and
/// correct/incorrect feedback with color animation after each answer.
class QuizScreen extends ConsumerStatefulWidget {
  /// The quiz configuration used to generate questions.
  final QuizConfig config;

  /// Creates a [QuizScreen].
  const QuizScreen({required this.config, super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  final Map<String, String> _answers = {};
  String? _selectedAnswer;
  bool _answered = false;
  bool _isCorrect = false;
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _fillInController = TextEditingController();

  // Timer state.
  late DateTime _startTime;
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _generateQuiz();

    // Start timer for mock exams.
    if (widget.config.isMockExam) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          _elapsed = DateTime.now().difference(_startTime);
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fillInController.dispose();
    super.dispose();
  }

  void _generateQuiz() {
    final quizService = ref.read(quizServiceProvider);
    final result = quizService.generateQuiz(widget.config);

    switch (result) {
      case Success(:final data):
        setState(() {
          _questions = data;
          _isLoading = false;
        });
      case Failure(:final message):
        setState(() {
          _errorMessage = message;
          _isLoading = false;
        });
    }
  }

  void _submitAnswer(String answer) {
    if (_answered) return;

    final question = _questions[_currentIndex];
    final quizService = ref.read(quizServiceProvider);

    // Check answer correctness.
    final tempResult = quizService.scoreQuiz(
      questions: [question],
      answers: {question.id: answer},
      duration: Duration.zero,
    );

    setState(() {
      _selectedAnswer = answer;
      _answered = true;
      _isCorrect = tempResult.correctAnswers > 0;
      _answers[question.id] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _answered = false;
        _selectedAnswer = null;
        _isCorrect = false;
        _fillInController.clear();
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    final quizService = ref.read(quizServiceProvider);
    final duration = DateTime.now().difference(_startTime);

    final attemptResult = quizService.scoreQuiz(
      questions: _questions,
      answers: _answers,
      duration: duration,
      isMockExam: widget.config.isMockExam,
    );

    // Save to history.
    ref.read(quizHistoryProvider.notifier).addResult(attemptResult);

    // Navigate to results.
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => QuizResultScreen(result: attemptResult),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: Text('No questions available.')),
      );
    }

    return _buildQuizBody(context);
  }

  Widget _buildQuizBody(BuildContext context) {
    final theme = Theme.of(context);
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}/${_questions.length}'),
        actions: [
          if (widget.config.isMockExam)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Semantics(
                  label: 'Timer: ${_formatDuration(_elapsed)}',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 18,
                        color: theme.colorScheme.onPrimary.withAlpha(200),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(_elapsed),
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar.
            Semantics(
              label:
                  'Progress: question ${_currentIndex + 1} of ${_questions.length}',
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: theme.colorScheme.primary,
                minHeight: 4,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question text.
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildQuestionTypeChip(theme, question.type),
                            const SizedBox(height: 12),
                            Text(
                              question.questionText,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Answer options based on question type.
                    _buildAnswerSection(theme, question),

                    // Feedback section.
                    if (_answered) ...[
                      const SizedBox(height: 16),
                      _buildFeedback(theme, question),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: _nextQuestion,
                          child: Text(
                            _currentIndex < _questions.length - 1
                                ? 'Next Question'
                                : 'See Results',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionTypeChip(ThemeData theme, QuestionType type) {
    final (label, icon) = switch (type) {
      QuestionType.multipleChoice => ('Multiple Choice', Icons.list),
      QuestionType.fillInBlank => ('Fill in the Blank', Icons.edit),
      QuestionType.trueFalse => ('True or False', Icons.check_circle),
      QuestionType.matchPairs => ('Match Pairs', Icons.compare_arrows),
    };

    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: theme.textTheme.labelSmall),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildAnswerSection(ThemeData theme, QuizQuestion question) {
    return switch (question.type) {
      QuestionType.multipleChoice => _buildMultipleChoice(theme, question),
      QuestionType.fillInBlank => _buildFillInBlank(theme, question),
      QuestionType.trueFalse => _buildTrueFalse(theme, question),
      QuestionType.matchPairs => _buildMultipleChoice(theme, question),
    };
  }

  Widget _buildMultipleChoice(ThemeData theme, QuizQuestion question) {
    return Column(
      children: question.options.map((option) {
        final isSelected = _selectedAnswer == option;
        final isCorrectOption =
            option.toLowerCase().trim() ==
            question.correctAnswer.toLowerCase().trim();

        Color? backgroundColor;
        Color? foregroundColor;
        if (_answered) {
          if (isCorrectOption) {
            backgroundColor = Colors.green.shade100;
            foregroundColor = Colors.green.shade900;
          } else if (isSelected && !_isCorrect) {
            backgroundColor = Colors.red.shade100;
            foregroundColor = Colors.red.shade900;
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SizedBox(
            width: double.infinity,
            child: Semantics(
              label: 'Answer option: $option',
              selected: isSelected,
              child: OutlinedButton(
                onPressed: _answered ? null : () => _submitAnswer(option),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  backgroundColor: backgroundColor,
                  foregroundColor: foregroundColor,
                  side: isSelected && !_answered
                      ? BorderSide(color: theme.colorScheme.primary, width: 2)
                      : null,
                ),
                child: Text(option, textAlign: TextAlign.center),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFillInBlank(ThemeData theme, QuizQuestion question) {
    return Column(
      children: [
        Semantics(
          label: 'Type your answer',
          child: TextField(
            controller: _fillInController,
            enabled: !_answered,
            decoration: InputDecoration(
              hintText: 'Type your answer...',
              suffixIcon: _answered
                  ? Icon(
                      _isCorrect ? Icons.check_circle : Icons.cancel,
                      color: _isCorrect ? Colors.green : Colors.red,
                    )
                  : null,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: _answered
                ? null
                : (value) => _submitAnswer(value.trim()),
          ),
        ),
        if (!_answered) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () => _submitAnswer(_fillInController.text.trim()),
              child: const Text('Submit Answer'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTrueFalse(ThemeData theme, QuizQuestion question) {
    return Row(
      children: ['True', 'False'].map((option) {
        final isSelected = _selectedAnswer == option;
        final isCorrectOption =
            option.toLowerCase() == question.correctAnswer.toLowerCase();

        Color? backgroundColor;
        Color? foregroundColor;
        IconData? icon;

        if (_answered) {
          if (isCorrectOption) {
            backgroundColor = Colors.green.shade100;
            foregroundColor = Colors.green.shade900;
            icon = Icons.check;
          } else if (isSelected && !_isCorrect) {
            backgroundColor = Colors.red.shade100;
            foregroundColor = Colors.red.shade900;
            icon = Icons.close;
          }
        }

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: option == 'True' ? 4 : 0,
              left: option == 'False' ? 4 : 0,
            ),
            child: SizedBox(
              height: 64,
              child: Semantics(
                label: '$option button',
                selected: isSelected,
                child: OutlinedButton.icon(
                  onPressed: _answered ? null : () => _submitAnswer(option),
                  icon: Icon(
                    icon ??
                        (option == 'True' ? Icons.thumb_up : Icons.thumb_down),
                  ),
                  label: Text(option, style: const TextStyle(fontSize: 16)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeedback(ThemeData theme, QuizQuestion question) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isCorrect ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isCorrect ? Icons.check_circle : Icons.cancel,
                color: _isCorrect ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                _isCorrect ? 'Correct! ✓' : 'Incorrect ✗',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _isCorrect
                      ? Colors.green.shade900
                      : Colors.red.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.explanation,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: _isCorrect ? Colors.green.shade900 : Colors.red.shade900,
            ),
          ),
          if (!_isCorrect) ...[
            const SizedBox(height: 8),
            Text(
              'Correct answer: ${question.correctAnswer}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
