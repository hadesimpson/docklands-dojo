import 'dart:convert';

import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/user_progress.dart';
import 'package:docklands_dojo/result.dart';
import 'package:drift/drift.dart';

part 'progress_dao.g.dart';

/// Data access object for user progress and belt advancement.
///
/// Provides typed CRUD operations for:
/// - [UserProgress] (current rank, completed techniques, start date)
/// - [BeltAdvancement] (grading history)
/// - [TrainingSession] (attendance tracking)
///
/// All public methods return [Result] types for error handling.
@DriftAccessor(
  tables: [UserProgressTable, BeltAdvancementTable, TrainingSessionTable],
)
class ProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressDaoMixin {
  /// Creates a [ProgressDao] attached to the given [AppDatabase].
  ProgressDao(super.db);

  /// Retrieves the current user progress, or `null` if none exists.
  ///
  /// Returns [Success] with the [UserProgress] or `null` if no progress
  /// has been saved yet. Returns [Failure] on database errors.
  Future<Result<UserProgress?>> getProgress() async {
    try {
      final row = await (select(userProgressTable)..limit(1)).getSingleOrNull();
      if (row == null) {
        return const Success(null);
      }
      return Success(_rowToUserProgress(row));
    } catch (e) {
      return Failure('Failed to load progress', e);
    }
  }

  /// Saves or updates user progress.
  ///
  /// If progress already exists (any row), it is updated.
  /// Otherwise, a new row is inserted.
  ///
  /// Returns [Success] with `void` on success, or [Failure] on error.
  Future<Result<void>> saveProgress(UserProgress progress) async {
    try {
      final existing = await (select(
        userProgressTable,
      )..limit(1)).getSingleOrNull();

      final companion = UserProgressTableCompanion(
        currentRank: Value(progress.currentRank.index),
        startDate: Value(progress.startDate.millisecondsSinceEpoch),
        completedTechniquesJson: Value(
          jsonEncode(progress.completedTechniques),
        ),
      );

      if (existing != null) {
        await (update(
          userProgressTable,
        )..where((tbl) => tbl.id.equals(existing.id))).write(companion);
      } else {
        await into(userProgressTable).insert(companion);
      }

      return const Success(null);
    } catch (e) {
      return Failure('Failed to save progress', e);
    }
  }

  /// Records a belt advancement event.
  ///
  /// Appends an immutable record to the advancement history.
  /// Returns [Success] with `void` on success, or [Failure] on error.
  Future<Result<void>> addBeltAdvancement(BeltAdvancement advancement) async {
    try {
      await into(beltAdvancementTable).insert(
        BeltAdvancementTableCompanion.insert(
          fromRank: advancement.fromRank.index,
          toRank: advancement.toRank.index,
          date: advancement.date.millisecondsSinceEpoch,
          notes: Value(advancement.notes),
        ),
      );
      return const Success(null);
    } catch (e) {
      return Failure('Failed to add belt advancement', e);
    }
  }

  /// Retrieves the full belt advancement history, ordered by date.
  ///
  /// Returns [Success] with a list of [BeltAdvancement] records,
  /// or [Failure] on error. Empty list if no advancements recorded.
  Future<Result<List<BeltAdvancement>>> getAdvancementHistory() async {
    try {
      final rows = await (select(
        beltAdvancementTable,
      )..orderBy([(tbl) => OrderingTerm.asc(tbl.date)])).get();
      return Success(rows.map(_rowToBeltAdvancement).toList());
    } catch (e) {
      return Failure('Failed to load advancement history', e);
    }
  }

  /// Records a training session.
  ///
  /// Returns [Success] with `void` on success, or [Failure] on error.
  Future<Result<void>> addTrainingSession(TrainingSession session) async {
    try {
      await into(trainingSessionTable).insert(
        TrainingSessionTableCompanion.insert(
          date: session.date.millisecondsSinceEpoch,
          durationMinutes: session.duration.inMinutes,
          notes: Value(session.notes),
        ),
      );
      return const Success(null);
    } catch (e) {
      return Failure('Failed to add training session', e);
    }
  }

  /// Retrieves all training sessions, ordered by date descending.
  ///
  /// Returns [Success] with a list of [TrainingSession] records,
  /// or [Failure] on error.
  Future<Result<List<TrainingSession>>> getTrainingSessions() async {
    try {
      final rows = await (select(
        trainingSessionTable,
      )..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])).get();
      return Success(rows.map(_rowToTrainingSession).toList());
    } catch (e) {
      return Failure('Failed to load training sessions', e);
    }
  }

  UserProgress _rowToUserProgress(UserProgressTableData row) {
    final completedMap =
        (jsonDecode(row.completedTechniquesJson) as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, value as bool),
        );

    return UserProgress(
      currentRank: BeltRank.values[row.currentRank],
      completedTechniques: completedMap,
      advancementHistory: const [],
      trainingLog: const [],
      startDate: DateTime.fromMillisecondsSinceEpoch(row.startDate),
    );
  }

  BeltAdvancement _rowToBeltAdvancement(BeltAdvancementTableData row) =>
      BeltAdvancement(
        fromRank: BeltRank.values[row.fromRank],
        toRank: BeltRank.values[row.toRank],
        date: DateTime.fromMillisecondsSinceEpoch(row.date),
        notes: row.notes,
      );

  TrainingSession _rowToTrainingSession(TrainingSessionTableData row) =>
      TrainingSession(
        date: DateTime.fromMillisecondsSinceEpoch(row.date),
        duration: Duration(minutes: row.durationMinutes),
        notes: row.notes,
      );
}
