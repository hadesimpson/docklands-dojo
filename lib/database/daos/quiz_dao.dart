import 'dart:convert';

import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/result.dart';
import 'package:drift/drift.dart';

part 'quiz_dao.g.dart';

/// Data model for a quiz attempt as stored in the database.
///
/// This is the persistence representation; the domain model in
/// `lib/models/quiz_question.dart` will be enriched in CL10.
class QuizAttemptData {
  /// Unique identifier (auto-assigned by database).
  final int? id;

  /// When the quiz was taken.
  final DateTime timestamp;

  /// Target belt rank for this quiz.
  final BeltRank targetRank;

  /// Whether this was a mock grading exam.
  final bool isMockExam;

  /// Total number of questions.
  final int totalQuestions;

  /// Number of correctly answered questions.
  final int correctAnswers;

  /// Duration of the quiz.
  final Duration duration;

  /// Score breakdown by category (category name → percentage 0.0–1.0).
  final Map<String, double> categoryScores;

  /// List of weak area identifiers for focused study.
  final List<String> weakAreas;

  /// Creates a [QuizAttemptData].
  const QuizAttemptData({
    this.id,
    required this.timestamp,
    required this.targetRank,
    required this.isMockExam,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.duration,
    required this.categoryScores,
    required this.weakAreas,
  });

  /// Overall score as a percentage (0.0–1.0).
  double get scorePercentage =>
      totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAttemptData && timestamp == other.timestamp;

  @override
  int get hashCode => timestamp.hashCode;

  @override
  String toString() =>
      'QuizAttemptData(${targetRank.name}, $correctAnswers/$totalQuestions)';
}

/// Data access object for quiz attempt history.
///
/// Provides typed CRUD operations for [QuizAttemptData], including
/// filtered queries by belt rank and aggregate score calculations.
///
/// All public methods return [Result] types for error handling.
@DriftAccessor(tables: [QuizAttemptTable])
class QuizDao extends DatabaseAccessor<AppDatabase> with _$QuizDaoMixin {
  /// Creates a [QuizDao] attached to the given [AppDatabase].
  QuizDao(super.db);

  /// Records a quiz attempt.
  ///
  /// Returns [Success] with `void` on success, or [Failure] on error.
  Future<Result<void>> addQuizAttempt(QuizAttemptData attempt) async {
    try {
      await into(quizAttemptTable).insert(
        QuizAttemptTableCompanion.insert(
          timestamp: attempt.timestamp.millisecondsSinceEpoch,
          targetRank: attempt.targetRank.index,
          isMockExam: Value(attempt.isMockExam),
          totalQuestions: attempt.totalQuestions,
          correctAnswers: attempt.correctAnswers,
          durationSeconds: attempt.duration.inSeconds,
          categoryScoresJson: Value(jsonEncode(attempt.categoryScores)),
          weakAreasJson: Value(jsonEncode(attempt.weakAreas)),
        ),
      );
      return const Success(null);
    } catch (e) {
      return Failure('Failed to add quiz attempt', e);
    }
  }

  /// Retrieves quiz history, optionally filtered by [targetRank].
  ///
  /// Results are ordered by most recent first.
  /// Returns an empty list if no attempts match.
  Future<Result<List<QuizAttemptData>>> getQuizHistory({
    BeltRank? targetRank,
  }) async {
    try {
      final query = select(quizAttemptTable)
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)]);

      if (targetRank != null) {
        query.where((tbl) => tbl.targetRank.equals(targetRank.index));
      }

      final rows = await query.get();
      return Success(rows.map(_rowToQuizAttempt).toList());
    } catch (e) {
      return Failure('Failed to load quiz history', e);
    }
  }

  /// Calculates average score percentage by category across all attempts.
  ///
  /// Returns a map of category name → average percentage (0.0–1.0).
  /// Categories with no data are excluded.
  Future<Result<Map<String, double>>> getAverageScoreByCategory() async {
    try {
      final rows = await select(quizAttemptTable).get();

      final categoryTotals = <String, List<double>>{};
      for (final row in rows) {
        final scores =
            (jsonDecode(row.categoryScoresJson) as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
            );

        for (final entry in scores.entries) {
          categoryTotals.putIfAbsent(entry.key, () => []).add(entry.value);
        }
      }

      final averages = categoryTotals.map(
        (category, scores) =>
            MapEntry(category, scores.reduce((a, b) => a + b) / scores.length),
      );

      return Success(averages);
    } catch (e) {
      return Failure('Failed to calculate average scores', e);
    }
  }

  /// Counts mock exam attempts that achieved a passing score (≥ 80%).
  ///
  /// Filtered to the specified [targetRank].
  Future<Result<int>> getMockExamPassCount(BeltRank targetRank) async {
    try {
      final rows =
          await (select(quizAttemptTable)..where(
                (tbl) =>
                    tbl.isMockExam.equals(true) &
                    tbl.targetRank.equals(targetRank.index),
              ))
              .get();

      final passCount = rows
          .where(
            (row) =>
                row.totalQuestions > 0 &&
                row.correctAnswers / row.totalQuestions >= 0.8,
          )
          .length;

      return Success(passCount);
    } catch (e) {
      return Failure('Failed to count mock exam passes', e);
    }
  }

  QuizAttemptData _rowToQuizAttempt(QuizAttemptTableData row) {
    final categoryScores =
        (jsonDecode(row.categoryScoresJson) as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        );

    final weakAreas = (jsonDecode(row.weakAreasJson) as List<dynamic>)
        .map((e) => e as String)
        .toList();

    return QuizAttemptData(
      id: row.id,
      timestamp: DateTime.fromMillisecondsSinceEpoch(row.timestamp),
      targetRank: BeltRank.values[row.targetRank],
      isMockExam: row.isMockExam,
      totalQuestions: row.totalQuestions,
      correctAnswers: row.correctAnswers,
      duration: Duration(seconds: row.durationSeconds),
      categoryScores: categoryScores,
      weakAreas: weakAreas,
    );
  }
}
