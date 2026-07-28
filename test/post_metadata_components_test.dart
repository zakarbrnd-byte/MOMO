import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/core/theme/app_text_styles.dart';
import 'package:momo/core/theme/app_theme.dart';
import 'package:momo/core/widgets/author_summary.dart';
import 'package:momo/core/widgets/card_author_metadata.dart';
import 'package:momo/core/widgets/card_header.dart';
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
        child: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
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

  group('PostCard redesign', () {
    final clock = DateTime.utc(2026, 7, 28, 21, 0, 0);
    const sample = Post(
      id: 'po_ui',
      title: '테스트 게시글 제목',
      content: '본문 미리보기입니다. 두 번째 줄도 포함됩니다.',
      authorName: '박민지',
      category: PostCategory.local,
      viewCount: 187,
      commentCount: 14,
      likeCount: 31,
    );
    final sampleWithTime = Post(
      id: 'po_ui_time',
      title: '타임스탬프 게시글',
      content: '본문',
      authorName: '최유나',
      category: PostCategory.school,
      viewCount: 10,
      commentCount: 2,
      likeCount: 3,
      createdAt: clock.subtract(const Duration(hours: 2)),
    );

    testWidgets(
        'renders hierarchy: header (badge+author), title, preview, metrics',
        (tester) async {
      await tester.pumpWidget(
        wrap(PostCard(post: sample, onTap: () {})),
      );

      expect(find.byType(CategoryChip), findsOneWidget);
      expect(find.byType(CardHeader), findsOneWidget);
      expect(find.byType(CardAuthorMetadata), findsOneWidget);
      expect(find.text('지역정보'), findsOneWidget);
      expect(find.text('테스트 게시글 제목'), findsOneWidget);
      expect(find.textContaining('본문 미리보기'), findsOneWidget);
      expect(find.text('박민지'), findsOneWidget);
      expect(find.text('187'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);
      expect(find.text('31'), findsOneWidget);
      expect(find.byType(AuthorSummary), findsNothing);
      expect(find.byType(EngagementRow), findsOneWidget);

      final categoryY = tester.getTopLeft(find.text('지역정보')).dy;
      final authorY = tester.getTopLeft(find.text('박민지')).dy;
      final titleY = tester.getTopLeft(find.text('테스트 게시글 제목')).dy;
      final engagementY = tester.getTopLeft(find.byType(EngagementRow)).dy;

      // Badge and author share the header row; title is below.
      expect((authorY - categoryY).abs(), lessThan(8));
      expect(categoryY, lessThan(titleY));
      expect(titleY, lessThan(engagementY));

      final authorRight = tester.getBottomRight(find.text('박민지')).dx;
      final categoryLeft = tester.getTopLeft(find.text('지역정보')).dx;
      expect(authorRight, greaterThan(categoryLeft));

      final title = tester.widget<Text>(find.text('테스트 게시글 제목'));
      expect(title.style?.fontSize, AppTextStyles.cardTitle.fontSize);

      final preview = tester.widget<Text>(
        find.descendant(
          of: find.byType(PostCard),
          matching: find.textContaining('본문 미리보기'),
        ),
      );
      expect(preview.maxLines, 1);
      expect(preview.overflow, TextOverflow.ellipsis);
    });

    testWidgets('shows author · relative time when createdAt is set',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          PostCard(
            post: sampleWithTime,
            onTap: () {},
            now: clock,
          ),
        ),
      );

      expect(find.text('최유나'), findsOneWidget);
      expect(find.text(' · 2시간 전'), findsOneWidget);
      expect(find.text('학교·킨더'), findsOneWidget);

      final badgeY = tester.getTopLeft(find.text('학교·킨더')).dy;
      final authorY = tester.getTopLeft(find.text('최유나')).dy;
      final titleY = tester.getTopLeft(find.text('타임스탬프 게시글')).dy;
      expect((authorY - badgeY).abs(), lessThan(8));
      expect(badgeY, lessThan(titleY));
      // No duplicate metadata under the title.
      expect(find.byType(CardAuthorMetadata), findsOneWidget);
    });

    testWidgets('shows author only when createdAt is null', (tester) async {
      await tester.pumpWidget(
        wrap(PostCard(post: sample, onTap: () {}, now: clock)),
      );

      expect(find.text('박민지'), findsOneWidget);
      expect(find.textContaining('·'), findsNothing);
    });

    testWidgets('long author + time does not overflow narrow width',
        (tester) async {
      final longPost = Post(
        id: 'po_long_author',
        title: '제목',
        content: '본문',
        authorName: '아주아주긴한국어이름엄마님테스트',
        createdAt: clock.subtract(const Duration(hours: 5)),
      );

      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 320,
            child: PostCard(
              post: longPost,
              onTap: () {},
              now: clock,
            ),
          ),
          size: const Size(320, 600),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('아주아주'), findsOneWidget);
      expect(find.byType(CategoryChip), findsOneWidget);
      expect(find.text(' · 5시간 전'), findsOneWidget);
    });

    testWidgets('full card tap works; nested rows do not block',
        (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          PostCard(
            post: sample,
            onTap: () => taps += 1,
          ),
        ),
      );

      await tester.tap(find.text('지역정보'));
      await tester.pump();
      expect(taps, 1);

      await tester.tap(find.text('187'));
      await tester.pump();
      expect(taps, 2);

      await tester.tap(find.text('박민지'));
      await tester.pump();
      expect(taps, 3);
    });

    testWidgets('exposes compact card semantics', (tester) async {
      await tester.pumpWidget(
        wrap(PostCard(post: sample, onTap: () {})),
      );

      expect(
        find.bySemanticsLabel('지역정보 게시글, 테스트 게시글 제목, 작성자 박민지'),
        findsOneWidget,
      );
    });

    testWidgets('handles zero and large engagement without overflow',
        (tester) async {
      const zeroPost = Post(
        id: 'po_zero',
        title: '제로 참여 게시글',
        content: '내용',
        authorName: '한은지',
        viewCount: 0,
        commentCount: 0,
        likeCount: 0,
      );
      const largePost = Post(
        id: 'po_large',
        title: 'Costco에서 아이 간식 뭐 사세요?',
        content: 'Costco 가면 간식 코너에서 한참 헤매요. 당 덜 들어간 걸로 사려고 하는데 추천 부탁드려요!',
        authorName: '아주아주긴한국어이름엄마님테스트',
        category: PostCategory.food,
        viewCount: 12580,
        commentCount: 342,
        likeCount: 1899,
      );

      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 320,
            child: Column(
              children: [
                PostCard(post: zeroPost, onTap: _noop),
                SizedBox(height: 16),
                PostCard(post: largePost, onTap: _noop),
              ],
            ),
          ),
          size: const Size(320, 900),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('0'), findsNWidgets(3));
      expect(find.text('12580'), findsOneWidget);
      expect(find.textContaining('Costco'), findsWidgets);
      expect(find.textContaining('아주아주'), findsOneWidget);
    });

    testWidgets('long Korean title and content fit narrow width',
        (tester) async {
      const longPost = Post(
        id: 'po_long',
        title: '한인타운 근처에서 아이랑 같이 갈 만한 그늘 많고 안전한 놀이터 추천 부탁드려요',
        content:
            '한여름이라 놀이터 바닥이 너무 뜨거워요. Koreatown이나 Lafayette Park 근처에서 그늘 많은 놀이터 아시는 분 계신가요?',
        authorName: '한은지',
        category: PostCategory.local,
        viewCount: 356,
        commentCount: 22,
        likeCount: 43,
      );

      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 320,
            child: PostCard(post: longPost, onTap: _noop),
          ),
          size: const Size(320, 700),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('지역정보'), findsOneWidget);
      expect(find.byType(PostCard), findsOneWidget);

      final title = tester.widget<Text>(
        find.descendant(
          of: find.byType(PostCard),
          matching: find.textContaining('한인타운'),
        ),
      );
      expect(title.maxLines, 2);
      expect(title.overflow, TextOverflow.ellipsis);
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

void _noop() {}
