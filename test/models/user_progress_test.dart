import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/user_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProgress construction', () {
    final now = DateTime(2026, 6, 3);
    final progress = UserProgress(
      currentRank: BeltRank.kyu10,
      completedTechniques: {'seiken_chudan_tsuki': true},
      advancementHistory: [],
      trainingLog: [],
      startDate: now,
    );

    test('has correct current rank', () {
      expect(progress.currentRank, BeltRank.kyu10);
    });

    test('has completed techniques', () {
      expect(progress.completedTechniques['seiken_chudan_tsuki'], isTrue);
    });

    test('has empty advancement history', () {
      expect(progress.advancementHistory, isEmpty);
    });

    test('has empty training log', () {
      expect(progress.trainingLog, isEmpty);
    });

    test('has correct start date', () {
      expect(progress.startDate, now);
    });
  });

  group('UserProgress with populated data', () {
    final now = DateTime(2026, 6, 3);
    final advancement = BeltAdvancement(
      fromRank: BeltRank.kyu10,
      toRank: BeltRank.kyu9,
      date: now,
      notes: 'Passed first grading',
    );
    final session = TrainingSession(
      date: now,
      duration: const Duration(hours: 1, minutes: 30),
      notes: 'Focused on kata',
    );

    final progress = UserProgress(
      currentRank: BeltRank.kyu9,
      completedTechniques: {
        'seiken_chudan_tsuki': true,
        'mae_geri_chudan': true,
        'gedan_barai': false,
      },
      advancementHistory: [advancement],
      trainingLog: [session],
      startDate: DateTime(2026, 1, 1),
    );

    test('tracks multiple techniques', () {
      expect(progress.completedTechniques.length, 3);
    });

    test('advancement history contains event', () {
      expect(progress.advancementHistory, hasLength(1));
      expect(progress.advancementHistory.first.toRank, BeltRank.kyu9);
    });

    test('training log contains session', () {
      expect(progress.trainingLog, hasLength(1));
      expect(
        progress.trainingLog.first.duration,
        const Duration(hours: 1, minutes: 30),
      );
    });
  });

  group('BeltAdvancement', () {
    test('construction with all fields', () {
      final date = DateTime(2026, 3, 15);
      final advancement = BeltAdvancement(
        fromRank: BeltRank.kyu10,
        toRank: BeltRank.kyu9,
        date: date,
        notes: 'First grading',
      );
      expect(advancement.fromRank, BeltRank.kyu10);
      expect(advancement.toRank, BeltRank.kyu9);
      expect(advancement.date, date);
      expect(advancement.notes, 'First grading');
    });

    test('notes is optional', () {
      final advancement = BeltAdvancement(
        fromRank: BeltRank.kyu9,
        toRank: BeltRank.kyu8,
        date: DateTime(2026, 6, 1),
      );
      expect(advancement.notes, isNull);
    });

    test('equality based on from, to, and date', () {
      final date = DateTime(2026, 3, 15);
      final a = BeltAdvancement(
        fromRank: BeltRank.kyu10,
        toRank: BeltRank.kyu9,
        date: date,
      );
      final b = BeltAdvancement(
        fromRank: BeltRank.kyu10,
        toRank: BeltRank.kyu9,
        date: date,
        notes: 'Different notes',
      );
      expect(a, equals(b));
    });

    test('toString contains rank names', () {
      final advancement = BeltAdvancement(
        fromRank: BeltRank.kyu10,
        toRank: BeltRank.kyu9,
        date: DateTime(2026, 3, 15),
      );
      expect(advancement.toString(), contains('kyu10'));
      expect(advancement.toString(), contains('kyu9'));
    });
  });

  group('TrainingSession', () {
    test('construction with all fields', () {
      final date = DateTime(2026, 6, 3, 18, 0);
      const duration = Duration(hours: 1, minutes: 30);
      final session = TrainingSession(
        date: date,
        duration: duration,
        notes: 'Sparring day',
      );
      expect(session.date, date);
      expect(session.duration, duration);
      expect(session.notes, 'Sparring day');
    });

    test('notes is optional', () {
      final session = TrainingSession(
        date: DateTime(2026, 6, 3),
        duration: const Duration(hours: 2),
      );
      expect(session.notes, isNull);
    });

    test('equality based on date', () {
      final date = DateTime(2026, 6, 3, 18, 0);
      final a = TrainingSession(date: date, duration: const Duration(hours: 1));
      final b = TrainingSession(
        date: date,
        duration: const Duration(hours: 2),
        notes: 'Different',
      );
      expect(a, equals(b));
    });

    test('toString contains date and duration', () {
      final session = TrainingSession(
        date: DateTime(2026, 6, 3),
        duration: const Duration(hours: 1, minutes: 30),
      );
      final str = session.toString();
      expect(str, contains('TrainingSession'));
    });
  });
}
