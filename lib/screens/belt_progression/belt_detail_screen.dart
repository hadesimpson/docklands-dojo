import 'package:docklands_dojo/data/syllabus_data.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/belt_requirement.dart';
import 'package:docklands_dojo/providers/progress_providers.dart';
import 'package:docklands_dojo/screens/belt_progression/widgets/progress_ring.dart';
import 'package:docklands_dojo/widgets/belt_color_swatch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detailed view for a single belt rank's requirements.
///
/// Displays the belt's color swatch header with completion percentage,
/// and tabbed content for each requirement category:
/// - **Kihon** — Basic techniques with checkboxes
/// - **Kata** — Required kata with checkboxes
/// - **Kumite** — Sparring requirements (read-only)
/// - **Fitness** — Fitness standards (read-only)
/// - **Terminology** — Required terminology (read-only)
///
/// Technique checkboxes persist via [CurrentProgressNotifier.markTechniqueCompleted].
///
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => BeltDetailScreen(rank: BeltRank.kyu9),
///   ),
/// );
/// ```
class BeltDetailScreen extends ConsumerWidget {
  /// The belt rank to show details for.
  final BeltRank rank;

  /// Creates a [BeltDetailScreen] for the given [rank].
  const BeltDetailScreen({required this.rank, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requirement = _getRequirement(rank);
    final progressAsync = ref.watch(currentProgressProvider);
    final completionAsync = ref.watch(completionPercentageProvider(rank));

    if (requirement == null) {
      return Scaffold(
        appBar: AppBar(title: Text(rank.displayName)),
        body: const Center(child: Text('No requirements found for this rank.')),
      );
    }

    return progressAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(rank.displayName)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(rank.displayName)),
        body: Center(
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
      ),
      data: (progress) {
        final completedTechniques = progress?.completedTechniques ?? {};
        final completion = completionAsync.valueOrNull ?? 0.0;

        return _BeltDetailContent(
          rank: rank,
          requirement: requirement,
          completedTechniques: completedTechniques,
          completion: completion,
        );
      },
    );
  }

  /// Looks up the [BeltRequirement] for the given [rank].
  BeltRequirement? _getRequirement(BeltRank rank) {
    for (final req in allBeltRequirements) {
      if (req.rank == rank) return req;
    }
    return null;
  }
}

/// Internal stateful content widget for the belt detail screen.
class _BeltDetailContent extends ConsumerWidget {
  final BeltRank rank;
  final BeltRequirement requirement;
  final Map<String, bool> completedTechniques;
  final double completion;

