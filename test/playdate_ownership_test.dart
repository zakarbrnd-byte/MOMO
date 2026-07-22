import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/data/mock_user.dart';
import 'package:momo/providers/playdate_provider.dart';

import 'support/test_overrides.dart';

void main() {
  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 1000);
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

  Future<void> openCreatePlaydate(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Playdate'));
    await tester.pumpAndSettle();
  }

  Future<void> fillRequiredPlaydateFields(
    WidgetTester tester, {
    required String title,
  }) async {
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), title);
    await tester.tap(find.byKey(const Key('playdate_date_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.enterText(fields.at(3), 'Irvine Park');
  }

  testWidgets('Create assigns creatorId and starts with zero participants',
      (tester) async {
    final container = await pumpApp(tester);
    await openCreatePlaydate(tester);
    await fillRequiredPlaydateFields(tester, title: 'Owned Park Day');

    await tester.enterText(
      find.byKey(const Key('playdate_capacity_field')),
      '3',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Create Playdate'));
    await tester.pumpAndSettle();

    final created = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.title == 'Owned Park Day');

    expect(created.creatorId, currentUser.id);
    expect(created.participantIds, isEmpty);
    expect(created.participantsLabel, '0 / 3 joined');
    expect(find.text('Created by you'), findsWidgets);
  });

  testWidgets('Owner detail shows Edit/Cancel, not Join/Leave', (tester) async {
    await pumpApp(tester);

    await tester.scrollUntilVisible(
      find.text('Neighborhood Walk & Play'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Neighborhood Walk & Play'));
    await tester.pumpAndSettle();

    expect(find.text('My Playdate'), findsOneWidget);
    expect(find.text('Edit Playdate'), findsOneWidget);
    expect(find.text('Cancel Playdate'), findsOneWidget);
    expect(find.text('Join Playdate'), findsNothing);
    expect(find.text('Leave Playdate'), findsNothing);
  });

  testWidgets('Non-owner detail keeps Join/Leave', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Saturday Park Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('Join Playdate'), findsOneWidget);
    expect(find.text('Edit Playdate'), findsNothing);
    expect(find.text('Cancel Playdate'), findsNothing);
  });

  testWidgets('Owner cancel removes playdate from feed', (tester) async {
    final container = await pumpApp(tester);

    await tester.scrollUntilVisible(
      find.text('Neighborhood Walk & Play'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Neighborhood Walk & Play'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Cancel Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('Cancel this Playdate?'), findsOneWidget);
    await tester.tap(
      find.widgetWithText(FilledButton, 'Cancel Playdate').last,
    );
    await tester.pumpAndSettle();

    expect(
      container
          .read(playdateProvider)
          .requireValue
          .any((item) => item.id == 'pd5'),
      isFalse,
    );
    expect(find.text('Neighborhood Walk & Play'), findsNothing);
  });

  test('Non-owner cannot cancel via provider', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(playdateProvider.future);

    final cancelled = container
        .read(playdateProvider.notifier)
        .cancelPlaydate('pd1', currentUser.id);

    expect(cancelled, isFalse);
    expect(
      container
          .read(playdateProvider)
          .requireValue
          .any((item) => item.id == 'pd1'),
      isTrue,
    );
  });

  testWidgets('Edit shows coming soon placeholder', (tester) async {
    await pumpApp(tester);

    await tester.scrollUntilVisible(
      find.text('Neighborhood Walk & Play'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Neighborhood Walk & Play'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Edit Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Playdate coming soon'), findsOneWidget);
  });
}
