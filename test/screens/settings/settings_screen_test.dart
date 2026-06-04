import 'package:docklands_dojo/providers/theme_provider.dart';
import 'package:docklands_dojo/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsScreen', () {
    Widget buildSubject({ThemeMode initialMode = ThemeMode.system}) {
      return ProviderScope(
        overrides: [themeModeProvider.overrideWith((ref) => initialMode)],
        child: const MaterialApp(home: SettingsScreen()),
      );
    }

    testWidgets('renders all sections', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Data'), findsOneWidget);
    });

    testWidgets('renders theme toggle with system, light, dark options', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('System'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('renders about section with app info', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Scroll to about section.
      await tester.scrollUntilVisible(
        find.text('About'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Docklands Dojo'), findsWidgets);
      expect(find.text('Version 1.0.0'), findsOneWidget);
      expect(
        find.textContaining('Kyokushin Karate Training Companion'),
        findsOneWidget,
      );
    });

    testWidgets('displays IKO-1 disclaimer', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Scroll to about section.
      await tester.scrollUntilVisible(
        find.textContaining('IKO-1'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('IKO-1'), findsOneWidget);
      expect(find.textContaining('Details may vary'), findsOneWidget);
    });

    testWidgets('shows export/import link', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Export & Import'), findsOneWidget);
      expect(find.text('Transfer your progress'), findsOneWidget);
    });

    testWidgets('segmented button shows current theme mode', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Should find the SegmentedButton widget.
      expect(find.byType(SegmentedButton<ThemeMode>), findsOneWidget);
    });

    testWidgets('selecting dark mode updates theme provider', (tester) async {
      late ThemeMode capturedMode;

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, child) {
              capturedMode = ref.watch(themeModeProvider);
              return MaterialApp(
                home: const SettingsScreen(),
                theme: ThemeData.light(),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap "Dark".
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(capturedMode, ThemeMode.dark);
    });

    testWidgets('selecting light mode updates theme provider', (tester) async {
      late ThemeMode capturedMode;

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, child) {
              capturedMode = ref.watch(themeModeProvider);
              return MaterialApp(
                home: const SettingsScreen(),
                theme: ThemeData.light(),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap "Light".
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      expect(capturedMode, ThemeMode.light);
    });
  });
}