  const _BeltDetailContent({
    required this.rank,
    required this.requirement,
    required this.completedTechniques,
    required this.completion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Build tab list dynamically based on available content.
    final tabs = <_TabData>[];

    if (requirement.requiredKihon.isNotEmpty) {
      tabs.add(_TabData(label: 'Kihon', icon: Icons.sports_martial_arts));
    }

    if (requirement.requiredKata.isNotEmpty) {
      tabs.add(_TabData(label: 'Kata', icon: Icons.self_improvement));
    }

    if (requirement.kumiteRequirements.isNotEmpty) {
      tabs.add(_TabData(label: 'Kumite', icon: Icons.people));
    }

    if (requirement.fitnessRequirements.isNotEmpty) {
      tabs.add(_TabData(label: 'Fitness', icon: Icons.fitness_center));
    }

    if (requirement.terminology.isNotEmpty) {
      tabs.add(_TabData(label: 'Terms', icon: Icons.translate));
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(rank.displayName),
          bottom: tabs.length > 1
              ? TabBar(
                  isScrollable: tabs.length > 4,
                  tabs: tabs
                      .map(
                        (t) => Tab(text: t.label, icon: Icon(t.icon, size: 20)),
                      )
                      .toList(),
                )
              : null,
        ),
        body: Column(
          children: [
            // Belt header with swatch and completion.
            _BeltHeader(
              rank: rank,
              requirement: requirement,
              completion: completion,
            ),
            // Tab content.
            Expanded(
              child: TabBarView(
                children: tabs.map((tab) {
                  switch (tab.label) {
                    case 'Kihon':
                      return _KihonTab(
                        techniques: requirement.requiredKihon,
                        completedTechniques: completedTechniques,
                        ref: ref,
                      );
                    case 'Kata':
                      return _KataTab(
                        kata: requirement.requiredKata,
                        completedTechniques: completedTechniques,
                        ref: ref,
                      );
                    case 'Kumite':
                      return _KumiteTab(requirement: requirement);
                    case 'Fitness':
                      return _FitnessTab(requirement: requirement);
                    case 'Terms':
                      return _TerminologyTab(requirement: requirement);
                    default:
                      return const SizedBox.shrink();
                  }
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data for a tab in the belt detail screen.
class _TabData {
  final String label;
  final IconData icon;

  const _TabData({required this.label, required this.icon});
}

/// Header showing the belt color swatch, name, and completion ring.
class _BeltHeader extends StatelessWidget {
  final BeltRank rank;
  final BeltRequirement requirement;
  final double completion;

  const _BeltHeader({
    required this.rank,
    required this.requirement,
    required this.completion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (completion * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Belt color swatch.
          SizedBox(
            width: 80,
            height: 56,
            child: BeltColorSwatch(
              primaryColor: rank.primaryColor,
              stripeColor: rank.stripeColor,
              label: rank.colorDescription,
            ),
          ),
          const SizedBox(width: 16),
          // Belt info.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${rank.displayName} — ${rank.japaneseName}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${rank.colorDescription} Belt',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(150),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$percentage% complete',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: completion >= 1.0
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withAlpha(180),
                    fontWeight: completion >= 1.0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          // Progress ring.
          ProgressRing(
            progress: completion,
            color: rank.primaryColor,
            size: 56,
            strokeWidth: 4,
          ),
        ],
      ),
    );
  }
}

/// Tab showing kihon (basic technique) requirements with checkboxes.
class _KihonTab extends StatelessWidget {
  final List<String> techniques;
  final Map<String, bool> completedTechniques;
  final WidgetRef ref;

  const _KihonTab({
    required this.techniques,
    required this.completedTechniques,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: techniques.length,
      itemBuilder: (context, index) {
        final techniqueId = techniques[index];
        final isCompleted = completedTechniques[techniqueId] == true;

        return _TechniqueCheckboxTile(
          techniqueId: techniqueId,
          isCompleted: isCompleted,
          onChanged: (value) => _toggleTechnique(techniqueId, value),
        );
      },
    );
  }

  void _toggleTechnique(String techniqueId, bool? value) {
    if (value == true) {
      ref
          .read(currentProgressProvider.notifier)
          .markTechniqueCompleted(techniqueId);
    }
  }
}

/// Tab showing kata requirements with checkboxes.
class _KataTab extends StatelessWidget {
  final List<String> kata;
  final Map<String, bool> completedTechniques;
  final WidgetRef ref;

  const _KataTab({
    required this.kata,
    required this.completedTechniques,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: kata.length,
      itemBuilder: (context, index) {
        final kataId = kata[index];
        final isCompleted = completedTechniques[kataId] == true;

        return _TechniqueCheckboxTile(
          techniqueId: kataId,
          isCompleted: isCompleted,
          onChanged: (value) => _toggleKata(kataId, value),
        );
      },
    );
  }

  void _toggleKata(String kataId, bool? value) {
    if (value == true) {
      ref.read(currentProgressProvider.notifier).markTechniqueCompleted(kataId);
    }
  }
}

/// Tab showing kumite (sparring) requirements.
class _KumiteTab extends StatelessWidget {
  final BeltRequirement requirement;

  const _KumiteTab({required this.requirement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (requirement.kumiteRequirements.isEmpty) {
      return const Center(child: Text('No kumite requirements for this belt.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requirement.kumiteRequirements.length,
      itemBuilder: (context, index) {
        final kumite = requirement.kumiteRequirements[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      kumite.type.name.toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(kumite.description, style: theme.textTheme.bodyMedium),
                if (kumite.rounds != null || kumite.roundDuration != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (kumite.rounds != null) ...[
                        Chip(
                          avatar: const Icon(Icons.repeat, size: 16),
                          label: Text('${kumite.rounds} rounds'),
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (kumite.roundDuration != null)
                        Chip(
                          avatar: const Icon(Icons.timer, size: 16),
                          label: Text(_formatDuration(kumite.roundDuration!)),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (seconds == 0) return '$minutes min';
    return '$minutes:${seconds.toString().padLeft(2, '0')} min';
  }
}

/// Tab showing fitness requirements.
class _FitnessTab extends StatelessWidget {
  final BeltRequirement requirement;

  const _FitnessTab({required this.requirement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (requirement.fitnessRequirements.isEmpty) {
      return const Center(
        child: Text('No fitness requirements for this belt.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requirement.fitnessRequirements.length,
      itemBuilder: (context, index) {
        final fitness = requirement.fitnessRequirements[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.fitness_center,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(fitness.exerciseName),
            subtitle: fitness.notes != null ? Text(fitness.notes!) : null,
            trailing: Text(
              '${fitness.targetCount} ${fitness.unit ?? 'reps'}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Tab showing terminology requirements.
class _TerminologyTab extends StatelessWidget {
  final BeltRequirement requirement;

  const _TerminologyTab({required this.requirement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (requirement.terminology.isEmpty) {
      return const Center(
        child: Text('No terminology requirements for this belt.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requirement.terminology.length,
      itemBuilder: (context, index) {
        final term = requirement.terminology[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.tertiaryContainer,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: theme.colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(term),
          ),
        );
      },
    );
  }
}

/// Checkbox tile for a technique or kata requirement.
class _TechniqueCheckboxTile extends StatelessWidget {
  final String techniqueId;
  final bool isCompleted;
  final ValueChanged<bool?> onChanged;

  const _TechniqueCheckboxTile({
    required this.techniqueId,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = _formatTechniqueId(techniqueId);

    return CheckboxListTile(
      value: isCompleted,
      onChanged: isCompleted ? null : onChanged,
      title: Text(
        displayName,
        style: theme.textTheme.bodyMedium?.copyWith(
          decoration: isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: isCompleted
              ? theme.colorScheme.onSurface.withAlpha(120)
              : theme.colorScheme.onSurface,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }

  /// Converts a technique ID (e.g., 'seiken_chudan_tsuki') to a
  /// human-readable name ('Seiken Chudan Tsuki').
  String _formatTechniqueId(String id) {
    return id
        .split('_')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}
