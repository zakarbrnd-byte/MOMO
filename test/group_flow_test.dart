import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/data/mock_groups.dart';
import 'package:momo/providers/group_provider.dart';

import 'support/test_overrides.dart';

void main() {
  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 1200);
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

  testWidgets('Home shows group names and no Playdate / Create Playdate',
      (tester) async {
    await pumpApp(tester);

    expect(find.textContaining('LA 3살'), findsOneWidget);
    expect(find.text(groupOcWork.name), findsOneWidget);
    expect(find.text('Create Playdate'), findsNothing);
    expect(find.text('Join Playdate'), findsNothing);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    expect(find.text('Create Group'), findsOneWidget);
    expect(find.text('Create Post'), findsOneWidget);
    expect(find.text('Create Playdate'), findsNothing);
  });

  testWidgets('Tap group opens Group Detail', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.textContaining('LA 3살'));
    await tester.pumpAndSettle();

    expect(find.text(groupLa3.name), findsWidgets);
    expect(find.text('Leave Group'), findsOneWidget);
    expect(find.text('Posts'), findsOneWidget);
    expect(find.text('Events'), findsOneWidget);
    expect(find.text('Members'), findsOneWidget);
  });

  testWidgets('Join and Leave updates membership', (tester) async {
    final container = await pumpApp(tester);

    // OC group: current user is not a member.
    await tester.scrollUntilVisible(
      find.text(groupOcWork.name),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(groupOcWork.name));
    await tester.pumpAndSettle();

    expect(find.text('Join Group'), findsOneWidget);
    final before = container
        .read(groupProvider)
        .requireValue
        .firstWhere((g) => g.id == groupOcWork.id)
        .memberCount;

    await tester.tap(find.widgetWithText(FilledButton, 'Join Group'));
    await tester.pumpAndSettle();

    expect(find.text('Leave Group'), findsOneWidget);
    expect(
      container
          .read(groupProvider)
          .requireValue
          .firstWhere((g) => g.id == groupOcWork.id)
          .memberCount,
      before + 1,
    );
    expect(
      container.read(groupProvider.notifier).isMember(groupOcWork.id),
      isTrue,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Leave Group'));
    await tester.pumpAndSettle();

    expect(find.text('Join Group'), findsOneWidget);
    expect(
      container
          .read(groupProvider)
          .requireValue
          .firstWhere((g) => g.id == groupOcWork.id)
          .memberCount,
      before,
    );
    expect(
      container.read(groupProvider.notifier).isMember(groupOcWork.id),
      isFalse,
    );
  });

  testWidgets('Group detail shows posts and events', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.textContaining('LA 3살'));
    await tester.pumpAndSettle();

    // Posts tab (default)
    expect(find.text('이번 주 Lafayette Park 가실 분?'), findsOneWidget);
    expect(find.text('낮잠 안 자는 아이 어떻게 하세요?'), findsOneWidget);

    await tester.tap(find.text('Events'));
    await tester.pumpAndSettle();

    expect(find.text(eventLa3Park.title), findsOneWidget);
    expect(find.text(eventLa3Library.title), findsOneWidget);
  });

  testWidgets('RSVP attending and not attending', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.textContaining('LA 3살'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Events'));
    await tester.pumpAndSettle();

    // Library event: current user has no RSVP yet.
    await tester.tap(find.text(eventLa3Library.title));
    await tester.pumpAndSettle();

    expect(find.text('Event Announcement'), findsOneWidget);
    expect(find.text(eventLa3Library.title), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, '참석'));
    await tester.pumpAndSettle();
    expect(find.text('참석 ✓'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, '불참'));
    await tester.pumpAndSettle();
    expect(find.text('불참 ✓'), findsOneWidget);
    expect(find.text('참석'), findsOneWidget);
  });
}
