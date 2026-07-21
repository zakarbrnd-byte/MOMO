import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/core/models/async_state.dart';
import 'package:momo/core/widgets/error_view.dart';
import 'package:momo/core/widgets/loading_view.dart';
import 'package:momo/debug/debug_panel.dart';
import 'package:momo/debug/debug_provider.dart';
import 'package:momo/navigation/app_navigation.dart';
import 'package:momo/providers/main_tab_provider.dart';

import 'support/test_overrides.dart';

void main() {
  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(overrides: testBackendOverrides);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MomoApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  test('simulateLoading returns to Idle', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(debugSessionProvider.notifier);
    final future = notifier.simulateLoading();
    expect(container.read(debugSessionProvider).opState.isLoading, isTrue);
    expect(container.read(debugSessionProvider).lastAction, 'Simulate Loading');

    await future;
    expect(container.read(debugSessionProvider).opState.isIdle, isTrue);
  });

  test('simulateError then retry reaches Success', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(debugSessionProvider.notifier);
    notifier.simulateError();

    final session = container.read(debugSessionProvider);
    expect(session.opState, isA<AsyncOpError>());
    expect(
      (session.opState as AsyncOpError).message,
      'Simulated network error.',
    );

    await notifier.retryAfterError();
    expect(container.read(debugSessionProvider).opState.isSuccess, isTrue);
    expect(container.read(debugSessionProvider).lastAction, 'Retry → Success');
  });

  test('simulateSuccess then Idle', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(debugSessionProvider.notifier).simulateSuccess();
    expect(container.read(debugSessionProvider).opState.isIdle, isTrue);
    expect(container.read(debugSessionProvider).lastAction, 'Simulate Success');
  });

  test('reset returns Idle', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(debugSessionProvider.notifier);
    notifier.simulateError();
    notifier.reset();

    expect(container.read(debugSessionProvider).opState.isIdle, isTrue);
    expect(container.read(debugSessionProvider).lastAction, 'Reset State');
  });

  testWidgets('Debug FAB opens panel with live info', (tester) async {
    expect(isDeveloperDebugPanelEnabled, isTrue);

    final container = await pumpApp(tester);

    expect(find.byKey(const Key('debug_fab')), findsOneWidget);

    await tester.tap(find.byKey(const Key('debug_fab')));
    await tester.pumpAndSettle();

    expect(find.text('Developer Debug'), findsOneWidget);
    expect(find.text('Idle'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);

    container.read(mainTabProvider.notifier).state = MainTabs.profile;
    await tester.pump();

    expect(
      find.descendant(
        of: find.byType(DebugPanel),
        matching: find.text('Profile'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Simulate Loading shows LoadingView then clears', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('debug_fab')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simulate Loading'));
    await tester.pump();

    expect(find.byType(LoadingView), findsOneWidget);

    await tester.pump(DebugSessionNotifier.loadingDuration);
    await tester.pumpAndSettle();

    expect(find.byType(LoadingView), findsNothing);
  });

  testWidgets('Simulate Error → Retry → Success overlay flow', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.byKey(const Key('debug_fab')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simulate Error'));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Simulated network error.'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Try again'));
    await tester.pump();
    expect(find.byType(LoadingView), findsOneWidget);

    await tester.pump(DebugSessionNotifier.loadingDuration);
    await tester.pumpAndSettle();

    expect(container.read(debugSessionProvider).opState.isSuccess, isTrue);
    expect(find.byType(ErrorView), findsNothing);
    expect(find.byType(LoadingView), findsNothing);
  });

  testWidgets('Reset State clears error overlay', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('debug_fab')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simulate Error'));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorView), findsOneWidget);

    await tester.tap(find.byKey(const Key('debug_fab')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset State'));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorView), findsNothing);
    expect(find.text('Developer Debug'), findsOneWidget);
    expect(find.text('Idle'), findsOneWidget);
  });
}
