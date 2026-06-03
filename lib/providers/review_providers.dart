import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/database/daos/review_dao.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/services/srs/review_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_providers.g.dart';

/// Provides the [ReviewDao] instance from the app database.
///
/// Requires [appDatabaseProvider] to be overridden with a live database
/// in production (via `ProviderScope.overrides`).
@riverpod
ReviewDao reviewDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.reviewDao;
}

/// Provides the [ReviewService] for spaced repetition operations.
///
/// Depends on [reviewDaoProvider]. The SM-2 algorithm is used by default.
@riverpod
ReviewService reviewService(Ref ref) {
  final dao = ref.watch(reviewDaoProvider);
  return ReviewService(dao: dao);
}

/// Provides the list of cards due for review right now.
///
/// Returns a [Result] wrapping the due [CardReviewState] list.
/// Auto-disposes when no longer watched.
@riverpod
Future<Result<List<CardReviewState>>> dueCards(Ref ref) async {
  final service = ref.watch(reviewServiceProvider);
  return service.getDueCards(DateTime.now());
}

/// Provides aggregate review statistics.
///
/// Returns a [Result] wrapping [ReviewStats].
/// Auto-disposes when no longer watched.
@riverpod
Future<Result<ReviewStats>> reviewStats(Ref ref) async {
  final service = ref.watch(reviewServiceProvider);
  return service.getReviewStats(now: DateTime.now());
}

/// Provider for the [AppDatabase] instance.
///
/// Must be overridden in the root `ProviderScope` with a real database:
/// ```dart
/// ProviderScope(
///   overrides: [
///     appDatabaseProvider.overrideWithValue(AppDatabase(executor)),
///   ],
///   child: const DojoApp(),
/// )
/// ```
@riverpod
AppDatabase appDatabase(Ref ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden with a live AppDatabase instance.',
  );
}
