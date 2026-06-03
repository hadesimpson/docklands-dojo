import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/kata.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Kata construction', () {
    const kata = Kata(
      id: 'taikyoku_sono_ichi',
      japaneseName: '太極その一',
      englishName: 'Taikyoku Sono Ichi',
      meaning: 'First Cause, Number One',
      moveCount: 20,
      minimumRank: BeltRank.kyu10,
      movementSequence: [
        'Turn left, gedan barai in zenkutsu dachi',
        'Step forward, oi tsuki chudan',
        'Turn 180°, gedan barai in zenkutsu dachi',
      ],
      history: 'Created by Sosai Mas Oyama as a basic training kata.',
      keyPrinciples: ['Strong stances', 'Full hip rotation'],
    );

    test('has correct id', () {
      expect(kata.id, 'taikyoku_sono_ichi');
    });

    test('has correct Japanese name', () {
      expect(kata.japaneseName, '太極その一');
    });

    test('has correct English name', () {
      expect(kata.englishName, 'Taikyoku Sono Ichi');
    });

    test('has correct meaning', () {
      expect(kata.meaning, 'First Cause, Number One');
    });

    test('has correct move count', () {
      expect(kata.moveCount, 20);
    });

    test('has correct minimum rank', () {
      expect(kata.minimumRank, BeltRank.kyu10);
    });

    test('has movement sequence', () {
      expect(kata.movementSequence, hasLength(3));
    });

    test('has history', () {
      expect(kata.history.isNotEmpty, isTrue);
    });

    test('has key principles', () {
      expect(kata.keyPrinciples, hasLength(2));
    });
  });

  group('Kata bunkai (nullable)', () {
    test('bunkai defaults to null', () {
      const kata = Kata(
        id: 'test_kata',
        japaneseName: 'テスト',
        englishName: 'Test Kata',
        meaning: 'Test',
        moveCount: 10,
        minimumRank: BeltRank.kyu10,
        movementSequence: ['Move 1'],
        history: 'Test history.',
        keyPrinciples: ['Test principle'],
      );
      expect(kata.bunkai, isNull);
    });

    test('bunkai can be set to a list', () {
      const kata = Kata(
        id: 'test_kata',
        japaneseName: 'テスト',
        englishName: 'Test Kata',
        meaning: 'Test',
        moveCount: 10,
        minimumRank: BeltRank.kyu10,
        movementSequence: ['Move 1'],
        history: 'Test history.',
        keyPrinciples: ['Test principle'],
        bunkai: [
          'Application 1: defense against grab',
          'Application 2: counter-strike',
        ],
      );
      expect(kata.bunkai, isNotNull);
      expect(kata.bunkai, hasLength(2));
    });

    test('bunkai can be set to empty list', () {
      const kata = Kata(
        id: 'test_kata',
        japaneseName: 'テスト',
        englishName: 'Test Kata',
        meaning: 'Test',
        moveCount: 10,
        minimumRank: BeltRank.kyu10,
        movementSequence: ['Move 1'],
        history: 'Test history.',
        keyPrinciples: ['Test principle'],
        bunkai: [],
      );
      expect(kata.bunkai, isNotNull);
      expect(kata.bunkai, isEmpty);
    });
  });

  group('Kata equality', () {
    test('kata with same id are equal', () {
      const a = Kata(
        id: 'same_id',
        japaneseName: 'A',
        englishName: 'A',
        meaning: 'A',
        moveCount: 10,
        minimumRank: BeltRank.kyu10,
        movementSequence: ['A'],
        history: 'A',
        keyPrinciples: ['A'],
      );
      const b = Kata(
        id: 'same_id',
        japaneseName: 'B',
        englishName: 'B',
        meaning: 'B',
        moveCount: 20,
        minimumRank: BeltRank.shodan,
        movementSequence: ['B'],
        history: 'B',
        keyPrinciples: ['B'],
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('kata with different ids are not equal', () {
      const a = Kata(
        id: 'id_a',
        japaneseName: 'A',
        englishName: 'A',
        meaning: 'A',
        moveCount: 10,
        minimumRank: BeltRank.kyu10,
        movementSequence: ['A'],
        history: 'A',
        keyPrinciples: ['A'],
      );
      const b = Kata(
        id: 'id_b',
        japaneseName: 'A',
        englishName: 'A',
        meaning: 'A',
        moveCount: 10,
        minimumRank: BeltRank.kyu10,
        movementSequence: ['A'],
        history: 'A',
        keyPrinciples: ['A'],
      );
      expect(a, isNot(equals(b)));
    });
  });

  group('Kata toString', () {
    test('includes id and English name', () {
      const kata = Kata(
        id: 'pinan_sono_ichi',
        japaneseName: 'ピナンその一',
        englishName: 'Pinan Sono Ichi',
        meaning: 'Peaceful Mind, Number One',
        moveCount: 21,
        minimumRank: BeltRank.kyu7,
        movementSequence: ['Move 1'],
        history: 'History.',
        keyPrinciples: ['Principle'],
      );
      expect(kata.toString(), contains('pinan_sono_ichi'));
      expect(kata.toString(), contains('Pinan Sono Ichi'));
    });
  });
}
