import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Local-only knobs that mimic backend latency / failures.
///
/// Set [failNext] to `true` in debug to exercise Error → Retry.
/// Flip [delay] to [Duration.zero] (or via test override) to disable simulation.
class SimulatedBackendConfig {
  const SimulatedBackendConfig({
    this.delay = const Duration(milliseconds: 600),
    this.failNext = false,
  });

  /// Artificial wait before local mutations complete.
  final Duration delay;

  /// When true, the next [MutationNotifier.run] fails once, then clears.
  final bool failNext;

  SimulatedBackendConfig copyWith({
    Duration? delay,
    bool? failNext,
  }) {
    return SimulatedBackendConfig(
      delay: delay ?? this.delay,
      failNext: failNext ?? this.failNext,
    );
  }
}

class SimulatedBackendNotifier extends Notifier<SimulatedBackendConfig> {
  @override
  SimulatedBackendConfig build() => const SimulatedBackendConfig();

  void setDelay(Duration delay) {
    state = state.copyWith(delay: delay);
  }

  /// Enable a one-shot failure for the next mutation (dev / tests).
  void armFailure() {
    state = state.copyWith(failNext: true);
  }

  void clearFailNext() {
    state = state.copyWith(failNext: false);
  }

  /// Disable latency simulation (useful in tests).
  void disableSimulation() {
    state = const SimulatedBackendConfig(delay: Duration.zero);
  }
}

final simulatedBackendProvider =
    NotifierProvider<SimulatedBackendNotifier, SimulatedBackendConfig>(
  SimulatedBackendNotifier.new,
);
