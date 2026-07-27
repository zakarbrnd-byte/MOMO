import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/core/widgets/engagement_row.dart';
import 'package:momo/core/widgets/feed_filter_tabs.dart';
import 'package:momo/core/widgets/playdate_hero_cta.dart';
import 'package:momo/providers/feed_provider.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MomoApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Home shows playdate-first structure', (tester) async {
    await pumpHome(tester);

    expect(find.text('MOMO'), findsOneWidget);
    expect(find.text('우리 동네 엄마들과 같이 키워요'), findsOneWidget);
    expect(find.byType(FeedFilterTabs), findsOneWidget);
    expect(find.text('전체'), findsOneWidget);
    expect(find.byKey(const ValueKey('feed_filter_playdates')), findsOneWidget);
    expect(find.byKey(const ValueKey('feed_filter_posts')), findsOneWidget);
    expect(find.byType(PlaydateHeroCta), findsOneWidget);
    expect(find.text('이번 주말 같이 놀 친구를 찾아보세요!'), findsOneWidget);
    expect(find.text('이번 주 가까운 플레이데이트'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('오늘 많이 보는 글'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('오늘 많이 보는 글'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('새로 올라온 글'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('새로 올라온 글'), findsOneWidget);
  });

  testWidgets('Filter tabs switch to playdates-only list', (tester) async {
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

    container.read(homeFeedFilterProvider.notifier).state =
        HomeFeedFilter.playdates;
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('모든 플레이데이트'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('모든 플레이데이트'), findsOneWidget);
    expect(find.text('오늘 많이 보는 글'), findsNothing);
  });

  testWidgets('Playdate and post cards show engagement metrics',
      (tester) async {
    await pumpHome(tester);

    expect(find.byType(EngagementRow), findsWidgets);
    expect(find.byIcon(Icons.visibility_outlined), findsWidgets);
    expect(find.byIcon(Icons.chat_bubble_outline), findsWidgets);
    expect(find.byIcon(Icons.favorite_border), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('킨더 도시락 보통 뭐 싸주시나요?'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('킨더 도시락 보통 뭐 싸주시나요?'), findsOneWidget);
  });
}
