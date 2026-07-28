import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/core/theme/app_text_styles.dart';
import 'package:momo/core/theme/app_theme.dart';
import 'package:momo/core/widgets/card_author_metadata.dart';

void main() {
  final clock = DateTime.utc(2026, 7, 28, 21, 0, 0);

  Widget wrap(Widget child, {Size size = const Size(320, 200)}) {
    return MaterialApp(
      theme: AppTheme.light,
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }

  testWidgets('formats author · relative time and end-aligns', (tester) async {
    await tester.pumpWidget(
      wrap(
        CardAuthorMetadata(
          authorName: '김소라',
          createdAt: clock.subtract(const Duration(hours: 2)),
          now: clock,
        ),
      ),
    );

    expect(find.text('김소라'), findsOneWidget);
    expect(find.text(' · 2시간 전'), findsOneWidget);

    final nameRight = tester.getBottomRight(find.text('김소라')).dx;
    final timeRight = tester.getBottomRight(find.text(' · 2시간 전')).dx;
    expect(timeRight, greaterThan(nameRight));
  });

  testWidgets('omits separator when createdAt is null', (tester) async {
    await tester.pumpWidget(
      wrap(
        const CardAuthorMetadata(authorName: '박민지'),
      ),
    );

    expect(find.text('박민지'), findsOneWidget);
    expect(find.textContaining('·'), findsNothing);
  });

  testWidgets('long author truncates while keeping timestamp visible',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 180,
          child: CardAuthorMetadata(
            authorName: '아주아주긴한국어이름엄마님테스트',
            createdAt: clock.subtract(const Duration(hours: 5)),
            now: clock,
          ),
        ),
        size: const Size(220, 200),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text(' · 5시간 전'), findsOneWidget);
    expect(find.textContaining('아주아주'), findsOneWidget);

    final name = tester.widget<Text>(find.textContaining('아주아주'));
    expect(name.overflow, TextOverflow.ellipsis);
    expect(name.maxLines, 1);
  });

  testWidgets('uses caption typography by default', (tester) async {
    await tester.pumpWidget(
      wrap(
        CardAuthorMetadata(
          authorName: '최유나',
          createdAt: clock.subtract(const Duration(hours: 1)),
          now: clock,
        ),
      ),
    );

    final name = tester.widget<Text>(find.text('최유나'));
    expect(name.style?.fontSize, AppTextStyles.caption.fontSize);
    expect(name.style?.fontWeight, AppTextStyles.caption.fontWeight);
  });
}
