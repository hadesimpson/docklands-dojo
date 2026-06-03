import 'package:docklands_dojo/theme/dojo_colors.dart';
import 'package:flutter/material.dart';

/// Belt ranks following the IKO-1 Kyokushin standard.
///
/// Ordered from beginner (10th Kyu / White) through to
/// Shodan (1st Dan / Black Belt). Some kyu grades have striped
/// belts requiring two-tone rendering.
///
/// ```dart
/// final rank = BeltRank.kyu8;
/// print(rank.colorDescription); // 'Orange with Blue stripe'
/// print(rank.hasStripe);        // true
/// ```
enum BeltRank {
  /// 10th Kyu — White Belt.
  kyu10,

  /// 9th Kyu — Orange Belt.
  kyu9,

  /// 8th Kyu — Orange Belt with Blue stripe.
  kyu8,

  /// 7th Kyu — Blue Belt.
  kyu7,

  /// 6th Kyu — Blue Belt with Yellow stripe.
  kyu6,

  /// 5th Kyu — Yellow Belt.
  kyu5,

  /// 4th Kyu — Yellow Belt with Green stripe.
  kyu4,

  /// 3rd Kyu — Green Belt.
  kyu3,

  /// 2nd Kyu — Brown Belt.
  kyu2,

  /// 1st Kyu — Brown Belt.
  kyu1,

  /// Shodan — Black Belt (1st Dan).
  shodan,
}

/// Extension providing display metadata for each [BeltRank].
///
/// Includes Japanese names, color information, and sorting order
/// following the IKO-1 Kyokushin standard.
extension BeltRankMetadata on BeltRank {
  /// Japanese name for this belt rank.
  ///
  /// Uses standard Japanese ordinal counting for kyu grades.
  String get japaneseName => switch (this) {
    BeltRank.kyu10 => 'Jūkyū',
    BeltRank.kyu9 => 'Kukyū',
    BeltRank.kyu8 => 'Hachikyū',
    BeltRank.kyu7 => 'Nanakyū',
    BeltRank.kyu6 => 'Rokkyū',
    BeltRank.kyu5 => 'Gokyū',
    BeltRank.kyu4 => 'Yonkyū',
    BeltRank.kyu3 => 'Sankyū',
    BeltRank.kyu2 => 'Nikyū',
    BeltRank.kyu1 => 'Ikkyū',
    BeltRank.shodan => 'Shodan',
  };

  /// Human-readable color description (e.g., 'Orange with Blue stripe').
  String get colorDescription => switch (this) {
    BeltRank.kyu10 => 'White',
    BeltRank.kyu9 => 'Orange',
    BeltRank.kyu8 => 'Orange with Blue stripe',
    BeltRank.kyu7 => 'Blue',
    BeltRank.kyu6 => 'Blue with Yellow stripe',
    BeltRank.kyu5 => 'Yellow',
    BeltRank.kyu4 => 'Yellow with Green stripe',
    BeltRank.kyu3 => 'Green',
    BeltRank.kyu2 => 'Brown',
    BeltRank.kyu1 => 'Brown',
    BeltRank.shodan => 'Black',
  };

  /// Display name for the belt rank (e.g., '10th Kyu', 'Shodan').
  String get displayName => switch (this) {
    BeltRank.kyu10 => '10th Kyu',
    BeltRank.kyu9 => '9th Kyu',
    BeltRank.kyu8 => '8th Kyu',
    BeltRank.kyu7 => '7th Kyu',
    BeltRank.kyu6 => '6th Kyu',
    BeltRank.kyu5 => '5th Kyu',
    BeltRank.kyu4 => '4th Kyu',
    BeltRank.kyu3 => '3rd Kyu',
    BeltRank.kyu2 => '2nd Kyu',
    BeltRank.kyu1 => '1st Kyu',
    BeltRank.shodan => 'Shodan',
  };

  /// Sorting order, 0 (lowest rank) through 10 (highest rank).
  int get order => switch (this) {
    BeltRank.kyu10 => 0,
    BeltRank.kyu9 => 1,
    BeltRank.kyu8 => 2,
    BeltRank.kyu7 => 3,
    BeltRank.kyu6 => 4,
    BeltRank.kyu5 => 5,
    BeltRank.kyu4 => 6,
    BeltRank.kyu3 => 7,
    BeltRank.kyu2 => 8,
    BeltRank.kyu1 => 9,
    BeltRank.shodan => 10,
  };

  /// Primary belt color from [DojoColors].
  Color get primaryColor => switch (this) {
    BeltRank.kyu10 => DojoColors.beltWhite,
    BeltRank.kyu9 => DojoColors.beltOrange,
    BeltRank.kyu8 => DojoColors.beltOrange,
    BeltRank.kyu7 => DojoColors.beltBlue,
    BeltRank.kyu6 => DojoColors.beltBlue,
    BeltRank.kyu5 => DojoColors.beltYellow,
    BeltRank.kyu4 => DojoColors.beltYellow,
    BeltRank.kyu3 => DojoColors.beltGreen,
    BeltRank.kyu2 => DojoColors.beltBrown,
    BeltRank.kyu1 => DojoColors.beltBrown,
    BeltRank.shodan => DojoColors.beltBlack,
  };

  /// Stripe color, if applicable. `null` for solid belts.
  Color? get stripeColor => switch (this) {
    BeltRank.kyu8 => DojoColors.stripeBlue,
    BeltRank.kyu6 => DojoColors.stripeYellow,
    BeltRank.kyu4 => DojoColors.stripeGreen,
    _ => null,
  };

  /// Whether this belt has a stripe (two-tone rendering required).
  bool get hasStripe => stripeColor != null;
}
