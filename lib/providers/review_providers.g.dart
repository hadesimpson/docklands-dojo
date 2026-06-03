// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewDaoHash() => r'9e2379f8c3b4211bc19b94c3532ed20ec2691e61';

/// Provides the [ReviewDao] instance from the app database.
///
/// Requires [appDatabaseProvider] to be overridden with a live database
/// in production (via `ProviderScope.overrides`).
///
/// Copied from [reviewDao].
@ProviderFor(reviewDao)
final reviewDaoProvider = AutoDisposeProvider<ReviewDao>.internal(
  reviewDao,
  name: r'reviewDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReviewDaoRef = AutoDisposeProviderRef<ReviewDao>;
String _$reviewServiceHash() => r'a9be2de4b1698018aaf9a0d7cdf5844c66108ce6';

/// Provides the [ReviewService] for spaced repetition operations.
///
/// Depends on [reviewDaoProvider]. The SM-2 algorithm is used by default.
///
/// Copied from [reviewService].
@ProviderFor(reviewService)
final reviewServiceProvider = AutoDisposeProvider<ReviewService>.internal(
  reviewService,
  name: r'reviewServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReviewServiceRef = AutoDisposeProviderRef<ReviewService>;
String _$dueCardsHash() => r'716fa8eb5745e5aa0889da9f2e813d0740dcdc6c';

/// Provides the list of cards due for review right now.
///
/// Returns a [Result] wrapping the due [CardReviewState] list.
/// Auto-disposes when no longer watched.
///
/// Copied from [dueCards].
@ProviderFor(dueCards)
final dueCardsProvider =
    AutoDisposeFutureProvider<Result<List<CardReviewState>>>.internal(
      dueCards,
      name: r'dueCardsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dueCardsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DueCardsRef =
    AutoDisposeFutureProviderRef<Result<List<CardReviewState>>>;
String _$reviewStatsHash() => r'ff7ef681125a56437ac4ed5b56a069f2ad0d3c4a';

/// Provides aggregate review statistics.
///
/// Returns a [Result] wrapping [ReviewStats].
/// Auto-disposes when no longer watched.
///
/// Copied from [reviewStats].
@ProviderFor(reviewStats)
final reviewStatsProvider =
    AutoDisposeFutureProvider<Result<ReviewStats>>.internal(
      reviewStats,
      name: r'reviewStatsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reviewStatsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReviewStatsRef = AutoDisposeFutureProviderRef<Result<ReviewStats>>;
String _$appDatabaseHash() => r'7a2491649be1d0cf0dbb9c6d6a2e4510cbc7efd4';

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
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = AutoDisposeProvider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = AutoDisposeProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
