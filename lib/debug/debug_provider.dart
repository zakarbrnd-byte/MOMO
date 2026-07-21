import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/async_state.dart';

/// Master switch for the developer panel.
///
/// Set to `false` (or delete `lib/debug/`) to remove the panel without
/// touching business logic. Still requires [kDebugMode] to appear.
const bool kEnableDeveloperDebugPanel = true;

/// True only in Debug builds when the panel is enabled.
bool get isDeveloperDebugPanelEnabled =>
    !kReleaseMode && kDebugMode && kEnableDeveloperDebugPanel;

/// Live session state for the developer debug panel.
@immutable
class DebugSession {
  const DebugSession({
    this.opState = const AsyncOpIdle(),
    this.lastAction = 'None',
  });

  final AsyncOpState<void> opState;
  final String lastAction;

  String get opStateLabel {
    return switch (opState) {
      AsyncOpIdle() => 'Idle',
      AsyncOpLoading() => 'Loading',
      AsyncOpSuccess() => 'Success',
      AsyncOpError() => 'Error',
    };
  }

  DebugSession copyWith({
    AsyncOpState<void>? opState,
    String? lastAction,
  }) {
    return DebugSession(
      opState: opState ?? this.opState,
      lastAction: lastAction ?? this.lastAction,
    );
  }
}

/// Simulates Idle → Loading → Success | Error without touching product data.
class DebugSessionNotifier extends Notifier<DebugSession> {
  static const loadingDuration = Duration(seconds: 2);
  static const successHoldDuration = Duration(milliseconds: 800);

  bool _disposed = false;

  @override
  DebugSession build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    return const DebugSession();
  }

  void recordAction(String action) {
    if (!isDeveloperDebugPanelEnabled) return;
    state = state.copyWith(lastAction: action);
  }

  /// Loading for ~2s, then Idle.
  Future<void> simulateLoading() async {
    state = state.copyWith(
      opState: const AsyncOpLoading(),
      lastAction: 'Simulate Loading',
    );
    await Future<void>.delayed(loadingDuration);
    if (_disposed) return;
    state = state.copyWith(opState: const AsyncOpIdle());
  }

  /// Error with fixed message. Retry handled by [retryAfterError].
  void simulateError() {
    state = state.copyWith(
      opState: const AsyncOpError(message: 'Simulated network error.'),
      lastAction: 'Simulate Error',
    );
  }

  /// Retry from error: Loading → Success.
  Future<void> retryAfterError() async {
    state = state.copyWith(
      opState: const AsyncOpLoading(),
      lastAction: 'Retry',
    );
    await Future<void>.delayed(loadingDuration);
    if (_disposed) return;
    state = state.copyWith(
      opState: const AsyncOpSuccess(null),
      lastAction: 'Retry → Success',
    );
  }

  /// Brief loading then Success (completion flow).
  Future<void> simulateSuccess() async {
    state = state.copyWith(
      opState: const AsyncOpLoading(),
      lastAction: 'Simulate Success',
    );
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (_disposed) return;
    state = state.copyWith(opState: const AsyncOpSuccess(null));
    await Future<void>.delayed(successHoldDuration);
    if (_disposed) return;
    state = state.copyWith(opState: const AsyncOpIdle());
  }

  void reset() {
    state = state.copyWith(
      opState: const AsyncOpIdle(),
      lastAction: 'Reset State',
    );
  }
}

final debugSessionProvider =
    NotifierProvider<DebugSessionNotifier, DebugSession>(
  DebugSessionNotifier.new,
);
