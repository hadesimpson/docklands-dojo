import 'dart:developer' as developer;

import 'package:docklands_dojo/data/syllabus_data.dart';
import 'package:docklands_dojo/database/daos/progress_dao.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/belt_requirement.dart';
import 'package:docklands_dojo/models/user_progress.dart';
import 'package:docklands_dojo/result.dart';

/// Business logic service for belt progression tracking.
///
/// Wraps [ProgressDao] with higher-level operations:
/// - Completion percentage calculation per belt rank
/// - Belt advancement validation (checks requirements before advancing)
/// - Training session management
/// - Advancement history queries
///
/// All public methods return [Result<T>] for consistent error handling.
///
/// ```dart
/// final service = ProgressService(progressDao);
/// final result = await service.getCurrentProgress();
/// switch (result) {
///   Success(:final data) => print('Current rank: ${data?.currentRank}'),
///   Failure(:final message) => print('Error: $message'),
/// }
/// ```
class ProgressService {
  final ProgressDao _progressDao;

  /// Syllabus data used for requirement lookups.
  ///
  /// Defaults to [allBeltRequirements] but can be overridden for testing.
  final List<BeltRequirement> _syllabusData;

  /// Creates a [ProgressService] backed by the given [ProgressDao].
  ///
  /// Optionally accepts [syllabusData] for testing — defaults to
  /// [allBeltRequirements] from the syllabus content data.
  ProgressService(this._progressDao, {List<BeltRequirement>? syllabusData})
    : _syllabusData = syllabusData ?? allBeltRequirements;

  /// Retrieves the current user progress, or `null` if none exists.
  ///
  /// Enriches the DAO result with advancement history and training log.
  Future<Result<UserProgress?>> getCurrentProgress() async {
    try {
      final progressResult = await _progressDao.getProgress();
      switch (progressResult) {
        case Failure(:final message, :final error):
          return Failure(message, error);
        case Success(:final data):
          if (data == null) {
            return const Success(null);
          }

          // Enrich with advancement history and training log.
          final historyResult = await _progressDao.getAdvancementHistory();
          final sessionsResult = await _progressDao.getTrainingSessions();

          final history = switch (historyResult) {
            Success(:final data) => data,
            Failure() => <BeltAdvancement>[],
          };
          final sessions = switch (sessionsResult) {
            Success(:final data) => data,
            Failure() => <TrainingSession>[],
          };

          return Success(
            UserProgress(
              currentRank: data.currentRank,
              completedTechniques: data.completedTechniques,
              advancementHistory: history,
              trainingLog: sessions,
              startDate: data.startDate,
            ),
          );
      }
    } catch (e) {
      developer.log(
        'Unexpected error in getCurrentProgress',
        error: e,
        name: 'ProgressService',
      );
      return Failure('Failed to load progress', e);
    }
  }

  /// Updates the user's current belt rank.
  ///
  /// Preserves existing completed techniques and start date.
  /// If no progress exists, creates a new record with the given rank.
  Future<Result<void>> updateCurrentBelt(BeltRank rank) async {
    try {
      final progressResult = await _progressDao.getProgress();
      switch (progressResult) {
        case Failure(:final message, :final error):
          return Failure(message, error);
        case Success(:final data):
          final progress = UserProgress(
            currentRank: rank,
            completedTechniques: data?.completedTechniques ?? {},
            advancementHistory: const [],
            trainingLog: const [],
            startDate: data?.startDate ?? DateTime.now(),
          );
          return _progressDao.saveProgress(progress);
      }
    } catch (e) {
      developer.log(
        'Unexpected error in updateCurrentBelt',
        error: e,
        name: 'ProgressService',
      );
      return Failure('Failed to update belt rank', e);
    }
  }

  /// Adds a training session with the given [duration] and optional [notes].
  ///
  /// Records the session with the current date and time.
  Future<Result<void>> addTrainingSession(
    Duration duration, {
    String? notes,
  }) async {
    try {
      final session = TrainingSession(
        date: DateTime.now(),
        duration: duration,
        notes: notes,
      );
      return _progressDao.addTrainingSession(session);
    } catch (e) {
      developer.log(
        'Unexpected error in addTrainingSession',
        error: e,
        name: 'ProgressService',
      );
      return Failure('Failed to add training session', e);
    }
  }

  /// Retrieves the full belt advancement history, ordered by date.
  Future<Result<List<BeltAdvancement>>> getAdvancementHistory() async {
    try {
      return _progressDao.getAdvancementHistory();
    } catch (e) {
      developer.log(
        'Unexpected error in getAdvancementHistory',
        error: e,
        name: 'ProgressService',
      );
      return Failure('Failed to load advancement history', e);
    }
  }

