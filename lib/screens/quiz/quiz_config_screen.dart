import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/quiz.dart';
import 'package:docklands_dojo/models/technique.dart';
import 'package:flutter/material.dart';

/// Quiz setup screen for configuring grading preparation quizzes.
///
/// Allows the user to:
/// - Select a target belt rank via dropdown
/// - Toggle mock exam mode (timed, 80% pass threshold)
/// - Filter by technique categories via checkboxes
/// - Adjust question count via slider (10-50, auto for mock exam)
/// - Start the quiz via the "Start Quiz" button
///
/// Uses [QuizConfig] to pass configuration to the quiz screen.
class QuizConfigScreen extends StatefulWidget {
  /// Callback invoked with a [QuizConfig] when "Start Quiz" is tapped.
  final void Function(QuizConfig config) onStartQuiz;

  /// Optional initial belt rank to pre-select.
  final BeltRank? initialBeltRank;

  /// Creates a [QuizConfigScreen].
  const QuizConfigScreen({
    required this.onStartQuiz,
    this.initialBeltRank,
    super.key,
  });

  @override
  State<QuizConfigScreen> createState() => _QuizConfigScreenState();
}

class _QuizConfigScreenState extends State<QuizConfigScreen> {
  late BeltRank _selectedRank;
  bool _isMockExam = false;
  int _questionCount = 20;
  final Set<String> _selectedCategories = {};

  /// All available quiz categories derived from [TechniqueCategory].
  static const List<String> _allCategories = [
    'dachi',
    'tsuki',
    'geri',
    'uke',
    'uchi',
    'hiji',
    'hiza',
    'kata',
    'tameshiwari',
    'terminology',
  ];

  @override
  void initState() {
    super.initState();
    _selectedRank = widget.initialBeltRank ?? BeltRank.kyu10;
  }

  void _handleStartQuiz() {
    final config = QuizConfig(
      targetRank: _selectedRank,
      isMockExam: _isMockExam,
      questionCount: _questionCount,
      categories: _selectedCategories.toList(),
    );
    widget.onStartQuiz(config);
  }

  /// Returns a display name for a category string.
  String _categoryDisplayName(String category) => switch (category) {
    'dachi' => 'Stances (Dachi)',
    'tsuki' => 'Punches (Tsuki)',
    'geri' => 'Kicks (Geri)',
    'uke' => 'Blocks (Uke)',
    'uchi' => 'Strikes (Uchi)',
    'hiji' => 'Elbow (Hiji)',
    'hiza' => 'Knee (Hiza)',
    'kata' => 'Kata',
    'tameshiwari' => 'Breaking',
    'terminology' => 'Terminology',
    _ => category,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Setup')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Belt rank selector.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Belt',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Semantics(
                        label: 'Select target belt rank',
                        child: DropdownButtonFormField<BeltRank>(
                          value: _selectedRank,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.military_tech),
                          ),
                          items: BeltRank.values.map((rank) {
                            return DropdownMenuItem(
                              value: rank,
                              child: Text(
                                '${rank.displayName} — ${rank.colorDescription}',
                              ),
                            );
                          }).toList(),
                          onChanged: (rank) {
                            if (rank != null) {
                              setState(() => _selectedRank = rank);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mock exam toggle.
              Card(
                child: Semantics(
                  label: 'Mock exam mode toggle',
                  child: SwitchListTile(
                    title: const Text('Mock Exam Mode'),
                    subtitle: Text(
                      _isMockExam
                          ? 'Timed exam with ${QuizConfig(targetRank: _selectedRank, isMockExam: true).mockExamQuestionCount} questions. '
                                '80% to pass.'
                          : 'Practice mode — no time limit, custom question count.',
                    ),
                    secondary: Icon(
                      _isMockExam ? Icons.timer : Icons.school,
                      color: _isMockExam
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.primary,
                    ),
                    value: _isMockExam,
                    onChanged: (value) {
                      setState(() => _isMockExam = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Question count slider (disabled for mock exam).
              if (!_isMockExam)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Questions',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$_questionCount',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Semantics(
                          label: 'Question count slider',
                          value: '$_questionCount questions',
                          child: Slider(
                            value: _questionCount.toDouble(),
                            min: 10,
                            max: 50,
                            divisions: 8,
                            label: '$_questionCount',
                            onChanged: (value) {
                              setState(() => _questionCount = value.round());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!_isMockExam) const SizedBox(height: 16),

              // Category filters.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (_selectedCategories.length ==
                                    _allCategories.length) {
                                  _selectedCategories.clear();
                                } else {
                                  _selectedCategories.addAll(_allCategories);
                                }
                              });
                            },
                            child: Text(
                              _selectedCategories.length ==
                                      _allCategories.length
                                  ? 'Clear All'
                                  : 'Select All',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedCategories.isEmpty
                            ? 'All categories included'
                            : '${_selectedCategories.length} selected',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: _allCategories.map((category) {
                          final isSelected = _selectedCategories.contains(
                            category,
                          );
                          return FilterChip(
                            label: Text(_categoryDisplayName(category)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedCategories.add(category);
                                } else {
                                  _selectedCategories.remove(category);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Start quiz button.
              SizedBox(
                height: 56,
                child: Semantics(
                  label: 'Start quiz',
                  button: true,
                  child: FilledButton.icon(
                    onPressed: _handleStartQuiz,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      _isMockExam ? 'Start Mock Exam' : 'Start Quiz',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
