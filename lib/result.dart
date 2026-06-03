/// Sealed result type for all service operations.
///
/// Uses Dart 3 sealed classes for exhaustive pattern matching.
/// All service methods return `Result<T>` instead of throwing exceptions.
///
/// ```dart
/// switch (result) {
///   Success(:final data) => handleData(data),
///   Failure(:final message) => showError(message),
/// }
/// ```
sealed class Result<T> {
  /// Creates a [Result] instance.
  const Result();
}

/// A successful result containing [data].
class Success<T> extends Result<T> {
  /// The successful data payload.
  final T data;

  /// Creates a [Success] with the given [data].
  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// A failed result containing an error [message] and optional [error] object.
class Failure<T> extends Result<T> {
  /// Human-readable error message.
  final String message;

  /// Optional underlying error or exception.
  final Object? error;

  /// Creates a [Failure] with the given [message] and optional [error].
  const Failure(this.message, [this.error]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> && message == other.message && error == other.error;

  @override
  int get hashCode => Object.hash(message, error);

  @override
  String toString() => 'Failure($message, $error)';
}
