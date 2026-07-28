import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/core/theme/app_text_styles.dart';
import 'package:momo/core/theme/app_theme.dart';
import 'package:momo/core/widgets/card_author_metadata.dart';
import 'package:momo/core/widgets/card_header.dart';
import 'package:momo/features/home/widgets/playdate_card.dart';
import 'package:momo/features/home/widgets/post_card.dart';
import 'package:momo/models/playdate.dart';
import 'package:momo/models/post.dart';

void main() {
  final clock = DateTime.utc(2026, 7, 28, 21, 0, 0);

  Widget wrap(Widget child, {Size size = const Size(400, 800)}) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: Scaffold(
            body: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );
  }

  group('PlaydateCard metadata', () {
    final sample = Playdate(
      id: 'pd_ui',
      creatorId: 'mom_other',
      title: '놀이터 플레이데이트',
      date: '7월 30일',
      time: '오전 10:00',
      location: 'Lafayette Park',
      childAge: '3–5세',
      description: '같이 놀아요',
      hostName: '김소라',
      createdAt: clock.subtract(const Duration(hours: 3)),
    );

    testWidgets('shows host · relative time on header row with badge',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          PlaydateCard(
            playdate: sample,
            onTap: () {},
            now: clock,
          ),
        ),
      );

      expect(find.text('Playdate'), findsOneWidget);
      expect(find.text('놀이터 플레이데이트'), findsOneWidget);
      expect(find.text('김소라'), findsOneWidget);
      expect(find.text(' · 3시간 전'), findsOneWidget);
      expect(find.byType(CardHeader), findsOneWidget);
      expect(find.byType(CardAuthorMetadata), findsOneWidget);

      final badgeY = tester.getTopLeft(find.text('Playdate')).dy;
      final hostY = tester.getTopLeft(find.text('김소라')).dy;
      final titleY = tester.getTopLeft(find.text('놀이터 플레이데이트')).dy;
      expect((hostY - badgeY).abs(), lessThan(8));
      expect(badgeY, lessThan(titleY));

      final hostRight = tester.getBottomRight(find.text(' · 3시간 전')).dx;
      final badgeLeft = tester.getTopLeft(find.text('Playdate')).dx;
      expect(hostRight, greaterThan(badgeLeft));

      final title = tester.widget<Text>(find.text('놀이터 플레이데이트'));
      expect(title.style?.fontSize, AppTextStyles.cardTitle.fontSize);
      expect(title.style?.fontWeight, AppTextStyles.cardTitle.fontWeight);
    });

    testWidgets('shows host only when createdAt is null', (tester) async {
      const noTime = Playdate(
        id: 'pd_ui_null',
        creatorId: 'mom_other',
        title: '시간 없는 플레이데이트',
        date: '7월 30일',
        time: '오전 10:00',
        location: 'Lafayette Park',
        childAge: '3–5세',
        description: '같이 놀아요',
        hostName: '박민지',
      );

      await tester.pumpWidget(
        wrap(
          PlaydateCard(
            playdate: noTime,
            onTap: () {},
            now: clock,
          ),
        ),
      );

      expect(find.text('박민지'), findsOneWidget);
      expect(find.textContaining('·'), findsNothing);
    });

    testWidgets('long host + time does not overflow narrow width',
        (tester) async {
      final longHost = Playdate(
        id: 'pd_long',
        creatorId: 'mom_other',
        title: '좁은 화면 테스트',
        date: '7월 30일',
        time: '오전 10:00',
        location: 'Lafayette Park',
        childAge: '3–5세',
        description: '같이 놀아요',
        hostName: '아주아주긴한국어이름엄마님테스트',
        createdAt: clock.subtract(const Duration(hours: 5)),
      );

      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 320,
            child: PlaydateCard(
              playdate: longHost,
              onTap: () {},
              now: clock,
            ),
          ),
          size: const Size(320, 700),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('아주아주'), findsOneWidget);
      expect(find.text(' · 5시간 전'), findsOneWidget);
    });
  });

  group('shared card title style', () {
    testWidgets('Playdate and Post titles use identical cardTitle size',
        (tester) async {
      const post = Post(
        id: 'po_shared',
        title: '동일 타이틀 스타일',
        content: '본문',
        authorName: '최유나',
      );
      const playdate = Playdate(
        id: 'pd_shared',
        creatorId: 'mom_other',
        title: '동일 타이틀 스타일',
        date: '7월 30일',
        time: '오전 10:00',
        location: 'Park',
        childAge: '3세',
        description: '설명',
        hostName: '김소라',
      );

      await tester.pumpWidget(
        wrap(
          Column(
            children: [
              PostCard(post: post, onTap: () {}),
              PlaydateCard(playdate: playdate, onTap: () {}),
            ],
          ),
        ),
      );

      final titles = tester.widgetList<Text>(find.text('동일 타이틀 스타일')).toList();
      expect(titles, hasLength(2));
      expect(titles[0].style?.fontSize, titles[1].style?.fontSize);
      expect(titles[0].style?.fontSize, AppTextStyles.cardTitle.fontSize);
    });
  });
}
