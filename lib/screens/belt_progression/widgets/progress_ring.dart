import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A circular progress indicator rendered in a custom color.
///
/// Displays a ring showing [progress] from 0.0 to 1.0, with the
/// percentage label in the center. Used to show belt requirement
/// completion status.
///
/// ```dart
/// ProgressRing(
///   progress: 0.75,
///   color: BeltRank.kyu9.primaryColor,
///   size: 56,
/// )
/// ```
class ProgressRing extends StatelessWidget {
  /// Completion ratio from 0.0 (empty) to 1.0 (complete).
  final double progress;

  /// Color of the progress arc.
  final Color color;

  /// Diameter of the ring in logical pixels.
  final double size;

  /// Stroke width of the ring.
  final double strokeWidth;

  /// Whether to show the percentage label in the center.
  final bool showLabel;

  /// Creates a [ProgressRing] with the given parameters.
  const ProgressRing({
    required this.progress,
    required this.color,
    this.size = 56,
    this.strokeWidth = 4,
    this.showLabel = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percentage = (clampedProgress * 100).round();

    return Semantics(
      label: '$percentage percent complete',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(size, size),
              painter: _ProgressRingPainter(
                progress: clampedProgress,
                color: color,
                backgroundColor: theme.colorScheme.surfaceContainerHighest
                    .withAlpha(100),
                strokeWidth: strokeWidth,
              ),
            ),
            if (showLabel)
              Text(
                '$percentage%',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.22,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the progress ring arc.
class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = backgroundColor
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color
      ..strokeCap = StrokeCap.round;

    // Draw background circle.
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc (starting from top, clockwise).
    if (progress > 0) {
      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // Start from top
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      color != oldDelegate.color ||
      backgroundColor != oldDelegate.backgroundColor ||
      strokeWidth != oldDelegate.strokeWidth;
}
