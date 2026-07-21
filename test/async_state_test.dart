import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/core/async/mutation_notifier.dart';
import 'package:momo/core/async/simulated_backend.dart';
import 'package:momo/core/models/async_state.dart';

import 'support/test_overrides.dart';

void main() {
  group('AsyncOpState', () {
    test('flags match variants', () {
      const idle = AsyncOpIdle<void>();
      const loading = AsyncOpLoading<void>();
      const success = AsyncOpSuccess<int>(1);
      const error = AsyncOpError<void>(message: 'boom');

      expect(idle.isIdle, isTrue);
      expect(loading.isLoading, isTrue);
      expect(success.isSuccess, isTrue);
      expect(success.data, 1);
      expect(error.isError, isTrue);
      expect(error.message, 'boom');
    });
  });

  group('MutationNotifier', () {
    test('runs idle → loading → success', () async {
      final container = ProviderContainer(overrides: testBackendOverrides);
      addTearDown(container.dispose);
      final sub = container.listen(createPlaydateMutationProvider, (_, __) {});
      addTearDown(sub.close);

      final notifier = container.read(createPlaydateMutationProvider.notifier);
      expect(container.read(createPlaydateMutationProvider).isIdle, isTrue);

      final future = notifier.run(() {});
      expect(container.read(createPlaydateMutationProvider).isLoading, isTrue);

      final ok = await future;
      expect(ok, isTrue);
      expect(container.read(createPlaydateMutationProvider).isSuccess, isTrue);
    });

    test('blocks overlapping runs', () async {
      final container = ProviderContainer(
        overrides: [
          simulatedBackendProvider.overrideWith(
            () => _DelayBackend(const Duration(milliseconds: 50)),
          ),
        ],
      );
      addTearDown(container.dispose);
      final sub = container.listen(createPlaydateMutationProvider, (_, __) {});
      addTearDown(sub.close);

      final notifier = container.read(createPlaydateMutationProvider.notifier);
      var calls = 0;

      final first = notifier.run(() => calls++);
      final second = await notifier.run(() => calls++);

      expect(second, isFalse);
      expect(await first, isTrue);
      expect(calls, 1);
    });

    test('failNext then retry succeeds', () async {
      final container = ProviderContainer(overrides: testBackendOverrides);
      addTearDown(container.dispose);
      final sub = container.listen(createPlaydateMutationProvider, (_, __) {});
      addTearDown(sub.close);

      container.read(simulatedBackendProvider.notifier).armFailure();
      final notifier = container.read(createPlaydateMutationProvider.notifier);

      final failed = await notifier.run(() {});
      expect(failed, isFalse);
      expect(container.read(createPlaydateMutationProvider).isError, isTrue);

      final ok = await notifier.run(() {});
      expect(ok, isTrue);
      expect(container.read(createPlaydateMutationProvider).isSuccess, isTrue);
    });
  });
}

class _DelayBackend extends SimulatedBackendNotifier {
  _DelayBackend(this.delay);

  final Duration delay;

  @override
  SimulatedBackendConfig build() => SimulatedBackendConfig(delay: delay);
}
