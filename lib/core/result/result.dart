/// Functional result of a repository / data-source operation.
///
/// Prefer returning [Result] over throwing for expected business failures
/// (e.g. join when full). Unexpected bugs may still throw.
///
/// Flow: Data Source → Repository ([Result]) → Provider → UI state
/// ([AsyncOpState] / [AsyncValue]). Repositories never show UI.
sealed class Result<T> {
  const Result();

  static Result<T> success<T>(T data) => Success<T>(data);

  static Result<T> failure<T>(String message) => Failure<T>(message);

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  String? get errorOrNull => switch (this) {
        Success() => null,
        Failure(:final message) => message,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(String message) failure,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Failure(:final message) => failure(message),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.message);

  /// Safe to surface in UI (via providers → error widgets / banners).
  final String message;
}
