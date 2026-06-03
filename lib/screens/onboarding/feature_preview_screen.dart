import 'package:flutter/material.dart';

import '../../theme/dojo_colors.dart';

/// Final screen of the onboarding flow.
///
/// Presents a quick tour of 3 key features with icons and descriptions.
/// The "Let's Go!" button triggers [onFinish] to complete onboarding.
class FeaturePreviewScreen extends StatelessWidget {
  /// Creates a [FeaturePreviewScreen].
  ///
  /// [onFinish] is called when the user taps "Let's Go!".
  const FeaturePreviewScreen({required this.onFinish, super.key});

  /// Callback invoked when the user finishes the onboarding tour.
  final VoidCallback onFinish;

  /// The features displayed during the tour.
  static const List<_Feature> _features = [
    _Feature(
      emoji: '🥋',
      title: 'Belt Progression',
      description: 'Track your journey from white to black belt',
      icon: Icons.emoji_events_outlined,
    ),
    _Feature(
      emoji: '🧠',
      title: 'Spaced Repetition',
      description: 'Master Japanese terminology with smart flashcards',
      icon: Icons.psychology_outlined,
    ),
    _Feature(
      emoji: '📝',
      title: 'Grading Prep',
      description: 'Test yourself before your next grading',
      icon: Icons.quiz_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Text(
                'What you can do',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ..._features.map((feature) => _FeatureRow(feature: feature)),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: onFinish,
                  style: FilledButton.styleFrom(
                    backgroundColor: DojoColors.secondaryLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Let's Go!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

/// Data class for a feature displayed in the tour.
class _Feature {
  const _Feature({
    required this.emoji,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String emoji;
  final String title;
  final String description;
  final IconData icon;
}

/// A row displaying a single feature with its emoji, title, and description.
class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature});

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(feature.emoji, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(179),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
