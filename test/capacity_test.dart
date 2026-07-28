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
    await tester.tap(find.text('플레이데이트 만들기'));
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

  testWidgets('Create unlimited playdate shows 0 joined for owner',
      (tester) async {
    final container = await pumpApp(tester);
    await openCreatePlaydate(tester);
    await fillRequiredPlaydateFields(tester, title: 'Unlimited Park Day');

    await tester.tap(find.widgetWithText(FilledButton, '만들기'));
    await tester.pumpAndSettle();

    final created = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.title == 'Unlimited Park Day');
    expect(created.maxParticipants, isNull);
    expect(created.creatorId, currentUser.id);
    expect(created.participantsLabel, '0명');

    await tester.tap(find.text('Unlimited Park Day'));
    await tester.pumpAndSettle();
    expect(find.text('0명'), findsWidgets);
    expect(find.text('내가 만든 모임'), findsOneWidget);
    expect(find.text('모임 취소'), findsOneWidget);
    expect(find.text('나가기'), findsNothing);
  });

  testWidgets('Create limited playdate stores capacity', (tester) async {
    final container = await pumpApp(tester);
    await openCreatePlaydate(tester);
    await fillRequiredPlaydateFields(tester, title: 'Limited Park Day');

    await tester.enterText(
      find.byKey(const Key('playdate_capacity_field')),
      '5',
    );

    await tester.tap(find.widgetWithText(FilledButton, '만들기'));
    await tester.pumpAndSettle();

    final created = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.title == 'Limited Park Day');
    expect(created.maxParticipants, 5);
    // Creator is owner, not counted as a participant.
    expect(created.participantsLabel, '0 / 5명');

    await tester.tap(find.text('Limited Park Day'));
    await tester.pumpAndSettle();
    expect(find.text('0 / 5명'), findsWidgets);
    expect(find.text('수정하기'), findsOneWidget);
  });

  testWidgets('Invalid capacity shows validation error', (tester) async {
    await pumpApp(tester);
    await openCreatePlaydate(tester);
    await fillRequiredPlaydateFields(tester, title: 'Bad Capacity Day');

    final capacity = find.byKey(const Key('playdate_capacity_field'));
    await tester.enterText(capacity, '0');
    await tester.tap(find.widgetWithText(FilledButton, '만들기'));
    await tester.pumpAndSettle();
    expect(
        find.text('Please enter a valid participant limit.'), findsOneWidget);

    await tester.enterText(capacity, '');
    // digitsOnly blocks letters; set invalid via controller for non-digit case
    final field = tester.widget<TextFormField>(
      find.descendant(
        of: capacity,
        matching: find.byType(TextFormField),
      ),
    );
    field.controller!.text = 'abc';
    await tester.tap(find.widgetWithText(FilledButton, '만들기'));
    await tester.pumpAndSettle();
    expect(
        find.text('Please enter a valid participant limit.'), findsOneWidget);
  });

  testWidgets('Unlimited mock playdate label has no capacity slash',
      (tester) async {
    await pumpApp(tester);

    await tester.scrollUntilVisible(
      find.text('도서관 스토리타임 같이 가실 분?'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('3명'), findsOneWidget);

    await tester.tap(find.text('도서관 스토리타임 같이 가실 분?'));
    await tester.pumpAndSettle();
    expect(find.text('3명'), findsWidgets);
    expect(find.text('참여하기'), findsOneWidget);
  });

  testWidgets('Join until full then leave still works', (tester) async {
    final container = await pumpApp(tester);

    await tester.scrollUntilVisible(
      find.text('비 오는 날 실내 놀이터 번개해요'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('비 오는 날 실내 놀이터 번개해요'));
    await tester.pumpAndSettle();
    expect(find.text('4 / 5명'), findsWidgets);

    await tester.tap(find.widgetWithText(FilledButton, '참여하기'));
    await tester.pumpAndSettle();

    expect(find.text('5 / 5명'), findsWidgets);
    expect(find.text('나가기'), findsOneWidget);

    final full = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.id == 'pd4');
    expect(full.isFull, isTrue);
    expect(full.isJoinedBy(currentUser.id), isTrue);

    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first))
        .clearSnackBars();
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, '나가기'));
    await tester.pumpAndSettle();

    expect(find.text('4 / 5명'), findsWidgets);
    expect(find.text('참여하기'), findsOneWidget);
  });
}
