import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/core/theme/app_theme.dart';
import 'package:momo/core/widgets/card_author_metadata.dart';
import 'package:momo/core/widgets/card_header.dart';
import 'package:momo/features/home/widgets/category_chip.dart';
import 'package:momo/models/post_category.dart';

void main() {
  final clock = DateTime.utc(2026, 7, 28, 21, 0, 0);

  Widget wrap(Widget child, {Size size = const Size(360, 200)}) {
    return MaterialApp(
      theme: AppTheme.light,
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(
          body: Padding(padding: const EdgeInsets.all(24), child: child),
        ),
      ),
    );
  }

  testWidgets('places badge left and author/time right on one row', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        CardHeader(
          categoryBadge: const CategoryChip(category: PostCategory.school),
          authorName: '최유나',
          createdAt: clock.subtract(const Duration(hours: 1)),
          now: clock,
        ),
      ),
    );

    expect(find.text('학교·킨더'), findsOneWidget);
    expect(find.text('최유나'), findsOneWidget);
    expect(find.text(' · 1시간 전'), findsOneWidget);
    expect(find.byType(CardAuthorMetadata), findsOneWidget);

    final badgeY = tester.getTopLeft(find.text('학교·킨더')).dy;
    final authorY = tester.getTopLeft(find.text('최유나')).dy;
    expect((authorY - badgeY).abs(), lessThan(8));

    final badgeRight = tester.getBottomRight(find.text('학교·킨더')).dx;
    final authorLeft = tester.getTopLeft(find.text('최유나')).dx;
    expect(authorLeft, greaterThan(badgeRight));
  });

  testWidgets('narrow width keeps badge and timestamp without overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 220,
          child: CardHeader(
            categoryBadge: const CategoryChip(category: PostCategory.local),
            authorName: '아주아주긴한국어이름엄마님테스트',
            createdAt: clock.subtract(const Duration(hours: 2)),
            now: clock,
          ),
        ),
        size: const Size(260, 200),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('지역정보'), findsOneWidget);
    expect(find.text(' · 2시간 전'), findsOneWidget);
    expect(find.textContaining('아주아주'), findsOneWidget);
  });
}
