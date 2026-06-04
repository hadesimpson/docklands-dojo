import 'dart:io';

import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/providers/progress_providers.dart';
import 'package:docklands_dojo/providers/review_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app.dart';

/// Entry point for Docklands Dojo.
///
/// Initializes the Drift (SQLite) database, wraps the app in a
/// [ProviderScope] with database overrides, and checks onboarding
/// status to determine the initial route.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Drift database.
  final db = await _initDatabase();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const DojoApp(),
    ),
  );
}

/// Initializes the Drift database with a file-backed SQLite store.
///
/// The database file is stored in the app's documents directory
/// to persist across app restarts.
Future<AppDatabase> _initDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'docklands_dojo.db'));
  final database = AppDatabase(NativeDatabase(file));
  return database;
}
