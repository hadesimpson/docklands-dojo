import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/database/daos/progress_dao.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/user_progress.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/services/progress_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the [AppDatabase] singleton.
///
/// Must be overridden with the actual database instance at app startup.
/// Throws [UnimplementedError] if accessed before initialization.
///
/// ```dart
/// runApp(
///   ProviderScope(
///     overrides: [databaseProvider.overrideWithValue(db)],
///     child: const DojoApp(),
///   ),
/// );
/// ```
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'databaseProvider must be overridden with an AppDatabase instance',
  );
});

/// Provider for the [ProgressDao].
///
/// Lazily creates a DAO backed by the [databaseProvider] database.
final progressDaoProvider = Provider<ProgressDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.progressDao;
});

/// Singleton provider for the [ProgressService].
///
/// Provides belt progression business logic backed by [ProgressDao].
final progressServiceProvider = Provider<ProgressService>((ref) {
  final dao = ref.watch(progressDaoProvider);
  return ProgressService(dao);
});

/// Async notifier managing the current [UserProgress] state.
///
/// Provides reactive access to the user's current belt rank,
/// completed techniques, and training log. Automatically refreshes
/// when mutations occur via [updateBelt], [markTechniqueCompleted],
/// or [addTrainingSession].
///
/// ```dart
/// final progress = ref.watch(currentProgressProvider);
/// progress.when(
///   data: (p) => Text('Rank: ${p?.currentRank}'),
///   loading: () => CircularProgressIndicator(),
///   error: (e, st) => Text('Error: $e'),
/// );
/// ```
final currentProgressProvider =
    AsyncNotifierProvider<CurrentProgressNotifier, UserProgress?>(
      CurrentProgressNotifier.new,
    );

/// Notifier that manages the [UserProgress] lifecycle.
///
/// Loads progress from the database on initialization and provides
/// methods to mutate state with automatic UI refresh.
class CurrentProgressNotifier extends AsyncNotifier<UserProgress?> {
  @override
  Future<UserProgress?> build() async {
    final service = ref.watch(progressServiceProvider);
    final result = await service.getCurrentProgress();
    return switch (result) {
      Success(:final data) => data,
      Failure(:final message) => throw Exception(message),
    };
  }

  /// Updates the current belt rank and refreshes state.
  Future<Result<void>> updateBelt(BeltRank rank) async {
    final service = ref.read(progressServiceProvider);
    final result = await service.updateCurrentBelt(rank);
    ref.invalidateSelf();
    return result;
  }

  /// Marks a technique as completed and refreshes state.
  Future<Result<void>> markTechniqueCompleted(String techniqueId) async {
    final service = ref.read(progressServiceProvider);
    final currentResult = await service.getCurrentProgress();
    switch (currentResult) {
      case Failure(:final message, :final error):
        return Failure(message, error);
      case Success(:final data):
        if (data == null) {
          return const Failure('No progress found');
        }
        final updated = Map<String, bool>.from(data.completedTechniques);
        updated[techniqueId] = true;
        final progress = UserProgress(
          currentRank: data.currentRank,
          completedTechniques: updated,
          advancementHistory: data.advancementHistory,
          trainingLog: data.trainingLog,
          startDate: data.startDate,
        );
        final dao = ref.read(progressDaoProvider);
        final saveResult = await dao.saveProgress(progress);
        ref.invalidateSelf();
        return saveResult;
    }
  }

  /// Adds a training session and refreshes state.
  Future<Result<void>> addTrainingSession(
    Duration duration, {
    String? notes,
  }) async {
    final service = ref.read(progressServiceProvider);
    final result = await service.addTrainingSession(duration, notes: notes);
    ref.invalidateSelf();
    return result;
  }

  /// Advances belt to [rank] and refreshes state.
  Future<Result<void>> advanceBelt(BeltRank rank, {String? notes}) async {
    final service = ref.read(progressServiceProvider);
    final result = await service.advanceBelt(rank, notes: notes);
    ref.invalidateSelf();
    return result;
  }
}

/// Provider for the belt advancement history.
///
/// Returns a list of [BeltAdvancement] records ordered by date.
final advancementHistoryProvider = FutureProvider<List<BeltAdvancement>>((
  ref,
) async {
  final service = ref.watch(progressServiceProvider);
  final result = await service.getAdvancementHistory();
  return switch (result) {
    Success(:final data) => data,
    Failure(:final message) => throw Exception(message),
  };
});

/// Provider for training sessions with optional date filtering.
///
/// Pass a [DateTimeRange] to filter by date, or `null` for all sessions.
///
/// ```dart
/// final sessions = ref.watch(trainingSessionsProvider(null));
/// ```
final trainingSessionsProvider =
    FutureProvider.family<List<TrainingSession>, DateTimeRange?>((
      ref,
      range,
    ) async {
      final service = ref.watch(progressServiceProvider);
      final result = await service.getTrainingSessions(
        start: range?.start,
        end: range?.end,
      );
      return switch (result) {
        Success(:final data) => data,
        Failure(:final message) => throw Exception(message),
      };
    });

/// Provider.family for belt rank completion percentage.
///
/// Returns a value from 0.0 to 1.0 representing the ratio of
/// completed to required techniques for the given [BeltRank].
///
/// ```dart
/// final pct = ref.watch(completionPercentageProvider(BeltRank.kyu9));
/// ```
final completionPercentageProvider = FutureProvider.family<double, BeltRank>((
  ref,
  rank,
) async {
  final service = ref.watch(progressServiceProvider);
  final progressResult = await service.getCurrentProgress();
  final completed = switch (progressResult) {
    Success(:final data) => data?.completedTechniques ?? {},
    Failure() => <String, bool>{},
  };
  return service.calculateCompletionPercentage(rank, completed);
});

/// Date range for filtering training sessions.
///
/// Used by [trainingSessionsProvider] as the family parameter.
class DateTimeRange {
  /// Start of the date range (inclusive).
  final DateTime start;

  /// End of the date range (inclusive).
  final DateTime end;

  /// Creates a [DateTimeRange] with the given bounds.
  const DateTimeRange({required this.start, required this.end});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateTimeRange && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);
}
