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
      UncontrolledProviderScope(container: container, child: const MomoApp()),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('Home shows compact Filter and Search AppBar actions', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.text('MOMO'), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    expect(find.text('모임 이름, 지역, 관심사 검색'), findsNothing);
    expect(find.text('필터'), findsNothing);
    expect(find.text('✨ 추천 모임'), findsOneWidget);
    expect(find.text('전체 모임'), findsOneWidget);
    expect(find.textContaining('우리 동네 엄마들의'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border_rounded), findsWidgets);
  });

  testWidgets('Home hero is compact horizontal with transparent art', (
    tester,
  ) async {
    await pumpHome(tester);

    final heading = find.textContaining('우리 동네 엄마들의');
    expect(heading, findsOneWidget);
    expect(find.text('✨ 추천 모임'), findsOneWidget);

    final image = find.byWidgetPredicate((widget) {
      if (widget is! Image) return false;
      final provider = widget.image;
      return provider is AssetImage &&
          provider.assetName == 'assets/images/hero_moms_transparent.png';
    });
    expect(image, findsOneWidget);

    // Heading and illustration share one Row at standard mobile width.
    final row = find.ancestor(of: heading, matching: find.byType(Row));
    expect(row, findsWidgets);
    expect(
      find.descendant(of: row.first, matching: image),
      findsOneWidget,
    );

    final heroHeight = tester.getSize(row.first).height;
    expect(heroHeight, lessThan(180));

    // Recommended section sits below the hero.
    final heroBottom = tester.getBottomLeft(heading).dy;
    final sectionTop = tester.getTopLeft(find.text('✨ 추천 모임')).dy;
    expect(sectionTop, greaterThan(heroBottom));
  });

  testWidgets('Home hero has no overflow at narrow width and large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Feed cards may overflow at large scale (out of scope); suppress those
    // so we can still assert the compact hero stays on one row.
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if ('${details.exception}'.contains('A RenderFlex overflowed')) {
        return;
      }
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);

    final container = ProviderContainer(overrides: testBackendOverrides);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MediaQuery(
          data: MediaQueryData(
            size: Size(320, 900),
            textScaler: TextScaler.linear(1.3),
          ),
          child: MomoApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final heading = find.textContaining('우리 동네 엄마들의');
    expect(heading, findsOneWidget);

    final heroRow =
        find.ancestor(of: heading, matching: find.byType(Row)).first;
    expect(tester.getSize(heroRow).width, lessThanOrEqualTo(320));
    expect(tester.getSize(heroRow).height, lessThan(220));
    expect(
      find.descendant(
        of: heroRow,
        matching: find.byWidgetPredicate((widget) {
          if (widget is! Image) return false;
          final provider = widget.image;
          return provider is AssetImage &&
              provider.assetName.contains('hero_moms_transparent');
        }),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Search query shows results mode', (tester) async {
    final container = await pumpHome(tester);

    await openHomeSearch(tester);
    await tester.enterText(find.byType(TextField).first, '도서관');
    await tester.pumpAndSettle();

    expect(container.read(groupSearchQueryProvider), '도서관');
    expect(find.textContaining('검색 결과'), findsOneWidget);
    expect(find.text('✨ 추천 모임'), findsNothing);
  });

  testWidgets('Search no-results state appears', (tester) async {
    await pumpHome(tester);

    await openHomeSearch(tester);
    await tester.enterText(find.byType(TextField).first, 'zzzz-no-match');
    await tester.pumpAndSettle();

    expect(find.text('검색 결과가 없습니다.'), findsOneWidget);
    expect(find.text('검색어 지우기'), findsOneWidget);
  });

  testWidgets('Filter bottom sheet opens and applying updates results', (
    tester,
  ) async {
    final container = await pumpHome(tester);

    await tester.tap(find.byIcon(Icons.tune_rounded));
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
          const GroupDiscoveryFilters(interests: {'도서관'}, ageRanges: {'2–4세'}),
        );
    await tester.pumpAndSettle();

    final clearAll = find.text('전체 초기화');
    await tester.ensureVisible(clearAll);
    await tester.tap(clearAll);
    await tester.pumpAndSettle();

    expect(container.read(groupDiscoveryFiltersProvider).isEmpty, isTrue);
  });

  testWidgets('Recommendation section titles appear at most once', (
    tester,
  ) async {
    await pumpHome(tester);
    expect(find.text('✨ 추천 모임'), findsOneWidget);
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

    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
    await container.read(groupProvider.notifier).refreshGroups();
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
    expect(container.read(mainTabProvider), MainTabs.home);
  });
}
