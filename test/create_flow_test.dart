import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/providers/main_tab_provider.dart';
import 'package:momo/providers/playdate_provider.dart';
import 'package:momo/providers/post_provider.dart';

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
  }

  Future<void> openCreatePlaydate(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Playdate'));
    await tester.pumpAndSettle();
  }

  Future<void> selectDateFromPicker(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('playdate_date_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  Future<void> selectTimeFromPicker(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('playdate_time_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  testWidgets('Create Playdate blocks submit without date', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    final initialCount = container.read(playdateProvider).length;
    await openCreatePlaydate(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Park Play Date');
    await tester.enterText(fields.at(3), 'Irvine Park');

    await tester.tap(find.widgetWithText(FilledButton, 'Create Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('Please select a date'), findsOneWidget);
    expect(container.read(playdateProvider).length, initialCount);
  });

  testWidgets('Create Playdate succeeds without time', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    await openCreatePlaydate(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Park Play Date');
    await selectDateFromPicker(tester);
    await tester.enterText(fields.at(3), 'Irvine Park');

    await tester.tap(find.widgetWithText(FilledButton, 'Create Playdate'));
    await tester.pumpAndSettle();

    expect(container.read(mainTabProvider), 0);
    expect(find.text('Playdate created successfully!'), findsOneWidget);
    expect(find.text('Park Play Date'), findsOneWidget);
    expect(find.text('Irvine Park'), findsOneWidget);
    expect(find.text('Please select a date'), findsNothing);
  });

  testWidgets('Create Playdate succeeds with selected time', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    await openCreatePlaydate(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Morning Meetup');
    await selectDateFromPicker(tester);
    await selectTimeFromPicker(tester);
    await tester.enterText(fields.at(3), 'Irvine Park');

    final timeField = tester.widget<TextFormField>(
      find.descendant(
        of: find.byKey(const Key('playdate_time_field')),
        matching: find.byType(TextFormField),
      ),
    );
    final timeText = timeField.controller?.text;
    expect(timeText, isNotNull);
    expect(timeText, isNotEmpty);

    await tester.tap(find.widgetWithText(FilledButton, 'Create Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('Morning Meetup'), findsOneWidget);
    expect(find.text(timeText!), findsWidgets);
  });

  testWidgets('Create Playdate blocks empty form with validation', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    final initialCount = container.read(playdateProvider).length;
    await openCreatePlaydate(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Create Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a title'), findsOneWidget);
    expect(find.text('Please select a date'), findsOneWidget);
    expect(find.text('Please select a location'), findsOneWidget);
    expect(container.read(playdateProvider).length, initialCount);
  });

  testWidgets('Create Post blocks empty form with validation', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    final initialCount = container.read(postProvider).length;

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Post'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Create Post'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a post title'), findsOneWidget);
    expect(find.text('Please write some content'), findsOneWidget);
    expect(container.read(postProvider).length, initialCount);
  });

  testWidgets('Create Post appears on Home feed', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Post'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Best playground recommendations?');
    await tester.enterText(
      fields.at(1),
      'Looking for toddler-friendly parks nearby.',
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Create Post'));
    await tester.pumpAndSettle();

    expect(container.read(mainTabProvider), 0);
    expect(find.text('Post created successfully!'), findsOneWidget);
    expect(find.text('Best playground recommendations?'), findsOneWidget);
  });
}
