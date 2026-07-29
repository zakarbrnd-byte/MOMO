import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/data/mock_user.dart';
import 'package:momo/features/detail/playdate_detail_screen.dart';
import 'package:momo/providers/playdate_provider.dart';

import 'support/test_overrides.dart';

/// Ownership coverage via provider + detail screen (Create hub is Group/Post).
void main() {
  Future<ProviderContainer> pumpDetail(
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

  test('Create assigns creatorId and starts with zero participants', () async {
    final container = ProviderContainer(overrides: testBackendOverrides);
    addTearDown(container.dispose);
    await container.read(playdateProvider.future);

    container.read(playdateProvider.notifier).createPlaydate(
          title: 'Owned Park Day',
          date: 'Sat',
          time: '',
          location: 'Irvine Park',
          childAge: '',
          description: '',
          maxParticipants: 3,
        );

    final created = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.title == 'Owned Park Day');

    expect(created.creatorId, currentUser.id);
    expect(created.participantIds, isEmpty);
    expect(created.participantsLabel, '0 / 3 joined');
  });

  testWidgets('Owner detail shows Edit/Cancel, not Join/Leave', (tester) async {
    await pumpDetail(tester, 'pd5');

    expect(find.text('My Playdate'), findsOneWidget);
    expect(find.text('Edit Playdate'), findsOneWidget);
    expect(find.text('Cancel Playdate'), findsOneWidget);
    expect(find.text('Join Playdate'), findsNothing);
    expect(find.text('Leave Playdate'), findsNothing);
  });

  testWidgets('Non-owner detail keeps Join/Leave', (tester) async {
    await pumpDetail(tester, 'pd1');

    expect(find.text('Join Playdate'), findsOneWidget);
    expect(find.text('Edit Playdate'), findsNothing);
    expect(find.text('Cancel Playdate'), findsNothing);
  });

  testWidgets('Owner cancel removes playdate from provider list',
      (tester) async {
    final container = await pumpDetail(tester, 'pd5');

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
    await pumpDetail(tester, 'pd5');

    await tester.tap(find.widgetWithText(OutlinedButton, 'Edit Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Playdate coming soon'), findsOneWidget);
  });
}
