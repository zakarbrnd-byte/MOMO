import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/data/mock_groups.dart';
import 'package:momo/navigation/app_navigation.dart';
import 'package:momo/providers/group_provider.dart';
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

  testWidgets('Journey: Home → Group detail → Back → Home', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.textContaining('LA 3살'));
    await tester.pumpAndSettle();
    expect(find.text('Leave Group'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.textContaining('LA 3살'), findsOneWidget);
    expect(find.text('MOMO'), findsOneWidget);
  });

  testWidgets('Journey: Create Group → submit → Home tab', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    expect(container.read(mainTabProvider), MainTabs.create);

    await tester.tap(find.text('Create Group'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Nav Flow Group');
    await tester.enterText(fields.at(1), 'A test community for navigation.');
    await tester.enterText(fields.at(3), 'Irvine');

    await tester.tap(find.widgetWithText(FilledButton, 'Create Group'));
    await tester.pumpAndSettle();

    expect(container.read(mainTabProvider), MainTabs.home);
    await tester.scrollUntilVisible(
      find.text('Nav Flow Group'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Nav Flow Group'), findsOneWidget);
    expect(find.text('What would you like to share?'), findsNothing);
  });

  testWidgets('Journey: Create Post → submit → Home tab', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Post'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Nav Flow Post');
    await tester.enterText(fields.at(1), 'Checking create navigation.');

    await tester.tap(find.widgetWithText(FilledButton, 'Create Post'));
    await tester.pumpAndSettle();

    expect(container.read(mainTabProvider), MainTabs.home);
    await tester.scrollUntilVisible(
      find.text('Nav Flow Post'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Nav Flow Post'), findsOneWidget);
  });

  testWidgets('Journey: Profile tab and return Home', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(container.read(mainTabProvider), MainTabs.profile);
    expect(find.text('Jiwoo Mom'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(container.read(mainTabProvider), MainTabs.home);
    expect(find.text('MOMO'), findsOneWidget);
  });

  testWidgets('Tab switch keeps bottom bar; re-tap Home closes detail',
      (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.textContaining('LA 3살'));
    await tester.pumpAndSettle();
    expect(find.text('Leave Group'), findsOneWidget);

    // Bottom bar stays available on detail.
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(container.read(mainTabProvider), MainTabs.profile);
    expect(find.text('Jiwoo Mom'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(container.read(mainTabProvider), MainTabs.home);
    // Home tab stack preserved — detail still open.
    expect(find.text('Leave Group'), findsOneWidget);

    // Re-tap Home to pop to feed root.
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.textContaining('LA 3살'), findsOneWidget);
    expect(find.text('Leave Group'), findsNothing);
  });

  testWidgets('Bottom nav shows Home Create Groups Profile', (tester) async {
    await pumpApp(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Groups'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Groups tab badge shows joined count and hides at zero',
      (tester) async {
    final container = await pumpApp(tester);

    // Seeded: LA3 + park → badge "2"
    expect(find.byType(Badge), findsWidgets);
    expect(find.text('2'), findsOneWidget);

    for (final id in container.read(currentUserGroupIdsProvider).toList()) {
      container.read(groupProvider.notifier).leaveGroup(id);
    }
    await tester.pumpAndSettle();

    expect(find.text('2'), findsNothing);
    expect(find.byType(Badge), findsNothing);
  });

  testWidgets('Journey: Groups tab shows joined groups', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.groups_outlined));
    await tester.pumpAndSettle();
    expect(container.read(mainTabProvider), MainTabs.groups);
    expect(find.widgetWithText(AppBar, '내 모임'), findsOneWidget);
    expect(find.textContaining('LA 3살'), findsOneWidget);
  });

  testWidgets('Create back returns to Create selection', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Group'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('What would you like to share?'), findsOneWidget);
    expect(find.text('Create Group'), findsOneWidget);
    expect(find.text('Create Post'), findsOneWidget);
    expect(find.text('Create Playdate'), findsNothing);
  });

  testWidgets('Home has no Playdate cards', (tester) async {
    await pumpApp(tester);

    expect(find.text(groupLa3.name), findsOneWidget);
    expect(find.text('Join Playdate'), findsNothing);
    expect(find.text('Create Playdate'), findsNothing);
  });
}
