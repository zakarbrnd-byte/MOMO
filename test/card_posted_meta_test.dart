import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/core/theme/app_theme.dart';
import 'package:momo/core/widgets/card_posted_meta.dart';

void main() {
  final clock = DateTime.utc(2026, 7, 28, 21, 0, 0);

  Widget wrap(Widget child, {Size size = const Size(320, 200)}) {
    return MaterialApp(
      theme: AppTheme.light,
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets('formats author · relative time and end-aligns', (tester) async {
    await tester.pumpWidget(
      wrap(
        CardPostedMeta(
          authorName: '김소라',
          createdAt: clock.subtract(const Duration(hours: 2)),
          now: clock,
        ),
      ),
    );

    expect(find.text('김소라 · 2시간 전'), findsOneWidget);
    expect(find.byType(CardPostedMeta), findsOneWidget);
  });

  testWidgets('omits separator when createdAt is null', (tester) async {
    await tester.pumpWidget(
      wrap(
        const CardPostedMeta(authorName: '박민지'),
      ),
    );

    expect(find.text('박민지'), findsOneWidget);
    expect(find.textContaining('·'), findsNothing);
  });

  testWidgets('long labels truncate without overflow', (tester) async {
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 200,
          child: CardPostedMeta(
            authorName: '아주아주긴한국어이름엄마님테스트',
            createdAt: clock.subtract(const Duration(hours: 5)),
            now: clock,
          ),
        ),
        size: const Size(200, 200),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.textContaining('아주아주'), findsOneWidget);
  });
}
