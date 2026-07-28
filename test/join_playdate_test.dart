import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/data/mock_user.dart';
import 'package:momo/providers/playdate_provider.dart';

void main() {
  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
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

  testWidgets('Join button visible when current user has not joined',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('이번 토요일 공원에서 같이 놀아요 😊'));
    await tester.pumpAndSettle();

    expect(find.text('참여하기'), findsOneWidget);
    expect(find.text('나가기'), findsNothing);
    expect(find.text('2 / 5명'), findsWidgets);
  });

  testWidgets('Join then Leave updates participant count', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.text('이번 토요일 공원에서 같이 놀아요 😊'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, '참여하기'));
    await tester.pumpAndSettle();

    expect(find.text('참여했어요!'), findsOneWidget);
    expect(find.text('나가기'), findsOneWidget);
    expect(find.text('3 / 5명'), findsWidgets);

    var playdate = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.id == 'pd1');
    expect(playdate.currentParticipants, 3);
    expect(playdate.isJoinedBy(currentUser.id), isTrue);

    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first))
        .clearSnackBars();
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, '나가기'));
    await tester.pumpAndSettle();

    expect(find.text('모임에서 나갔어요.'), findsOneWidget);
    expect(find.text('참여하기'), findsOneWidget);
    expect(find.text('2 / 5명'), findsWidgets);

    playdate = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.id == 'pd1');
    expect(playdate.currentParticipants, 2);
    expect(playdate.isJoinedBy(currentUser.id), isFalse);
  });

  testWidgets('Join twice does not double-count', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.text('이번 토요일 공원에서 같이 놀아요 😊'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '참여하기'));
    await tester.pumpAndSettle();

    final joinedAgain = container
        .read(playdateProvider.notifier)
        .joinPlaydate('pd1', currentUser.id);
    expect(joinedAgain, isFalse);
    expect(
      container
          .read(playdateProvider)
          .requireValue
          .firstWhere((item) => item.id == 'pd1')
          .currentParticipants,
      3,
    );
  });

  testWidgets('Full playdate disables join for non-participant',
      (tester) async {
    await pumpApp(tester);

    await tester.scrollUntilVisible(
      find.text('키즈카페에서 엄마들도 같이 수다해요'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('키즈카페에서 엄마들도 같이 수다해요'));
    await tester.pumpAndSettle();

    expect(find.text('5 / 5명'), findsWidgets);
    expect(find.text('마감'), findsWidgets);
    expect(find.text('나가기'), findsNothing);

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '마감'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('Leave remains available when user fills the last spot',
      (tester) async {
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

    var playdate = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.id == 'pd4');
    expect(playdate.isFull, isTrue);
    expect(playdate.isJoinedBy(currentUser.id), isTrue);

    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first))
        .clearSnackBars();
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, '나가기'));
    await tester.pumpAndSettle();

    expect(find.text('4 / 5명'), findsWidgets);
    expect(find.text('참여하기'), findsOneWidget);

    playdate = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.id == 'pd4');
    expect(playdate.isJoinedBy(currentUser.id), isFalse);
  });

  testWidgets('Home card shows updated count after join', (tester) async {
    await pumpApp(tester);

    expect(find.text('2 / 5명'), findsOneWidget);

    await tester.tap(find.text('이번 토요일 공원에서 같이 놀아요 😊'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '참여하기'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('3 / 5명'), findsOneWidget);
  });
}
