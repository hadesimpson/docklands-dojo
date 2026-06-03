import 'package:docklands_dojo/theme/dojo_colors.dart';
import 'package:docklands_dojo/theme/dojo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DojoTheme', () {
    group('light()', () {
      late ThemeData theme;

      setUp(() {
        theme = DojoTheme.light();
      });

      test('uses Material 3', () {
        expect(theme.useMaterial3, isTrue);
      });

      test('has correct primary color', () {
        expect(theme.colorScheme.primary, equals(DojoColors.primaryLight));
      });

      test('has correct secondary color (Kyokushin Red)', () {
        expect(theme.colorScheme.secondary, equals(DojoColors.secondaryLight));
      });

      test('has correct tertiary color (Gold)', () {
        expect(theme.colorScheme.tertiary, equals(DojoColors.tertiaryLight));
      });

      test('has correct surface color (Rice Paper)', () {
        expect(theme.colorScheme.surface, equals(DojoColors.surfaceLight));
      });

      test('has correct error color', () {
        expect(theme.colorScheme.error, equals(DojoColors.errorLight));
      });

      test('brightness is light', () {
        expect(theme.colorScheme.brightness, equals(Brightness.light));
      });
    });

    group('dark()', () {
      late ThemeData theme;

      setUp(() {
        theme = DojoTheme.dark();
      });

      test('uses Material 3', () {
        expect(theme.useMaterial3, isTrue);
      });

      test('has correct primary color', () {
        expect(theme.colorScheme.primary, equals(DojoColors.primaryDark));
      });

      test('has correct secondary color (Soft Red)', () {
        expect(theme.colorScheme.secondary, equals(DojoColors.secondaryDark));
      });

      test('has correct tertiary color (Bright Gold)', () {
        expect(theme.colorScheme.tertiary, equals(DojoColors.tertiaryDark));
      });

      test('has correct surface color (Dark Navy)', () {
        expect(theme.colorScheme.surface, equals(DojoColors.surfaceDark));
      });

      test('has correct error color', () {
        expect(theme.colorScheme.error, equals(DojoColors.errorDark));
      });

      test('brightness is dark', () {
        expect(theme.colorScheme.brightness, equals(Brightness.dark));
      });
    });
  });

  group('DojoColors', () {
    group('IKO-1 belt colors', () {
      test('white belt is #FFFFFF', () {
        expect(DojoColors.beltWhite, equals(const Color(0xFFFFFFFF)));
      });

      test('orange belt is #FF8C00', () {
        expect(DojoColors.beltOrange, equals(const Color(0xFFFF8C00)));
      });

      test('blue belt is #0047AB', () {
        expect(DojoColors.beltBlue, equals(const Color(0xFF0047AB)));
      });

      test('yellow belt is #FFD700', () {
        expect(DojoColors.beltYellow, equals(const Color(0xFFFFD700)));
      });

      test('green belt is #228B22', () {
        expect(DojoColors.beltGreen, equals(const Color(0xFF228B22)));
      });

      test('brown belt is #8B4513', () {
        expect(DojoColors.beltBrown, equals(const Color(0xFF8B4513)));
      });

      test('black belt is #1A1A1A', () {
        expect(DojoColors.beltBlack, equals(const Color(0xFF1A1A1A)));
      });
    });

    group('IKO-1 stripe colors', () {
      test('kyu8 stripe is blue (#0047AB)', () {
        expect(DojoColors.stripeBlue, equals(const Color(0xFF0047AB)));
      });

      test('kyu6 stripe is yellow (#FFD700)', () {
        expect(DojoColors.stripeYellow, equals(const Color(0xFFFFD700)));
      });

      test('kyu4 stripe is green (#228B22)', () {
        expect(DojoColors.stripeGreen, equals(const Color(0xFF228B22)));
      });

      test('stripe colors match their corresponding belt colors', () {
        expect(DojoColors.stripeBlue, equals(DojoColors.beltBlue));
        expect(DojoColors.stripeYellow, equals(DojoColors.beltYellow));
        expect(DojoColors.stripeGreen, equals(DojoColors.beltGreen));
      });
    });

    group('theme color pairs', () {
      test('light and dark primary are different', () {
        expect(DojoColors.primaryLight, isNot(equals(DojoColors.primaryDark)));
      });

      test('light and dark surface are different', () {
        expect(DojoColors.surfaceLight, isNot(equals(DojoColors.surfaceDark)));
      });
    });
  });
}
