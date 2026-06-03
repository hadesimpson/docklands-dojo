import 'package:flutter/material.dart';

import '../../theme/dojo_colors.dart';

/// First screen of the onboarding flow.
///
/// Displays the "Osu! 🥋" greeting, app name, and a brief tagline.
/// The "Get Started" button triggers [onGetStarted] to advance the flow.
class WelcomeScreen extends StatelessWidget {
  /// Creates a [WelcomeScreen].
  ///
  /// [onGetStarted] is called when the user taps the "Get Started" button.
  const WelcomeScreen({required this.onGetStarted, super.key});

  /// Callback invoked when the user taps "Get Started".
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Text(
                'Osu! 🥋',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Docklands Dojo',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your Kyokushin Karate training companion',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(179),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: onGetStarted,
                  style: FilledButton.styleFrom(
                    backgroundColor: DojoColors.secondaryLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