  /// Retrieves training sessions, optionally filtered by date range.
  ///
  /// If [start] and [end] are provided, only sessions within that
  /// range (inclusive) are returned.
  Future<Result<List<TrainingSession>>> getTrainingSessions({
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      final result = await _progressDao.getTrainingSessions();
      switch (result) {
        case Failure(:final message, :final error):
          return Failure(message, error);
        case Success(:final data):
          if (start == null && end == null) {
            return Success(data);
          }
          final filtered = data.where((session) {
            if (start != null && session.date.isBefore(start)) return false;
            if (end != null && session.date.isAfter(end)) return false;
            return true;
          }).toList();
          return Success(filtered);
      }
    } catch (e) {
      developer.log(
        'Unexpected error in getTrainingSessions',
        error: e,
        name: 'ProgressService',
      );
      return Failure('Failed to load training sessions', e);
    }
  }

  /// Calculates completion percentage for the given [rank].
  ///
  /// Returns a value from 0.0 to 1.0 based on the ratio of mastered
  /// techniques (both kihon and kata) to total required techniques.
  ///
  /// Returns 0.0 if the rank has no requirements or no progress exists.
  double calculateCompletionPercentage(
    BeltRank rank,
    Map<String, bool> completedTechniques,
  ) {
    final requirement = _getRequirement(rank);
    if (requirement == null) return 0.0;

    final allRequired = [
      ...requirement.requiredKihon,
      ...requirement.requiredKata,
    ];
    if (allRequired.isEmpty) return 0.0;

    final completedCount = allRequired.where((id) {
      return completedTechniques[id] == true;
    }).length;

    return completedCount / allRequired.length;
  }

  /// Checks whether the user can advance to the given [rank].
  ///
  /// Validates that:
  /// - The target rank is exactly one rank above the current rank
  /// - All required techniques for the target rank are completed
  ///
  /// Returns [Success] with `true` if advancement is allowed,
  /// `false` otherwise. Returns [Failure] on errors.
  Future<Result<bool>> canAdvanceTo(BeltRank rank) async {
    try {
      final progressResult = await getCurrentProgress();
      switch (progressResult) {
        case Failure(:final message, :final error):
          return Failure(message, error);
        case Success(:final data):
          if (data == null) return const Success(false);

          // Check the target rank is exactly one step above current.
          final currentOrder = data.currentRank.order;
          final targetOrder = rank.order;
          if (targetOrder != currentOrder + 1) {
            return const Success(false);
          }

          // Check all required techniques are completed.
          final completion = calculateCompletionPercentage(
            rank,
            data.completedTechniques,
          );
          return Success(completion >= 1.0);
      }
    } catch (e) {
      developer.log(
        'Unexpected error in canAdvanceTo',
        error: e,
        name: 'ProgressService',
      );
      return Failure('Failed to check advancement eligibility', e);
    }
  }

  /// Advances the user's belt to the given [to] rank.
  ///
  /// Records a [BeltAdvancement] event and updates the current rank.
  /// Does NOT validate prerequisites — call [canAdvanceTo] first.
  ///
  /// Optionally accepts [notes] about the grading.
  Future<Result<void>> advanceBelt(BeltRank to, {String? notes}) async {
    try {
      final progressResult = await getCurrentProgress();
      switch (progressResult) {
        case Failure(:final message, :final error):
          return Failure(message, error);
        case Success(:final data):
          if (data == null) {
            return const Failure('No progress found — cannot advance');
          }

          // Record the advancement event.
          final advancement = BeltAdvancement(
            fromRank: data.currentRank,
            toRank: to,
            date: DateTime.now(),
            notes: notes,
          );
          final advResult = await _progressDao.addBeltAdvancement(advancement);
          if (advResult is Failure<void>) {
            return advResult;
          }

          // Update current rank.
          return updateCurrentBelt(to);
      }
    } catch (e) {
      developer.log(
        'Unexpected error in advanceBelt',
        error: e,
        name: 'ProgressService',
      );
      return Failure('Failed to advance belt', e);
    }
  }

  /// Looks up the [BeltRequirement] for the given [rank].
  ///
  /// Returns `null` if no requirement is found (should not happen
  /// for valid IKO-1 ranks).
  BeltRequirement? _getRequirement(BeltRank rank) {
    for (final req in _syllabusData) {
      if (req.rank == rank) return req;
    }
    developer.log(
      'No requirement found for rank: $rank',
      name: 'ProgressService',
    );
    return null;
  }
}
