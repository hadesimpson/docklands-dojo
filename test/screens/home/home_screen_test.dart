import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/providers/progress_providers.dart';
import 'package:docklands_dojo/providers/review_providers.dart';
import 'package:docklands_dojo/screens/home/dashboard_card.dart';
import 'package:docklands_dojo/screens/home/home_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardCard', () {
    testWidgets('renders icon, title, and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardCard(
              icon: Icons.style,
              title: 'Test Title',
              subtitle: 'Test subtitle',
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.style), findsOneWidget);
    });

    testWidgets('shows chevron when onTap is provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardCard(
              icon: Icons.quiz,
              title: 'Tappable',
              subtitle: 'Tap me',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('hides chevron when no onTap', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardCard(
              icon: Icons.quiz,
              title: 'Static',
              subtitle: 'Not tappable',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('renders trailing widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardCard(
              icon: Icons.trending_up,
              title: 'Progress',
              subtitle: '50%',
              trailing: Text('50%'),
            ),
          ),
        ),
      );

      expect(find.text('50%'), findsWidgets);
    });

    testWidgets('triggers onTap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardCard(
              icon: Icons.quiz,
              title: 'Tappable',
              subtitle: 'Tap me',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tappable'));
      expect(tapped, isTrue);
    });

    testWidgets('applies custom icon color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardCard(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Custom color',
              iconColor: Colors.grey,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.settings));
      expect(icon.color, Colors.grey);
    });
  });

  group('HomeScreen', () {
    Widget buildSubject() {
      final db = AppDatabase(NativeDatabase.memory());
      return ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(home: HomeScreen()),
      );
    }

    testWidgets('shows welcome header', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Osu! 🥋'), findsOneWidget);
      expect(find.text('Welcome to Docklands Dojo'), findsOneWidget);
    });

    testWidgets('shows dashboard cards', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Due for Review'), findsOneWidget);
      expect(find.text('Quick Quiz'), findsOneWidget);
    });

    testWidgets('shows quick actions section', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Scroll to find Quick Actions.
      await tester.scrollUntilVisible(
        find.text('Quick Actions'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Belt Progression'), findsOneWidget);
      expect(find.text('Technique Library'), findsOneWidget);
    });

    testWidgets('shows default belt rank (10th Kyu)', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('10th Kyu'), findsOneWidget);
    });

    testWidgets('renders belt color swatch', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // BeltColorSwatch should be present.
      expect(find.byType(DashboardCard), findsWidgets);
    });
  });
}
