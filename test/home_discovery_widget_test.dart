import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/features/home/discovery/group_discovery_filters.dart';
import 'package:momo/providers/group_discovery_provider.dart';
import 'package:momo/providers/group_provider.dart';
import 'package:momo/providers/main_tab_provider.dart';
import 'package:momo/navigation/app_navigation.dart';

import 'support/home_test_helpers.dart';
import 'support/test_overrides.dart';

void main() {
  Future<ProviderContainer> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 1400);
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

  testWidgets('Home shows search field and Filter button', (tester) async {
    await pumpHome(tester);

    expect(find.text('모임 이름, 지역, 관심사 검색'), findsOneWidget);
    expect(find.text('필터'), findsOneWidget);
    expect(find.text('추천 모임'), findsOneWidget);
    expect(find.text('전체 모임'), findsOneWidget);
  });

  testWidgets('Search query shows results mode', (tester) async {
    final container = await pumpHome(tester);

    await tester.enterText(find.byType(TextField).first, '도서관');
    await tester.pumpAndSettle();

    expect(container.read(groupSearchQueryProvider), '도서관');
    expect(find.textContaining('검색 결과'), findsOneWidget);
    expect(find.text('추천 모임'), findsNothing);
  });

  testWidgets('Search no-results state appears', (tester) async {
    await pumpHome(tester);

    await tester.enterText(find.byType(TextField).first, 'zzzz-no-match');
    await tester.pumpAndSettle();

    expect(find.text('검색 결과가 없습니다.'), findsOneWidget);
    expect(find.text('검색어 지우기'), findsOneWidget);
  });

  testWidgets('Filter bottom sheet opens and applying updates results',
      (tester) async {
    final container = await pumpHome(tester);

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();

    expect(find.text('모임 필터'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('미가입'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(BottomSheet),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, '미가입'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();

    final filters = container.read(groupDiscoveryFiltersProvider);
    expect(filters.membership, GroupMembershipFilter.notJoined);
    expect(find.text('미가입'), findsWidgets);
  });

  testWidgets('Clear filter chip removes one filter', (tester) async {
    final container = await pumpHome(tester);

    container.read(groupDiscoveryFiltersProvider.notifier).setFilters(
          const GroupDiscoveryFilters(
            interests: {'도서관'},
            locations: {'Koreatown, Los Angeles'},
          ),
        );
    await tester.pumpAndSettle();

    expect(container.read(groupDiscoveryFiltersProvider).activeCount, 2);
    final remove = find.byTooltip('필터 제거').first;
    await tester.ensureVisible(remove);
    await tester.tap(remove);
    await tester.pumpAndSettle();

    expect(container.read(groupDiscoveryFiltersProvider).activeCount, 1);
  });

  testWidgets('Clear all removes all filters', (tester) async {
    final container = await pumpHome(tester);

    container.read(groupDiscoveryFiltersProvider.notifier).setFilters(
          const GroupDiscoveryFilters(
            interests: {'도서관'},
            ageRanges: {'2–4세'},
          ),
        );
    await tester.pumpAndSettle();

    final clearAll = find.text('전체 초기화');
    await tester.ensureVisible(clearAll);
    await tester.tap(clearAll);
    await tester.pumpAndSettle();

    expect(container.read(groupDiscoveryFiltersProvider).isEmpty, isTrue);
  });

  testWidgets('Recommendation section titles appear at most once',
      (tester) async {
    await pumpHome(tester);
    expect(find.text('추천 모임'), findsOneWidget);
    expect(find.text('전체 모임'), findsOneWidget);
  });

  testWidgets('Tapping Group Card opens Group Detail', (tester) async {
    await pumpHome(tester);
    await openHomeGroupBySearch(tester, 'LA 한국어');

    expect(find.text('Posts'), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
  });

  testWidgets('Home contains no Join button', (tester) async {
    await pumpHome(tester);

    expect(find.text('Join Group'), findsNothing);
    expect(find.text('가입하기'), findsNothing);
    expect(find.text('Leave Group'), findsNothing);
  });

  testWidgets('Joined chip appears when joined', (tester) async {
    await pumpHome(tester);
    expect(find.text('내 모임'), findsWidgets);
  });

  testWidgets('Home remains functional during async refresh', (tester) async {
    final container = await pumpHome(tester);

    expect(find.text('필터'), findsOneWidget);
    await container.read(groupProvider.notifier).refreshGroups();
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('필터'), findsOneWidget);
    expect(container.read(mainTabProvider), MainTabs.home);
  });
}
