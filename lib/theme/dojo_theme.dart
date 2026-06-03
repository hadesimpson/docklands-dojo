import 'package:flutter/material.dart';

import 'dojo_colors.dart';

/// Material 3 theme for Docklands Dojo.
///
/// Provides [light] and [dark] static methods that return complete
/// [ThemeData] instances configured with the Dojo design system.
///
/// See PRD Section 4 — Design System: "Dojo" Theme.
class DojoTheme {
  DojoTheme._();

  /// Border radius used across the app — soft, modern feel.
  static const double borderRadius = 12.0;

  /// Creates the light theme for Docklands Dojo.
  ///
  /// Uses Deep Navy primary, Kyokushin Red secondary, Gold tertiary,
  /// and Rice Paper surfaces for a clean martial arts aesthetic.
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: DojoColors.primaryLight,
      onPrimary: Colors.white,
      secondary: DojoColors.secondaryLight,
      onSecondary: Colors.white,
      tertiary: DojoColors.tertiaryLight,
      onTertiary: Colors.white,
      error: DojoColors.errorLight,
      onError: Colors.white,
      surface: DojoColors.surfaceLight,
      onSurface: DojoColors.onSurfaceLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: DojoColors.surfaceLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: DojoColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Creates the dark theme for Docklands Dojo.
  ///
  /// Uses Soft White primary, Soft Red secondary, Bright Gold tertiary,
  /// and Dark Navy surfaces for comfortable nighttime training review.
  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: DojoColors.primaryDark,
      onPrimary: DojoColors.surfaceDark,
      secondary: DojoColors.secondaryDark,
      onSecondary: Colors.white,
      tertiary: DojoColors.tertiaryDark,
      onTertiary: DojoColors.surfaceDark,
      error: DojoColors.errorDark,
      onError: Colors.black,
      surface: DojoColors.surfaceDark,
      onSurface: DojoColors.onSurfaceDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: DojoColors.surfaceDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: DojoColors.surfaceDark,
        foregroundColor: DojoColors.onSurfaceDark,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
