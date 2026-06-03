import 'package:flutter/material.dart';

import '../../models/belt_rank.dart';
import '../../theme/dojo_colors.dart';

/// Second screen of the onboarding flow.
///
/// Shows a scrollable list of all 11 IKO-1 belt ranks. Each belt displays
/// a color swatch (with stripe if applicable), rank name, and Japanese name.
/// "I'm brand new" maps to [BeltRank.kyu10].
///
/// [onBeltSelected] is called with the chosen [BeltRank] when the user
/// taps "Continue".
class BeltSelectionScreen extends StatefulWidget {
  /// Creates a [BeltSelectionScreen].
  ///
  /// [onBeltSelected] fires when the user confirms their belt selection.
  const BeltSelectionScreen({required this.onBeltSelected, super.key});

  /// Callback with the selected [BeltRank].
  final ValueChanged<BeltRank> onBeltSelected;

  @override
  State<BeltSelectionScreen> createState() => _BeltSelectionScreenState();
}

class _BeltSelectionScreenState extends State<BeltSelectionScreen> {
  BeltRank? _selectedRank;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text(
                "What's your current belt?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: BeltRank.values.length,
                itemBuilder: (context, index) {
                  final rank = BeltRank.values[index];
                  final isSelected = _selectedRank == rank;
                  return _BeltOption(
                    rank: rank,
                    isFirst: index == 0,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedRank = rank),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Based on IKO-1 syllabus. Requirements may vary by dojo.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(153),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _selectedRank != null
                      ? () => widget.onBeltSelected(_selectedRank!)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: DojoColors.secondaryLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single belt option row in the selection list.
class _BeltOption extends StatelessWidget {
  const _BeltOption({
    required this.rank,
    required this.isFirst,
    required this.isSelected,
    required this.onTap,
  });

  final BeltRank rank;
  final bool isFirst;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primary.withAlpha(26)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withAlpha(31),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                _BeltSwatch(rank: rank),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isFirst
                            ? "I'm brand new"
                            : '${rank.displayName} — ${rank.colorDescription} Belt',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        rank.japaneseName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: theme.colorScheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A visual swatch showing the belt color, with stripe if applicable.
class _BeltSwatch extends StatelessWidget {
  const _BeltSwatch({required this.rank});

  final BeltRank rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 24,
      decoration: BoxDecoration(
        color: rank.primaryColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black26, width: 0.5),
      ),
      child: rank.hasStripe
          ? Center(
              child: Container(width: 48, height: 6, color: rank.stripeColor),
            )
          : null,
    );
  }
}
