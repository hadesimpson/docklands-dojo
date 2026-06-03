import 'package:flutter/material.dart';

/// A reusable belt color swatch widget with stripe rendering.
///
/// Renders a horizontal band in the belt's [primaryColor] with an
/// optional [stripeColor] stripe through the center. Includes a
/// text [label] for accessibility compliance (WCAG — belt colors
/// alone are insufficient for identification).
///
/// Used throughout the app for belt rank identification:
/// - Belt list timeline items
/// - Belt detail headers
/// - Onboarding belt selection carousel
///
/// ```dart
/// BeltColorSwatch(
///   primaryColor: DojoColors.beltOrange,
///   stripeColor: DojoColors.stripeBlue,
///   label: 'Orange with Blue stripe',
/// )
/// ```
///
/// Stripe rendering uses [CustomPaint] with [_BeltSwatchPainter]
/// to draw the stripe at 25% of the total height, centered vertically.
class BeltColorSwatch extends StatelessWidget {
  /// The primary belt color.
  final Color primaryColor;

  /// Stripe color, if applicable. `null` for solid belts.
  final Color? stripeColor;

  /// Accessibility text label (e.g., 'Orange with Blue stripe').
  final String label;

  /// Whether to visually show the label below the swatch.
  final bool showLabel;

  /// Height of the swatch in logical pixels.
  final double height;

  /// Border radius of the swatch.
  final double borderRadius;

  /// Creates a [BeltColorSwatch] with the given parameters.
  const BeltColorSwatch({
    required this.primaryColor,
    required this.label,
    this.stripeColor,
    this.showLabel = true,
    this.height = 32,
    this.borderRadius = 4,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final needsBorder = _needsBorder(theme);
    final radius = BorderRadius.circular(borderRadius);

    return Semantics(
      label: '$label Belt',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: needsBorder
                  ? Border.all(color: theme.colorScheme.outline, width: 0.5)
                  : null,
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: CustomPaint(
                painter: _BeltSwatchPainter(
                  primaryColor: primaryColor,
                  stripeColor: stripeColor,
                ),
              ),
            ),
          ),
          if (showLabel) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// White and yellow belts need a border for visibility on light surfaces.
  bool _needsBorder(ThemeData theme) {
    if (theme.brightness == Brightness.dark) return false;
    // Check if the color is close to white or yellow (high luminance).
    final luminance = primaryColor.computeLuminance();
    return luminance > 0.7;
  }
}

/// Custom painter for belt swatch with optional stripe rendering.
///
/// Draws the [primaryColor] as a full rectangle, then overlays the
/// [stripeColor] (if present) as a horizontal band at 25% height,
/// centered vertically within the swatch.
class _BeltSwatchPainter extends CustomPainter {
  /// The primary belt color.
  final Color primaryColor;

  /// Optional stripe color drawn as a centered band.
  final Color? stripeColor;

  /// Creates a [_BeltSwatchPainter] with the given colors.
  _BeltSwatchPainter({required this.primaryColor, this.stripeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw primary belt color.
    paint.color = primaryColor;
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
  bool shouldRepaint(_BeltSwatchPainter oldDelegate) =>
      primaryColor != oldDelegate.primaryColor ||
      stripeColor != oldDelegate.stripeColor;
}
