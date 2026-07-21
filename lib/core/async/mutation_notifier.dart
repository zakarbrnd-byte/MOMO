import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/async_state.dart';
import 'simulated_backend.dart';

/// Runs a single async mutation with Idle → Loading → Success | Error.
///
/// Prevents overlapping runs while [AsyncOpLoading]. Shared by create/join/etc.
class MutationNotifier extends AutoDisposeNotifier<AsyncOpState<void>> {
  bool _disposed = false;

  @override
  AsyncOpState<void> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    return const AsyncOpIdle();
  }

  bool get isBusy => state.isLoading;

  /// Executes [action] after optional simulated delay.
  ///
  /// Returns `false` if already busy, failed, or disposed mid-flight.
  Future<bool> run(FutureOr<void> Function() action) async {
    if (isBusy) return false;

    state = const AsyncOpLoading();

    final config = ref.read(simulatedBackendProvider);
    try {
      if (config.delay > Duration.zero) {
        await Future<void>.delayed(config.delay);
      }

      if (_disposed) return false;

      if (config.failNext) {
        ref.read(simulatedBackendProvider.notifier).clearFailNext();
        throw Exception('Request failed. Please try again.');
      }

      await action();

      if (_disposed) return false;
      state = const AsyncOpSuccess(null);
      return true;
    } catch (error) {
      if (_disposed) return false;
      state = AsyncOpError(
        message: error is Exception
            ? error.toString().replaceFirst('Exception: ', '')
            : 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  void reset() {
    if (_disposed) return;
    state = const AsyncOpIdle();
  }
}

/// Create-playdate mutation lifecycle (separate from list [AsyncValue]).
final createPlaydateMutationProvider =
    NotifierProvider.autoDispose<MutationNotifier, AsyncOpState<void>>(
  MutationNotifier.new,
);

/// Create-post mutation lifecycle.
final createPostMutationProvider =
    NotifierProvider.autoDispose<MutationNotifier, AsyncOpState<void>>(
  MutationNotifier.new,
);

/// Join / leave can reuse the same pattern later via additional providers
/// or a [NotifierProvider.family].
final playdateParticipationMutationProvider =
    NotifierProvider.autoDispose<MutationNotifier, AsyncOpState<void>>(
  MutationNotifier.new,
);
