import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/core/theme/app_theme.dart';
import 'package:momo/core/widgets/author_summary.dart';
import 'package:momo/core/widgets/engagement_row.dart';
import 'package:momo/data/mock_feed.dart';
import 'package:momo/features/home/widgets/category_chip.dart';
import 'package:momo/features/home/widgets/post_card.dart';
import 'package:momo/models/post.dart';

void main() {
  Widget wrap(Widget child, {Size size = const Size(400, 800)}) {
    return MaterialApp(
      theme: AppTheme.light,
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(body: child),
      ),
    );
  }

  group('CategoryChip', () {
    testWidgets('displays Korean label and category semantics', (tester) async {
      await tester.pumpWidget(
        wrap(const CategoryChip(category: PostCategory.school)),
      );

      expect(find.text('학교·킨더'), findsOneWidget);
      expect(find.bySemanticsLabel('카테고리 학교·킨더'), findsOneWidget);
    });

    testWidgets('does not overflow in a narrow layout', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 120,
            child: CategoryChip(category: PostCategory.marketplace),
          ),
          size: const Size(120, 200),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('장터'), findsOneWidget);
    });
  });

  group('EngagementRow', () {
    testWidgets('displays all three counts including zeros', (tester) async {
      await tester.pumpWidget(
        wrap(
          const EngagementRow(
            viewCount: 0,
            commentCount: 0,
            likeCount: 0,
          ),
        ),
      );

      expect(find.text('0'), findsNWidgets(3));
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.bySemanticsLabel('조회수 0'), findsOneWidget);
      expect(find.bySemanticsLabel('댓글 0개'), findsOneWidget);
      expect(find.bySemanticsLabel('좋아요 0개'), findsOneWidget);
    });

    testWidgets('supports larger values with semantics and no taps',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 200,
            child: EngagementRow(
              viewCount: 12580,
              commentCount: 342,
              likeCount: 1899,
            ),
          ),
          size: const Size(200, 400),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.bySemanticsLabel('조회수 12580'), findsOneWidget);
      expect(find.bySemanticsLabel('댓글 342개'), findsOneWidget);
      expect(find.bySemanticsLabel('좋아요 1899개'), findsOneWidget);

      await tester.tap(find.byType(EngagementRow));
      await tester.pump();
      // Display-only: no exceptions / navigation from the row itself.
      expect(tester.takeException(), isNull);
    });
  });

  group('AuthorSummary', () {
    testWidgets('displays author name with initials fallback', (tester) async {
      await tester.pumpWidget(
        wrap(const AuthorSummary(displayName: '최유나')),
      );

      expect(find.text('최유나'), findsOneWidget);
      expect(find.text('최'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('handles missing avatar and optional metadata', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AuthorSummary(
            displayName: '장하은',
            avatarUrl: null,
            location: 'Koreatown',
            contextualLabel: '아이 4세',
          ),
        ),
      );

      expect(find.text('장하은'), findsOneWidget);
      expect(find.text('Koreatown · 아이 4세'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('ignores invalid avatar URL and ellipsizes long names',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 160,
            child: AuthorSummary(
              displayName: '아주아주긴한국어이름엄마님테스트',
              avatarUrl: 'not-a-url',
            ),
          ),
          size: const Size(160, 300),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('아주아주'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });

  group('PostCard minimal integration', () {
    testWidgets('shows category, engagement, and preserves tap',
        (tester) async {
      var tapped = false;
      const post = Post(
        id: 'po_ui',
        title: '테스트 게시글 제목',
        content: '본문 미리보기입니다.',
        authorName: '박민지',
        category: PostCategory.local,
        viewCount: 187,
        commentCount: 14,
        likeCount: 31,
      );

      await tester.pumpWidget(
        wrap(
          PostCard(
            post: post,
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('지역정보'), findsOneWidget);
      expect(find.text('박민지'), findsOneWidget);
      expect(find.text('테스트 게시글 제목'), findsOneWidget);
      expect(find.text('187'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);
      expect(find.text('31'), findsOneWidget);
      expect(find.byType(CategoryChip), findsOneWidget);
      expect(find.byType(EngagementRow), findsOneWidget);
      expect(find.byType(AuthorSummary), findsOneWidget);

      await tester.tap(find.byType(PostCard));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('Home post card still opens Post detail', (tester) async {
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

      expect(find.text(postSeolleung.category.labelKo), findsWidgets);
      expect(find.text('${postSeolleung.viewCount}'), findsWidgets);

      await tester.tap(find.text(postSeolleung.title));
      await tester.pumpAndSettle();

      expect(find.text(postSeolleung.content), findsOneWidget);
      expect(find.text(postSeolleung.authorName), findsOneWidget);
    });
  });
}
