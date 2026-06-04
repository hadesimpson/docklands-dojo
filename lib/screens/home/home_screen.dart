import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/user_progress.dart';
import 'package:docklands_dojo/providers/progress_providers.dart';
import 'package:docklands_dojo/screens/home/dashboard_card.dart';
import 'package:docklands_dojo/widgets/belt_color_swatch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The home screen dashboard — the app's daily landing page.
///
/// Displays:
/// - Welcome header with current belt color swatch
/// - "Due for review" card with count of due flashcards
/// - "Quick Quiz" card to start quiz for current belt
/// - "Next Belt" progress card with completion percentage
/// - Navigation entry points to key features
///
/// All data is loaded reactively via Riverpod providers.
class HomeScreen extends ConsumerWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progressAsync = ref.watch(currentProgressProvider);

    return Scaffold(
      body: SafeArea(
        child: progressAsync.when(
          data: (progress) => _buildDashboard(context, ref, theme, progress),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _buildErrorState(context, ref, theme, error),
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    UserProgress? progress,
  ) {
    final currentRank = progress?.currentRank ?? BeltRank.kyu10;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome header.
          _buildWelcomeHeader(theme, currentRank),
          const SizedBox(height: 24),

          // Due for review card.
          DashboardCard(
            icon: Icons.style,
            title: 'Due for Review',
            subtitle: 'Tap to start flashcard review',
            iconColor: theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 8),

          // Quick quiz card.
          DashboardCard(
            icon: Icons.quiz,
            title: 'Quick Quiz',
            subtitle: 'Test your knowledge for ${currentRank.displayName}',
            iconColor: theme.colorScheme.secondary,
          ),
          const SizedBox(height: 8),

          // Next belt progress card.
          _buildNextBeltCard(context, ref, theme, currentRank),
          const SizedBox(height: 24),

          // Quick actions section.
          Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          const DashboardCard(
            icon: Icons.military_tech,
            title: 'Belt Progression',
            subtitle: 'View all belt requirements',
          ),
          const SizedBox(height: 8),

          const DashboardCard(
            icon: Icons.book,
            title: 'Technique Library',
            subtitle: 'Browse all techniques',
          ),
          const SizedBox(height: 8),

          DashboardCard(
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'Theme, export/import, about',
            iconColor: theme.colorScheme.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(ThemeData theme, BeltRank currentRank) {
    return Semantics(
      label:
          'Welcome header. Current rank: ${currentRank.displayName}, '
          '${currentRank.colorDescription} belt',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Osu! 🥋',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Welcome to Docklands Dojo',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(179),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: BeltColorSwatch(
                  primaryColor: currentRank.primaryColor,
                  stripeColor: currentRank.stripeColor,
                  label: currentRank.colorDescription,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentRank.displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currentRank.japaneseName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextBeltCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    BeltRank currentRank,
  ) {
    // Find the next belt rank.
    final currentOrder = currentRank.order;
    final nextRank = BeltRank.values.where((r) => r.order > currentOrder);

    if (nextRank.isEmpty) {
      return DashboardCard(
        icon: Icons.emoji_events,
        title: 'Shodan Achieved!',
        subtitle: 'You have reached the highest tracked rank',
        iconColor: theme.colorScheme.tertiary,
      );
    }

    final next = nextRank.first;
    final completionAsync = ref.watch(completionPercentageProvider(next));
    final percentText = completionAsync.when(
      data: (pct) => '${(pct * 100).toStringAsFixed(0)}% complete',
      loading: () => 'Loading...',
      error: (_, _) => 'Unable to load',
    );

    return DashboardCard(
      icon: Icons.trending_up,
      title: 'Next: ${next.displayName}',
      subtitle: percentText,
      iconColor: theme.colorScheme.tertiary,
      trailing: completionAsync.when(
        data: (pct) => SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            value: pct,
            strokeWidth: 3,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            color: theme.colorScheme.tertiary,
          ),
        ),
        loading: () => const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (_, _) => const Icon(Icons.error_outline, size: 20),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    Object error,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Unable to load dashboard',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ref.invalidate(currentProgressProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
