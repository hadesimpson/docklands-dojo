import 'package:flutter/material.dart';

/// Reusable dashboard card widget for the home screen.
///
/// Provides a consistent card layout with icon, title, subtitle,
/// and optional trailing content. Used for "Due for review",
/// "Quick Quiz", "Next Belt", and similar dashboard sections.
///
/// ```dart
/// DashboardCard(
///   icon: Icons.school,
///   title: 'Due for Review',
///   subtitle: '5 cards due today',
///   trailing: Text('5'),
///   onTap: () => navigateToReview(),
/// )
/// ```
class DashboardCard extends StatelessWidget {
  /// Icon displayed at the leading edge.
  final IconData icon;

  /// Primary title text.
  final String title;

  /// Subtitle text shown below the title.
  final String subtitle;

  /// Optional trailing widget (e.g., count badge, arrow icon).
  final Widget? trailing;

  /// Callback invoked when the card is tapped.
  final VoidCallback? onTap;

  /// Optional icon color override.
  final Color? iconColor;

  /// Creates a [DashboardCard].
  const DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '$title: $subtitle',
      button: onTap != null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (iconColor ?? theme.colorScheme.primary).withAlpha(
                      25,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ),
                ?trailing,
                if (onTap != null)
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurface.withAlpha(102),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
