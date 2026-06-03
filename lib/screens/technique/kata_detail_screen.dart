import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/kata.dart';
import 'package:flutter/material.dart';

/// Full-screen detail view for an individual kata.
///
/// Standalone screen accessible from navigation routes.
///
/// Shows:
/// - Header with kata name + meaning
/// - Move count, minimum rank
/// - History section
/// - Key principles
/// - Movement sequence (numbered steps)
/// - Bunkai (applications), if available
///
/// See PRD Section 3, F2.
class KataDetailScreen extends StatelessWidget {
  /// The kata to display.
  final Kata kata;

  /// Creates a [KataDetailScreen].
  const KataDetailScreen({required this.kata, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(kata.englishName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Japanese name + meaning.
            Text(kata.japaneseName, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(
              kata.meaning,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),

            // Move count and minimum rank chips.
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(
                  avatar: const Icon(Icons.format_list_numbered, size: 18),
                  label: Text('${kata.moveCount} moves'),
                ),
                Chip(
                  avatar: const Icon(Icons.emoji_events, size: 18),
                  label: Text('Min: ${kata.minimumRank.displayName}'),
                  backgroundColor: kata.minimumRank.primaryColor.withValues(
                    alpha: 0.15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // History.
            const _SectionHeader(title: 'History', icon: Icons.history_edu),
            const SizedBox(height: 8),
            Text(kata.history, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),

            // Key Principles.
            if (kata.keyPrinciples.isNotEmpty) ...[
              const _SectionHeader(
                title: 'Key Principles',
                icon: Icons.lightbulb_outline,
              ),
              const SizedBox(height: 8),
              ...kata.keyPrinciples.map((principle) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(principle)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],

            // Movement Sequence.
            if (kata.movementSequence.isNotEmpty) ...[
              const _SectionHeader(
                title: 'Movement Sequence',
                icon: Icons.directions_walk,
              ),
              const SizedBox(height: 8),
              ...kata.movementSequence.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 32,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: theme.colorScheme.secondary,
                          child: Text(
                            '${entry.key + 1}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(entry.value)),
                    ],
                  ),
                );
              }),
            ],

            // Bunkai (if available).
            if (kata.bunkai != null && kata.bunkai!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const _SectionHeader(
                title: 'Bunkai (Applications)',
                icon: Icons.sports_martial_arts,
              ),
              const SizedBox(height: 8),
              ...kata.bunkai!.map((application) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.sports_martial_arts,
                        size: 20,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(application)),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

/// Section header with icon and title.
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
