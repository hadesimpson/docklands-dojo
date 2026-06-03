import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/technique.dart';
import 'package:docklands_dojo/screens/technique/technique_library_screen.dart';
import 'package:docklands_dojo/services/search_service.dart';
import 'package:flutter/material.dart';

/// Full-screen detail view for an individual technique.
///
/// Standalone screen accessible from navigation routes. Shows:
/// - Header with technique name (Japanese + English)
/// - Category chip
/// - Description section
/// - "Key Points" section with numbered list
/// - "Common Mistakes" section with warning icons
/// - "Required for" section showing belt ranks
/// - "Related Techniques" section with tappable links
///
/// See PRD Section 3, F2.
class TechniqueDetailScreen extends StatelessWidget {
  /// The technique to display.
  final Technique technique;

  /// Creates a [TechniqueDetailScreen].
  const TechniqueDetailScreen({required this.technique, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const searchService = SearchService();

    return Scaffold(
      appBar: AppBar(title: Text(technique.romajiName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Japanese + English name.
            Text(technique.japaneseName, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(
              technique.englishName,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),

            // Category chip.
            Chip(
              avatar: Icon(categoryIcon(technique.category), size: 18),
              label: Text(categoryDisplayName(technique.category)),
            ),
            const SizedBox(height: 16),

            // Description.
            const _SectionHeader(title: 'Description', icon: Icons.description),
            const SizedBox(height: 8),
            Text(technique.description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),

            // Key Points.
            if (technique.keyPoints.isNotEmpty) ...[
              const _SectionHeader(title: 'Key Points', icon: Icons.star),
              const SizedBox(height: 8),
              ...technique.keyPoints.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          '${entry.key + 1}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(entry.value)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],

            // Common Mistakes.
            if (technique.commonMistakes.isNotEmpty) ...[
              const _SectionHeader(
                title: 'Common Mistakes',
                icon: Icons.warning_amber,
              ),
              const SizedBox(height: 8),
              ...technique.commonMistakes.map((mistake) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber,
                        size: 20,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(mistake)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],

            // Required for belts.
            if (technique.requiredForBelts.isNotEmpty) ...[
              const _SectionHeader(
                title: 'Required For',
                icon: Icons.emoji_events,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: technique.requiredForBelts.map((belt) {
                  return Chip(
                    label: Text(
                      '${belt.displayName} — ${belt.colorDescription}',
                    ),
                    backgroundColor: belt.primaryColor.withValues(alpha: 0.15),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Related Techniques.
            if (technique.relatedTechniqueIds.isNotEmpty) ...[
              const _SectionHeader(
                title: 'Related Techniques',
                icon: Icons.link,
              ),
              const SizedBox(height: 8),
              ...technique.relatedTechniqueIds.map((id) {
                final related = searchService.getTechniqueById(id);
                if (related == null) return const SizedBox.shrink();
                return Card(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    dense: true,
                    leading: Icon(categoryIcon(related.category), size: 20),
                    title: Text(related.romajiName),
                    subtitle: Text(related.englishName),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              TechniqueDetailScreen(technique: related),
                        ),
                      );
                    },
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
