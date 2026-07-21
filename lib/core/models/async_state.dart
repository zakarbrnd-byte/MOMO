/// Generic lifecycle for any asynchronous operation.
///
/// Named `AsyncOp*` to avoid clashing with Riverpod's `AsyncValue` helpers
/// (`AsyncLoading`, `AsyncError`, etc.).
///
/// Use across create, join, leave, feed load, auth, and future API calls.
sealed class AsyncOpState<T> {
  const AsyncOpState();

  bool get isIdle => this is AsyncOpIdle<T>;
  bool get isLoading => this is AsyncOpLoading<T>;
  bool get isSuccess => this is AsyncOpSuccess<T>;
  bool get isError => this is AsyncOpError<T>;
}

/// No operation in progress.
final class AsyncOpIdle<T> extends AsyncOpState<T> {
  const AsyncOpIdle();
}

/// Request is in flight.
final class AsyncOpLoading<T> extends AsyncOpState<T> {
  const AsyncOpLoading();
}

/// Operation finished successfully.
final class AsyncOpSuccess<T> extends AsyncOpState<T> {
  const AsyncOpSuccess(this.data);

  final T data;
}

/// Operation failed; [message] is safe to show in UI.
final class AsyncOpError<T> extends AsyncOpState<T> {
  const AsyncOpError({required this.message});

  final String message;
}
