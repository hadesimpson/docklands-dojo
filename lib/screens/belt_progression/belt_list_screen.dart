import 'package:docklands_dojo/data/syllabus_data.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/belt_requirement.dart';
import 'package:docklands_dojo/providers/progress_providers.dart';
import 'package:docklands_dojo/screens/belt_progression/belt_detail_screen.dart';
import 'package:docklands_dojo/screens/belt_progression/widgets/belt_card.dart';
import 'package:docklands_dojo/screens/belt_progression/widgets/progress_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Main belt journey screen showing a vertical timeline of all 11 belts.
///
/// Displays each belt rank as a card with:
/// - Color swatch with stripe rendering (via [BeltCard])
/// - Display name and Japanese name
/// - Completion percentage ring
/// - Current belt highlighted with glow effect
///
/// Tapping a belt navigates to [BeltDetailScreen].
///
/// Uses [currentProgressProvider] for reactive state and
/// [completionPercentageProvider] for per-belt completion.
class BeltListScreen extends ConsumerWidget {
  /// Creates a [BeltListScreen].
  const BeltListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(currentProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Belt Progression')),
      body: progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text('Failed to load progress: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(currentProgressProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (progress) => _BeltTimeline(
          currentRank: progress?.currentRank ?? BeltRank.kyu10,
          completedTechniques: progress?.completedTechniques ?? {},
        ),
      ),
    );
  }
}

/// The vertical timeline of all 11 belt ranks.
class _BeltTimeline extends ConsumerWidget {
  final BeltRank currentRank;
  final Map<String, bool> completedTechniques;

  const _BeltTimeline({
    required this.currentRank,
    required this.completedTechniques,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const belts = BeltRank.values;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: belts.length,
      itemBuilder: (context, index) {
        final rank = belts[index];
        final isCurrent = rank == currentRank;
        final requirement = _getRequirement(rank);
        final completionAsync = ref.watch(completionPercentageProvider(rank));
        final completion = completionAsync.valueOrNull ?? 0.0;

        return _BeltTimelineItem(
          rank: rank,
          requirement: requirement,
          isCurrent: isCurrent,
          completion: completion,
          isFirst: index == 0,
          isLast: index == belts.length - 1,
        );
      },
    );
  }

  BeltRequirement? _getRequirement(BeltRank rank) {
    for (final req in allBeltRequirements) {
      if (req.rank == rank) return req;
    }
    return null;
  }
}

/// A single item in the belt timeline.
class _BeltTimelineItem extends StatelessWidget {
  final BeltRank rank;
  final BeltRequirement? requirement;
  final bool isCurrent;
  final double completion;
  final bool isFirst;
  final bool isLast;

  const _BeltTimelineItem({
    required this.rank,
    required this.requirement,
    required this.isCurrent,
    required this.completion,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line and dot.
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Line above dot (hidden for first item).
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst
                        ? Colors.transparent
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
                // Dot.
                Container(
                  width: isCurrent ? 16 : 10,
                  height: isCurrent ? 16 : 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent
                        ? rank.primaryColor
                        : theme.colorScheme.outlineVariant,
                    border: isCurrent
                        ? Border.all(color: theme.colorScheme.primary, width: 2)
                        : null,
                  ),
                ),
                // Line below dot (hidden for last item).
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Belt card.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _buildCard(context, theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, ThemeData theme) {
    final card = Card(
      elevation: isCurrent ? 3 : 1,
      shape: isCurrent
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: rank.primaryColor.withAlpha(180),
                width: 2,
              ),
            )
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Belt color swatch.
              SizedBox(
                width: 56,
                child: BeltCard(
                  rank: rank,
                  size: BeltCardSize.small,
                  showLabel: false,
                ),
              ),
              const SizedBox(width: 12),
              // Belt info.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          rank.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(30),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Current',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${rank.japaneseName} — ${rank.colorDescription}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                    if (requirement != null) ...[
                      const SizedBox(height: 6),
                      // Completion bar.
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: completion,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            rank.primaryColor,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Progress ring.
              ProgressRing(
                progress: completion,
                color: rank.primaryColor,
                size: 44,
                strokeWidth: 3,
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withAlpha(100),
              ),
            ],
          ),
        ),
      ),
    );

    // Glow effect for current belt.
    if (isCurrent) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: rank.primaryColor.withAlpha(60),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: card,
      );
    }

    return card;
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => BeltDetailScreen(rank: rank),
      ),
    );
  }
}
