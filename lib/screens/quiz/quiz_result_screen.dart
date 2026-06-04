import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/quiz.dart';
import 'package:flutter/material.dart';

/// Quiz results screen showing score and category breakdown.
///
/// Displays:
/// - Large score percentage (centered)
/// - Pass/fail badge for mock exams (80% threshold)
/// - Per-category score breakdown as progress bars
/// - Weak areas highlighted in red
/// - "Review Weak Areas" and "Try Again" action buttons
class QuizResultScreen extends StatelessWidget {
  /// The scored quiz attempt result.
  final QuizAttemptResult result;

  /// Callback when "Try Again" is tapped. If null, pops navigation.
  final VoidCallback? onTryAgain;

  /// Callback when "Review Weak Areas" is tapped.
  final VoidCallback? onReviewWeakAreas;

  /// Creates a [QuizResultScreen].
  const QuizResultScreen({
    required this.result,
    this.onTryAgain,
    this.onReviewWeakAreas,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = result.scorePercentage * 100;
    final isPassing = result.passed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Score display.
              _buildScoreCard(theme, percentage, isPassing),
              const SizedBox(height: 16),

              // Mock exam pass/fail badge.
              if (result.isMockExam) ...[
                _buildPassFailBadge(theme, isPassing),
                const SizedBox(height: 16),
              ],

              // Stats summary.
              _buildStatsCard(theme),
              const SizedBox(height: 16),

              // Category breakdown.
              if (result.categoryScores.isNotEmpty) ...[
                _buildCategoryBreakdown(theme),
                const SizedBox(height: 16),
              ],

              // Weak areas.
              if (result.weakAreas.isNotEmpty) ...[
                _buildWeakAreas(theme),
                const SizedBox(height: 24),
              ],

              // Action buttons.
              _buildActionButtons(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(ThemeData theme, double percentage, bool isPassing) {
    final scoreColor = isPassing ? Colors.green : Colors.orange;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            Semantics(
              label: 'Score: ${percentage.toStringAsFixed(0)} percent',
              child: Text(
                '${percentage.toStringAsFixed(0)}%',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${result.correctAnswers} / ${result.totalQuestions} correct',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(179),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              result.targetRank.displayName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(128),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassFailBadge(ThemeData theme, bool isPassing) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isPassing ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPassing ? Colors.green : Colors.red),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPassing ? Icons.emoji_events : Icons.school,
            color: isPassing ? Colors.green.shade700 : Colors.red.shade700,
          ),
          const SizedBox(width: 8),
          Text(
            isPassing
                ? 'PASSED — Ready for grading! 🎉'
                : 'NOT YET — Keep studying! 📖',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPassing ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme) {
    final minutes = result.duration.inMinutes;
    final seconds = result.duration.inSeconds % 60;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _statRow(
              theme,
              icon: Icons.timer,
              label: 'Time',
              value: '${minutes}m ${seconds}s',
            ),
            const Divider(height: 24),
            _statRow(
              theme,
              icon: Icons.quiz,
              label: 'Questions',
              value: '${result.totalQuestions}',
            ),
            const Divider(height: 24),
            _statRow(
              theme,
              icon: Icons.category,
              label: 'Categories',
              value: '${result.categoryScores.length}',
            ),
            if (result.isMockExam) ...[
              const Divider(height: 24),
              _statRow(
                theme,
                icon: Icons.grade,
                label: 'Pass Threshold',
                value: '80%',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statRow(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(ThemeData theme) {
    final sortedCategories = result.categoryScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...sortedCategories.map((entry) {
              final isWeak = result.weakAreas.contains(entry.key);
              final percentage = entry.value * 100;
              final color = isWeak ? Colors.red : Colors.green;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Semantics(
                  label:
                      '${_formatCategory(entry.key)}: ${percentage.toStringAsFixed(0)} percent',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatCategory(entry.key),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isWeak ? Colors.red.shade700 : null,
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(0)}%',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isWeak ? Colors.red.shade700 : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: entry.value,
                          backgroundColor: color.withAlpha(51),
                          color: color,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildWeakAreas(ThemeData theme) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Text(
                  'Weak Areas',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Focus your study on these categories:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: result.weakAreas.map((area) {
                return Chip(
                  label: Text(_formatCategory(area)),
                  backgroundColor: Colors.red.shade100,
                  labelStyle: TextStyle(color: Colors.red.shade900),
                  side: BorderSide.none,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (result.weakAreas.isNotEmpty)
          OutlinedButton.icon(
            onPressed: onReviewWeakAreas ?? () => Navigator.of(context).pop(),
            icon: const Icon(Icons.school),
            label: const Text('Review Weak Areas'),
          ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: onTryAgain ?? () => Navigator.of(context).pop(),
          icon: const Icon(Icons.replay),
          label: const Text('Try Again'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }

  /// Formats a category key to a display name.
  String _formatCategory(String category) => switch (category) {
    'dachi' => 'Stances',
    'tsuki' => 'Punches',
    'geri' => 'Kicks',
    'uke' => 'Blocks',
    'uchi' => 'Strikes',
    'hiji' => 'Elbow Strikes',
    'hiza' => 'Knee Strikes',
    'kata' => 'Kata',
    'tameshiwari' => 'Breaking',
    'terminology' => 'Terminology',
    _ => category[0].toUpperCase() + category.substring(1),
  };
}
