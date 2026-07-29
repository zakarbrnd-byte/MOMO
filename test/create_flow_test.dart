import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/core/async/mutation_notifier.dart';
import 'package:momo/core/async/simulated_backend.dart';
import 'package:momo/core/widgets/error_view.dart';
import 'package:momo/core/widgets/loading_view.dart';
import 'package:momo/navigation/app_navigation.dart';
import 'package:momo/providers/group_provider.dart';
import 'package:momo/providers/main_tab_provider.dart';
import 'package:momo/providers/post_provider.dart';

import 'support/test_overrides.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, ProviderContainer container) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MomoApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  ProviderContainer newContainer({List<Override> extra = const []}) {
    final container = ProviderContainer(
      overrides: [...testBackendOverrides, ...extra],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> openCreateGroup(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Group'));
    await tester.pumpAndSettle();
  }

  Future<void> openCreatePost(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Post'));
    await tester.pumpAndSettle();
  }

  testWidgets('Create hub offers Group and Post only', (tester) async {
    final container = newContainer();
    await pumpApp(tester, container);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    expect(find.text('Create Group'), findsOneWidget);
    expect(find.text('Create Post'), findsOneWidget);
    expect(find.text('Create Playdate'), findsNothing);
    expect(
      find.textContaining('Event Announcements: open a Group'),
      findsOneWidget,
    );
  });

  testWidgets('Create shows event gate when user joined zero groups',
      (tester) async {
    final container = newContainer();
    await pumpApp(tester, container);

    for (final id in container.read(currentUserGroupIdsProvider).toList()) {
      container.read(groupProvider.notifier).leaveGroup(id);
    }
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    expect(
      find.text('이벤트 공지를 만들려면 먼저 모임에 가입해야 합니다.'),
      findsOneWidget,
    );
    expect(find.text('모임 찾아보기'), findsOneWidget);

    await tester.tap(find.text('모임 찾아보기'));
    await tester.pumpAndSettle();
    expect(container.read(mainTabProvider), MainTabs.home);
  });

  testWidgets('Create Group blocks submit without required fields',
      (tester) async {
    final container = newContainer();
    await pumpApp(tester, container);

    final initialCount = container.read(groupProvider).requireValue.length;
    await openCreateGroup(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Create Group'));
    await tester.pumpAndSettle();

    expect(find.text('이름, 소개, 지역은 필수입니다.'), findsOneWidget);
    expect(container.read(groupProvider).requireValue.length, initialCount);
  });

  testWidgets('Create Group succeeds and appears on Home', (tester) async {
    final container = newContainer();
    await pumpApp(tester, container);

    await openCreateGroup(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Park Moms Group');
    await tester.enterText(fields.at(1), 'Weekly park meetups for toddlers.');
    await tester.enterText(fields.at(3), 'Irvine Park');

    await tester.tap(find.widgetWithText(FilledButton, 'Create Group'));
    await tester.pumpAndSettle();

    expect(container.read(mainTabProvider), MainTabs.home);
    expect(find.text('Group created'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Park Moms Group'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Park Moms Group'), findsOneWidget);
  });

  testWidgets('Create Post blocks empty form with validation', (tester) async {
    final container = newContainer();
    await pumpApp(tester, container);

    final initialCount = container.read(postProvider).requireValue.length;

    await openCreatePost(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Create Post'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a title.'), findsOneWidget);
    expect(find.text('Please enter content.'), findsOneWidget);
    expect(container.read(postProvider).requireValue.length, initialCount);
  });

  testWidgets('Create Post appears on Home feed', (tester) async {
    final container = newContainer();
    await pumpApp(tester, container);

    await openCreatePost(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Best playground recommendations?');
    await tester.enterText(
      fields.at(1),
      'Looking for toddler-friendly parks nearby.',
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Create Post'));
    await tester.pumpAndSettle();

    expect(container.read(mainTabProvider), MainTabs.home);
    expect(find.text('Post created successfully!'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Best playground recommendations?'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Best playground recommendations?'), findsOneWidget);
  });

  testWidgets('Create Post shows loading then success', (tester) async {
    final container = ProviderContainer(
      overrides: [
        simulatedBackendProvider.overrideWith(
          () => _DelayedBackend(const Duration(milliseconds: 400)),
        ),
      ],
    );
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    await openCreatePost(tester);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Loading Flow Post');
    await tester.enterText(fields.at(1), 'Checking loading state.');

    await tester.tap(find.widgetWithText(FilledButton, 'Create Post'));
    await tester.pump();
    expect(find.byType(LoadingView), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Loading Flow Post'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Loading Flow Post'), findsOneWidget);
    expect(find.text('Post created successfully!'), findsOneWidget);
  });

  testWidgets('Create error then retry succeeds', (tester) async {
    final container = newContainer();
    await pumpApp(tester, container);

    container.read(simulatedBackendProvider.notifier).armFailure();

    await openCreatePost(tester);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Retry Post');
    await tester.enterText(fields.at(1), 'Retry after failure.');

    final before = container.read(postProvider).requireValue.length;

    await tester.tap(find.widgetWithText(FilledButton, 'Create Post'));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Could not create post'), findsOneWidget);
    expect(container.read(postProvider).requireValue.length, before);

    await tester.tap(find.widgetWithText(FilledButton, 'Try again'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Retry Post'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Retry Post'), findsOneWidget);
    expect(container.read(postProvider).requireValue.length, before + 1);
  });

  testWidgets('Double tap Create only adds one post', (tester) async {
    final container = ProviderContainer(
      overrides: [
        simulatedBackendProvider.overrideWith(
          () => _DelayedBackend(const Duration(milliseconds: 300)),
        ),
      ],
    );
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    await openCreatePost(tester);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Single Create');
    await tester.enterText(fields.at(1), 'Only one please.');

    final before = container.read(postProvider).requireValue.length;

    await tester.tap(find.widgetWithText(FilledButton, 'Create Post'));
    await tester.pump();
    await tester.tap(find.text('Create Post'));
    await tester.pump();

    final mid = container.read(createPostMutationProvider);
    expect(mid.isLoading, isTrue);

    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    final created = container
        .read(postProvider)
        .requireValue
        .where((item) => item.title == 'Single Create');
    expect(created.length, 1);
    expect(container.read(postProvider).requireValue.length, before + 1);
  });
}

class _DelayedBackend extends SimulatedBackendNotifier {
  _DelayedBackend(this.delay);

  final Duration delay;

  @override
  SimulatedBackendConfig build() => SimulatedBackendConfig(delay: delay);
}
