import 'package:docklands_dojo/app.dart';
import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/providers/progress_providers.dart';
import 'package:docklands_dojo/providers/review_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DojoApp', () {
    Widget buildSubject() {
      final db = AppDatabase(NativeDatabase.memory());
      return ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const DojoApp(),
      );
    }

    testWidgets('launches without crash', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // App should render the home screen with bottom navigation.
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('shows bottom navigation bar with 4 tabs', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Techniques'), findsOneWidget);
      expect(find.text('Review'), findsOneWidget);
      expect(find.text('Belts'), findsOneWidget);
    });

    testWidgets('displays welcome text on home tab', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Osu! 🥋'), findsOneWidget);
      expect(find.text('Welcome to Docklands Dojo'), findsOneWidget);
    });
  });
}
