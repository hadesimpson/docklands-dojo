import 'package:flutter/material.dart';

/// Color constants for the Dojo design system.
///
/// Contains all belt colors (IKO-1 correct) and UI theme colors.
/// Belt colors include stripe colors for kyu8, kyu6, and kyu4.
///
/// See PRD Section 4 — Design System: "Dojo" Theme.
class DojoColors {
  DojoColors._();

  // ── UI Theme Colors (Light) ──────────────────────────────────────────────

  /// Deep Navy — discipline, depth.
  static const Color primaryLight = Color(0xFF1A1A2E);

  /// Kyokushin Red — the kanku mark red.
  static const Color secondaryLight = Color(0xFFC41E3A);

  /// Gold — achievement.
  static const Color tertiaryLight = Color(0xFFD4AF37);

  /// Rice Paper — clean feel.
  static const Color surfaceLight = Color(0xFFF5F5F0);

  /// Ink Black — readability.
  static const Color onSurfaceLight = Color(0xFF2D2D2D);

  /// Sky Blue — focus.
  static const Color accentLight = Color(0xFF4A90D9);

  /// Standard Material error.
  static const Color errorLight = Color(0xFFB00020);

  // ── UI Theme Colors (Dark) ───────────────────────────────────────────────

  /// Soft White — discipline, depth (inverted).
  static const Color primaryDark = Color(0xFFE8E8F0);

  /// Soft Red — the kanku mark red (dark mode).
  static const Color secondaryDark = Color(0xFFE85A6F);

  /// Bright Gold — achievement (dark mode).
  static const Color tertiaryDark = Color(0xFFF0D060);

  /// Dark Navy — clean feel (dark mode).
  static const Color surfaceDark = Color(0xFF1E1E2E);

  /// Light Gray — readability (dark mode).
  static const Color onSurfaceDark = Color(0xFFE0E0E0);

  /// Bright Blue — focus (dark mode).
  static const Color accentDark = Color(0xFF6AACF0);

  /// Standard Material error (dark mode).
  static const Color errorDark = Color(0xFFCF6679);

  // ── Belt Colors (IKO-1 Standard) ─────────────────────────────────────────

  /// 10th Kyu — White Belt.
  static const Color beltWhite = Color(0xFFFFFFFF);

  /// 9th Kyu — Orange Belt.
  static const Color beltOrange = Color(0xFFFF8C00);

  /// 7th Kyu — Blue Belt. Also stripe color for 8th Kyu.
  static const Color beltBlue = Color(0xFF0047AB);

  /// 5th Kyu — Yellow Belt. Also stripe color for 6th Kyu.
  static const Color beltYellow = Color(0xFFFFD700);

  /// 3rd Kyu — Green Belt. Also stripe color for 4th Kyu.
  static const Color beltGreen = Color(0xFF228B22);

  /// 2nd & 1st Kyu — Brown Belt.
  static const Color beltBrown = Color(0xFF8B4513);

  /// Shodan — Black Belt (1st Dan).
  static const Color beltBlack = Color(0xFF1A1A1A);

  // ── Stripe Colors (IKO-1 Standard) ───────────────────────────────────────

  /// 8th Kyu stripe — Blue stripe on Orange belt.
  static const Color stripeBlue = beltBlue;

  /// 6th Kyu stripe — Yellow stripe on Blue belt.
  static const Color stripeYellow = beltYellow;

  /// 4th Kyu stripe — Green stripe on Yellow belt.
  static const Color stripeGreen = beltGreen;
}
