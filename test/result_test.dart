import 'package:docklands_dojo/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result<T>', () {
    group('Success', () {
      test('holds data correctly', () {
        const result = Success(42);
        expect(result.data, equals(42));
      });

      test('equality works for same data', () {
        const a = Success(42);
        const b = Success(42);
        expect(a, equals(b));
      });

      test('inequality works for different data', () {
        const a = Success(42);
        const b = Success(99);
        expect(a, isNot(equals(b)));
      });

      test('toString includes data', () {
        const result = Success('hello');
        expect(result.toString(), equals('Success(hello)'));
      });

      test('works with complex types', () {
        const result = Success<List<int>>([1, 2, 3]);
        expect(result.data, equals([1, 2, 3]));
      });
    });

    group('Failure', () {
      test('holds message correctly', () {
        const result = Failure<int>('oops');
        expect(result.message, equals('oops'));
        expect(result.error, isNull);
      });

      test('holds message and error', () {
        final error = Exception('underlying');
        final result = Failure<int>('oops', error);
        expect(result.message, equals('oops'));
        expect(result.error, equals(error));
      });

      test('equality works for same message', () {
        const a = Failure<int>('oops');
        const b = Failure<int>('oops');
        expect(a, equals(b));
      });

      test('inequality works for different messages', () {
        const a = Failure<int>('oops');
        const b = Failure<int>('nope');
        expect(a, isNot(equals(b)));
      });

      test('toString includes message and error', () {
        const result = Failure<int>('oops');
        expect(result.toString(), equals('Failure(oops, null)'));
      });
    });

    group('pattern matching', () {
      test('matches Success', () {
        const Result<int> result = Success(42);
        final value = switch (result) {
          Success(:final data) => 'got $data',
          Failure(:final message) => 'failed: $message',
        };
        expect(value, equals('got 42'));
      });

      test('matches Failure', () {
        const Result<int> result = Failure('oops');
        final value = switch (result) {
          Success(:final data) => 'got $data',
          Failure(:final message) => 'failed: $message',
        };
        expect(value, equals('failed: oops'));
      });

      test('exhaustive matching compiles', () {
        const Result<String> result = Success('hello');
        // This switch must be exhaustive at compile time
        // due to sealed class.
        final output = switch (result) {
          Success<String>() => true,
          Failure<String>() => false,
        };
        expect(output, isTrue);
      });
    });
  });
}
