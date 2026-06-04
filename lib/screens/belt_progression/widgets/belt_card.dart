import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:flutter/material.dart';

/// A card widget that renders a belt rank with correct IKO-1 colors.
///
/// Supports two-tone stripe rendering for kyu8, kyu6, and kyu4 belts.
/// Each card includes a text label (e.g., "Orange w/ Blue Stripe") for
/// accessibility compliance per PRD §4.
///
/// The [size] parameter controls rendering dimensions:
/// - [BeltCardSize.small] — compact for list items (height: 24)
/// - [BeltCardSize.large] — prominent for detail headers (height: 48)
///
/// ```dart
/// BeltCard(
///   rank: BeltRank.kyu8,
///   size: BeltCardSize.small,
///   showLabel: true,
/// )
/// ```
class BeltCard extends StatelessWidget {
  /// The belt rank to render.
  final BeltRank rank;

  /// Size variant for the belt swatch rendering.
  final BeltCardSize size;

  /// Whether to show the text label below the swatch.
  final bool showLabel;

  /// Creates a [BeltCard] for the given [rank].
  const BeltCard({
    required this.rank,
    this.size = BeltCardSize.small,
    this.showLabel = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = size == BeltCardSize.small ? 24.0 : 48.0;
    final borderRadius = BorderRadius.circular(4);

    return Semantics(
      label: '${rank.colorDescription} Belt',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: _needsBorder(rank, theme)
                  ? Border.all(color: theme.colorScheme.outline, width: 0.5)
                  : null,
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: CustomPaint(
                painter: _BeltPainter(
                  primaryColor: rank.primaryColor,
                  stripeColor: rank.stripeColor,
                ),
              ),
            ),
          ),
          if (showLabel) ...[
            const SizedBox(height: 4),
            Text(
              rank.colorDescription,
              style: theme.textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// White and yellow belts need a border for visibility on light surfaces.
  bool _needsBorder(BeltRank rank, ThemeData theme) {
    if (theme.brightness == Brightness.dark) return false;
    return rank == BeltRank.kyu10 ||
        rank == BeltRank.kyu5 ||
        rank == BeltRank.kyu4;
  }
}

/// Size variants for [BeltCard] rendering.
enum BeltCardSize {
  /// Compact variant for list items (height: 24).
  small,

  /// Prominent variant for detail headers (height: 48).
  large,
}

/// Custom painter that renders a belt with an optional stripe.
///
/// For striped belts, draws a horizontal band through the center
/// of the belt at 1/4 of the total height.
class _BeltPainter extends CustomPainter {
  final Color primaryColor;
  final Color? stripeColor;

  _BeltPainter({required this.primaryColor, this.stripeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = primaryColor;

    // Draw primary belt color.
    canvas.drawRect(Offset.zero & size, paint);

    // Draw stripe if applicable.
    if (stripeColor != null) {
      paint.color = stripeColor!;
      final stripeHeight = size.height * 0.25;
      final stripeTop = (size.height - stripeHeight) / 2;
      canvas.drawRect(
        Rect.fromLTWH(0, stripeTop, size.width, stripeHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BeltPainter oldDelegate) =>
      primaryColor != oldDelegate.primaryColor ||
      stripeColor != oldDelegate.stripeColor;
}
