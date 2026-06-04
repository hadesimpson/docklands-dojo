import 'package:docklands_dojo/data/syllabus_data.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/user_progress.dart';
import 'package:docklands_dojo/providers/progress_providers.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/screens/belt_progression/belt_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BeltListScreen', () {
    Widget buildTestWidget({UserProgress? progress}) {
      return ProviderScope(
        overrides: [
          currentProgressProvider.overrideWith(
            () => _MockProgressNotifier(progress),
          ),
          ...BeltRank.values.map(
            (rank) =>
                completionPercentageProvider(rank).overrideWith((ref) async {
                  if (progress == null) return 0.0;
                  final requirement = allBeltRequirements
                      .where((r) => r.rank == rank)
                      .firstOrNull;
                  if (requirement == null) return 0.0;
                  final allRequired = [
                    ...requirement.requiredKihon,
                    ...requirement.requiredKata,
                  ];
                  if (allRequired.isEmpty) return 0.0;
                  final completedCount = allRequired
                      .where((id) => progress.completedTechniques[id] == true)
                      .length;
                  return completedCount / allRequired.length;
                }),
          ),
        ],
        child: const MaterialApp(home: BeltListScreen()),
      );
    }

    testWidgets('renders all 11 belt ranks', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          progress: UserProgress(
            currentRank: BeltRank.kyu10,
            completedTechniques: {},
            advancementHistory: [],
            trainingLog: [],
            startDate: DateTime(2024),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify all 11 belt display names are present.
      for (final rank in BeltRank.values) {
        expect(find.text(rank.displayName), findsAtLeast(1));
      }
    });

    testWidgets('current belt shows Current badge', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          progress: UserProgress(
            currentRank: BeltRank.kyu9,
            completedTechniques: {},
            advancementHistory: [],
            trainingLog: [],
            startDate: DateTime(2024),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Current'), findsOneWidget);
    });

    testWidgets('shows progress ring for each belt', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          progress: UserProgress(
            currentRank: BeltRank.kyu10,
            completedTechniques: {},
            advancementHistory: [],
            trainingLog: [],
            startDate: DateTime(2024),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Each belt should have a percentage indicator.
      // At 0% completion, we expect "0%" text.
      expect(find.text('0%'), findsAtLeast(1));
    });

    testWidgets('shows text labels for accessibility', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          progress: UserProgress(
            currentRank: BeltRank.kyu10,
            completedTechniques: {},
            advancementHistory: [],
            trainingLog: [],
            startDate: DateTime(2024),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Each belt should have its Japanese name and color description.
      for (final rank in BeltRank.values) {
        final labelText = '${rank.japaneseName} — ${rank.colorDescription}';
        expect(find.text(labelText), findsAtLeast(1));
      }
    });

    testWidgets('shows loading state', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentProgressProvider.overrideWith(
              () => _LoadingProgressNotifier(),
            ),
          ],
          child: const MaterialApp(home: BeltListScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error state with retry button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentProgressProvider.overrideWith(
              () => _ErrorProgressNotifier(),
            ),
          ],
          child: const MaterialApp(home: BeltListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('belt completion percentage reflects completed techniques', (
      tester,
    ) async {
      // Complete all kihon + kata for kyu10 to get 100%.
      final kyu10Req = allBeltRequirements.first;
      final allIds = [...kyu10Req.requiredKihon, ...kyu10Req.requiredKata];
      final completedMap = {for (final id in allIds) id: true};

      await tester.pumpWidget(
        buildTestWidget(
          progress: UserProgress(
            currentRank: BeltRank.kyu10,
            completedTechniques: completedMap,
            advancementHistory: [],
            trainingLog: [],
            startDate: DateTime(2024),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('100%'), findsAtLeast(1));
    });

    testWidgets('tapping belt navigates to detail screen', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          progress: UserProgress(
            currentRank: BeltRank.kyu10,
            completedTechniques: {},
            advancementHistory: [],
            trainingLog: [],
            startDate: DateTime(2024),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on the first belt (10th Kyu).
      await tester.tap(find.text('10th Kyu').first);
      await tester.pumpAndSettle();

      // Should navigate to belt detail showing the rank.
      expect(find.text('Kihon'), findsOneWidget);
    });
  });
}

/// Mock notifier that immediately provides the given progress.
class _MockProgressNotifier extends AsyncNotifier<UserProgress?>
    implements CurrentProgressNotifier {
  final UserProgress? _progress;

  _MockProgressNotifier(this._progress);

  @override
  Future<UserProgress?> build() async => _progress;

  @override
  Future<Result<void>> markTechniqueCompleted(String techniqueId) async =>
      Success(null);

  @override
  Future<Result<void>> updateBelt(BeltRank rank) async => Success(null);

  @override
  Future<Result<void>> addTrainingSession(
    Duration duration, {
    String? notes,
  }) async => Success(null);

  @override
  Future<Result<void>> advanceBelt(BeltRank rank, {String? notes}) async =>
      Success(null);
}

/// Mock notifier that stays in loading state.
class _LoadingProgressNotifier extends AsyncNotifier<UserProgress?>
    implements CurrentProgressNotifier {
  @override
  Future<UserProgress?> build() async {
    // Never complete — simulate loading.
    await Future<void>.delayed(const Duration(hours: 1));
    return null;
  }

  @override
  Future<Result<void>> markTechniqueCompleted(String techniqueId) async =>
      Success(null);

  @override
  Future<Result<void>> updateBelt(BeltRank rank) async => Success(null);

  @override
  Future<Result<void>> addTrainingSession(
    Duration duration, {
    String? notes,
  }) async => Success(null);

  @override
  Future<Result<void>> advanceBelt(BeltRank rank, {String? notes}) async =>
      Success(null);
}

/// Mock notifier that throws an error.
class _ErrorProgressNotifier extends AsyncNotifier<UserProgress?>
    implements CurrentProgressNotifier {
  @override
  Future<UserProgress?> build() async {
    throw Exception('Database error');
  }

  @override
  Future<Result<void>> markTechniqueCompleted(String techniqueId) async =>
      Success(null);

  @override
  Future<Result<void>> updateBelt(BeltRank rank) async => Success(null);

  @override
  Future<Result<void>> addTrainingSession(
    Duration duration, {
    String? notes,
  }) async => Success(null);

  @override
  Future<Result<void>> advanceBelt(BeltRank rank, {String? notes}) async =>
      Success(null);
}
