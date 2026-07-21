import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
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

  testWidgets('Journey: Home → Playdate detail → Back → Home', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Saturday Park Playdate'));
    await tester.pumpAndSettle();
    expect(find.text('Join Playdate'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Saturday Park Playdate'), findsOneWidget);
    expect(find.text('MOMO'), findsOneWidget);
  });

  testWidgets('Journey: Create Playdate → submit → Home tab', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    expect(container.read(mainTabProvider), MainTabs.create);

    await tester.tap(find.text('Create Playdate'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Nav Flow Playdate');
    await tester.tap(find.byKey(const Key('playdate_date_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.enterText(fields.at(3), 'Irvine Park');

    await tester.tap(find.widgetWithText(FilledButton, 'Create Playdate'));
    await tester.pumpAndSettle();

    expect(container.read(mainTabProvider), MainTabs.home);
    expect(find.text('Nav Flow Playdate'), findsOneWidget);
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

  testWidgets('Tab switch keeps bottom bar; re-tap Home closes detail', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.text('Saturday Park Playdate'));
    await tester.pumpAndSettle();
    expect(find.text('Join Playdate'), findsOneWidget);

    // Bottom bar stays available on detail.
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(container.read(mainTabProvider), MainTabs.profile);
    expect(find.text('Jiwoo Mom'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(container.read(mainTabProvider), MainTabs.home);
    // Home tab stack preserved — detail still open.
    expect(find.text('Join Playdate'), findsOneWidget);

    // Re-tap Home to pop to feed root.
    await tester.tap(find.byIcon(Icons.home_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Saturday Park Playdate'), findsOneWidget);
    expect(find.text('Join Playdate'), findsNothing);
  });

  testWidgets('Create back returns to Create selection', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Playdate'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('What would you like to share?'), findsOneWidget);
    expect(find.text('Create Playdate'), findsOneWidget);
    expect(find.text('Create Post'), findsOneWidget);
  });
}
