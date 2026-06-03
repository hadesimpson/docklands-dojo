import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An animated flashcard widget that flips between front and back content.
///
/// Uses a 3D rotation transform around the Y-axis. Tapping the card
/// triggers the flip animation. The [onFlip] callback is invoked
/// after the flip completes.
///
/// ```dart
/// FlashcardWidget(
///   front: Text('What is "Osu"?'),
///   back: Text('A greeting meaning respect'),
///   isFlipped: false,
///   onFlip: () => setState(() => flipped = !flipped),
/// )
/// ```
class FlashcardWidget extends StatefulWidget {
  /// The widget displayed on the front of the card.
  final Widget front;

  /// The widget displayed on the back of the card.
  final Widget back;

  /// Whether the card is currently showing its back.
  final bool isFlipped;

  /// Called when the card is tapped to flip.
  final VoidCallback onFlip;

  /// Creates a [FlashcardWidget].
  const FlashcardWidget({
    required this.front,
    required this.back,
    required this.isFlipped,
    required this.onFlip,
    super.key,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _showFront = !widget.isFlipped;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      // Swap front/back at the midpoint of the animation.
      if (_controller.value >= 0.5 && _showFront == !widget.isFlipped) {
        setState(() {
          _showFront = widget.isFlipped;
        });
      } else if (_controller.value < 0.5 && _showFront == widget.isFlipped) {
        setState(() {
          _showFront = !widget.isFlipped;
        });
      }
    });
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onFlip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: _buildCardContent(theme, angle),
          );
        },
      ),
    );
  }

  Widget _buildCardContent(ThemeData theme, double angle) {
    // When angle > π/2, we're looking at the back — mirror it.
    final isBack = angle > math.pi / 2;

    return Transform(
      alignment: Alignment.center,
      transform: isBack ? (Matrix4.identity()..rotateY(math.pi)) : Matrix4.identity(),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 250),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _showFront
                  ? [
                      theme.colorScheme.surface,
                      theme.colorScheme.surface,
                    ]
                  : [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.secondaryContainer,
                    ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_showFront) ...[
                Icon(
                  Icons.help_outline,
                  size: 32,
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                widget.front,
                const SizedBox(height: 24),
                Text(
                  'Tap to reveal',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ] else ...[
                Icon(
                  Icons.check_circle_outline,
                  size: 32,
                  color: theme.colorScheme.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 16),
                widget.back,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
