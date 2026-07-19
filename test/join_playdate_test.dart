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

  testWidgets('Join button visible when current user has not joined', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Saturday Park Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('Join Playdate'), findsOneWidget);
    expect(find.text('Leave Playdate'), findsNothing);
    expect(find.text('2 / 5 joined'), findsWidgets);
  });

  testWidgets('Join then Leave updates participant count', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.text('Saturday Park Playdate'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Join Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('Joined successfully!'), findsOneWidget);
    expect(find.text('Leave Playdate'), findsOneWidget);
    expect(find.text('3 / 5 joined'), findsWidgets);

    var playdate = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.id == 'pd1');
    expect(playdate.currentParticipants, 3);
    expect(playdate.isJoinedBy(currentUser.id), isTrue);

    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first))
        .clearSnackBars();
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Leave Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('You left this playdate.'), findsOneWidget);
    expect(find.text('Join Playdate'), findsOneWidget);
    expect(find.text('2 / 5 joined'), findsWidgets);

    playdate = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.id == 'pd1');
    expect(playdate.currentParticipants, 2);
    expect(playdate.isJoinedBy(currentUser.id), isFalse);
  });

  testWidgets('Join twice does not double-count', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.text('Saturday Park Playdate'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Join Playdate'));
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

  testWidgets('Full playdate disables join for non-participant', (tester) async {
    await pumpApp(tester);

    await tester.scrollUntilVisible(
      find.text('Café Meetup + Coloring'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Café Meetup + Coloring'));
    await tester.pumpAndSettle();

    expect(find.text('5 / 5 joined'), findsWidgets);
    expect(find.text('Playdate Full'), findsWidgets);
    expect(find.text('Leave Playdate'), findsNothing);

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Playdate Full'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('Leave remains available when user fills the last spot', (tester) async {
    final container = await pumpApp(tester);

    await tester.scrollUntilVisible(
      find.text('Toddler Soft Play Meetup'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Toddler Soft Play Meetup'));
    await tester.pumpAndSettle();

    expect(find.text('4 / 5 joined'), findsWidgets);

    await tester.tap(find.widgetWithText(FilledButton, 'Join Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('5 / 5 joined'), findsWidgets);
    expect(find.text('Leave Playdate'), findsOneWidget);

    var playdate = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.id == 'pd4');
    expect(playdate.isFull, isTrue);
    expect(playdate.isJoinedBy(currentUser.id), isTrue);

    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first))
        .clearSnackBars();
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Leave Playdate'));
    await tester.pumpAndSettle();

    expect(find.text('4 / 5 joined'), findsWidgets);
    expect(find.text('Join Playdate'), findsOneWidget);

    playdate = container
        .read(playdateProvider)
        .requireValue
        .firstWhere((item) => item.id == 'pd4');
    expect(playdate.isJoinedBy(currentUser.id), isFalse);
  });

  testWidgets('Home card shows updated count after join', (tester) async {
    await pumpApp(tester);

    expect(find.text('2 / 5 joined'), findsOneWidget);

    await tester.tap(find.text('Saturday Park Playdate'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Join Playdate'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('3 / 5 joined'), findsOneWidget);
  });
}
