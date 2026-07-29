import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/data/mock_user.dart';
import 'package:momo/features/create/create_playdate_screen.dart';
import 'package:momo/features/detail/playdate_detail_screen.dart';
import 'package:momo/providers/playdate_provider.dart';

import 'support/test_overrides.dart';

/// Capacity rules for dormant Playdate layer (not Home / Create hub).
void main() {
  Future<ProviderContainer> pumpDetailById(
    WidgetTester tester,
    String playdateId,
  ) async {
    tester.view.physicalSize = const Size(400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(overrides: testBackendOverrides);
    addTearDown(container.dispose);
    await container.read(playdateProvider.future);

    final playdate = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.id == playdateId);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: PlaydateDetailScreen(playdate: playdate),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('Create unlimited playdate shows 0 joined for owner',
      (tester) async {
    final container = ProviderContainer(overrides: testBackendOverrides);
    addTearDown(container.dispose);
    await container.read(playdateProvider.future);

    container.read(playdateProvider.notifier).createPlaydate(
          title: 'Unlimited Park Day',
          date: 'Sat',
          time: '',
          location: 'Irvine Park',
          childAge: '',
          description: '',
        );

    final created = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.title == 'Unlimited Park Day');
    expect(created.maxParticipants, isNull);
    expect(created.creatorId, currentUser.id);
    expect(created.participantsLabel, '0 joined');

    tester.view.physicalSize = const Size(400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: PlaydateDetailScreen(playdate: created),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('0 joined'), findsWidgets);
    expect(find.text('My Playdate'), findsOneWidget);
    expect(find.text('Cancel Playdate'), findsOneWidget);
    expect(find.text('Leave Playdate'), findsNothing);
  });

  testWidgets('Create limited playdate stores capacity', (tester) async {
    final container = ProviderContainer(overrides: testBackendOverrides);
    addTearDown(container.dispose);
    await container.read(playdateProvider.future);

    container.read(playdateProvider.notifier).createPlaydate(
          title: 'Limited Park Day',
          date: 'Sat',
          time: '',
          location: 'Irvine Park',
          childAge: '',
          description: '',
          maxParticipants: 5,
        );

    final created = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.title == 'Limited Park Day');
    expect(created.maxParticipants, 5);
    expect(created.participantsLabel, '0 / 5 joined');

    tester.view.physicalSize = const Size(400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: PlaydateDetailScreen(playdate: created),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('0 / 5 joined'), findsWidgets);
    expect(find.text('Edit Playdate'), findsOneWidget);
  });

  testWidgets('Invalid capacity shows validation error', (tester) async {
    tester.view.physicalSize = const Size(400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: testBackendOverrides,
        child: const MaterialApp(home: CreatePlaydateScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Bad Capacity Day');
    await tester.tap(find.byKey(const Key('playdate_date_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.enterText(fields.at(3), 'Irvine Park');

    final capacity = find.byKey(const Key('playdate_capacity_field'));
    await tester.enterText(capacity, '0');
    await tester.tap(find.widgetWithText(FilledButton, 'Create Playdate'));
    await tester.pumpAndSettle();
    expect(
        find.text('Please enter a valid participant limit.'), findsOneWidget);

    await tester.enterText(capacity, '');
    final field = tester.widget<TextFormField>(
      find.descendant(
        of: capacity,
        matching: find.byType(TextFormField),
      ),
    );
    field.controller!.text = 'abc';
    await tester.tap(find.widgetWithText(FilledButton, 'Create Playdate'));
    await tester.pumpAndSettle();
    expect(
        find.text('Please enter a valid participant limit.'), findsOneWidget);
  });

  testWidgets('Unlimited mock playdate label has no capacity slash',
      (tester) async {
    await pumpDetailById(tester, 'pd2');

    expect(find.text('3 joined'), findsWidgets);
    expect(find.text('Join Playdate'), findsOneWidget);
  });

  testWidgets('Join until full then leave still works', (tester) async {
    final container = await pumpDetailById(tester, 'pd4');

    expect(find.text('4 / 5 joined'), findsWidgets);

    await tester.tap(find.widgetWithText(FilledButton, 'Join Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('5 / 5 joined'), findsWidgets);
    expect(find.text('Leave Playdate'), findsOneWidget);

    final full = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.id == 'pd4');
    expect(full.isFull, isTrue);
    expect(full.isJoinedBy(currentUser.id), isTrue);

    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first))
        .clearSnackBars();
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Leave Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('4 / 5 joined'), findsWidgets);
    expect(find.text('Join Playdate'), findsOneWidget);
  });
}
