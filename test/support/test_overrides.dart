import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/core/async/simulated_backend.dart';

/// Zero-latency backend simulation for widget tests.
class InstantSimulatedBackend extends SimulatedBackendNotifier {
  @override
  SimulatedBackendConfig build() =>
      const SimulatedBackendConfig(delay: Duration.zero);
}

/// Default overrides so create flows stay fast in tests.
List<Override> get testBackendOverrides => [
      simulatedBackendProvider.overrideWith(InstantSimulatedBackend.new),
    ];
