import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/core/async/simulated_backend.dart';
import 'package:momo/data/mock_comments.dart';
import 'package:momo/features/detail/comment_rules.dart';
import 'package:momo/features/detail/post_detail_screen.dart';
import 'package:momo/providers/comment_provider.dart';
import 'package:momo/providers/post_provider.dart';

import 'support/test_overrides.dart';

void main() {
  Future<ProviderContainer> pumpDetail(
    WidgetTester tester, {
    required String postId,
    List<Override> overrides = const [],
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: [...testBackendOverrides, ...overrides],
    );
    addTearDown(container.dispose);

    await container.read(postProvider.future);
    final post = container
        .read(postProvider)
        .requireValue
        .firstWhere((p) => p.id == postId);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: PostDetailScreen(post: post, now: mockCommentSeedNow),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('Post Detail shows comment count and comments', (tester) async {
    await pumpDetail(tester, postId: 'gpo_la3_1');

    expect(find.text('댓글 5'), findsOneWidget);
    expect(find.text('저도 이번 주말에 가려고 했어요!'), findsOneWidget);
    expect(find.text('몇 시쯤 가실 예정이에요?'), findsOneWidget);
    expect(find.text('답글 달기'), findsWidgets);
  });

  testWidgets('replies render indented once', (tester) async {
    await pumpDetail(tester, postId: 'gpo_la3_1');

    final replyPadding = tester.widget<Padding>(
      find
          .ancestor(
            of: find.text('몇 시쯤 가실 예정이에요?'),
            matching: find.byType(Padding),
          )
          .first,
    );
    final insets = replyPadding.padding as EdgeInsets;
    expect(insets.left, greaterThan(0));
  });

  testWidgets('reply mode opens and cancel exits', (tester) async {
    await pumpDetail(tester, postId: 'gpo_la3_1');

    await tester.tap(find.text('답글 달기').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('님에게 답글 작성 중'), findsOneWidget);
    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();
    expect(find.textContaining('님에게 답글 작성 중'), findsNothing);
  });

  testWidgets('submit disabled for empty input', (tester) async {
    await pumpDetail(tester, postId: 'gpo_global_6');

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('successful comment appears and count updates', (tester) async {
    final container = await pumpDetail(tester, postId: 'gpo_global_6');

    expect(find.text('댓글 0'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '첫 댓글이에요');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, '등록'));
    await tester.pumpAndSettle();

    expect(find.text('첫 댓글이에요'), findsOneWidget);
    expect(find.text('댓글 1'), findsOneWidget);
    expect(
      container
          .read(postProvider)
          .requireValue
          .firstWhere((p) => p.id == 'gpo_global_6')
          .commentCount,
      1,
    );
  });

  testWidgets('successful reply appears under parent', (tester) async {
    await pumpDetail(tester, postId: 'gpo_la3_1');

    await tester.tap(find.text('답글 달기').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '답글 테스트입니다');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, '등록'));
    await tester.pumpAndSettle();

    expect(find.text('답글 테스트입니다'), findsOneWidget);
    expect(find.text('댓글 6'), findsOneWidget);
  });

  testWidgets('failed submit shows error and keeps input', (tester) async {
    await pumpDetail(
      tester,
      postId: 'gpo_global_6',
      overrides: [simulatedBackendProvider.overrideWith(_FailBackend.new)],
    );

    await tester.enterText(find.byType(TextField), '실패할 댓글');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, '등록'));
    await tester.pumpAndSettle();

    expect(find.textContaining('등록하지 못했습니다'), findsOneWidget);
    expect(find.text('실패할 댓글'), findsOneWidget);
  });

  testWidgets('validation rejects blank comment', (tester) async {
    await pumpDetail(tester, postId: 'gpo_global_6');

    await tester.enterText(find.byType(TextField), '   ');
    await tester.pump();
    // Button stays disabled for whitespace-only.
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });

  testWidgets('loading indicator appears during submit', (tester) async {
    await pumpDetail(
      tester,
      postId: 'gpo_global_6',
      overrides: [
        simulatedBackendProvider.overrideWith(
          () => _DelayBackend(const Duration(milliseconds: 400)),
        ),
      ],
    );

    await tester.enterText(find.byType(TextField), '로딩 확인');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, '등록'));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('reply-to-reply stays one level in provider data', (
    tester,
  ) async {
    final container = await pumpDetail(tester, postId: 'gpo_la3_1');

    // Reply to an existing reply tile.
    final replyButtons = find.text('답글 달기');
    await tester.tap(replyButtons.at(1));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '중첩 없이 붙어요');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, '등록'));
    await tester.pumpAndSettle();

    final comments = await container.read(
      commentsByPostProvider('gpo_la3_1').future,
    );
    final created = comments.firstWhere((c) => c.body == '중첩 없이 붙어요');
    expect(created.parentCommentId, 'cmt_la3_1_a');

    final threads = CommentRules.buildCommentThreads(comments);
    for (final thread in threads) {
      for (final reply in thread.replies) {
        expect(reply.parentCommentId, thread.root.id);
      }
    }
  });
}

class _FailBackend extends SimulatedBackendNotifier {
  @override
  SimulatedBackendConfig build() =>
      const SimulatedBackendConfig(delay: Duration.zero, failNext: true);
}

class _DelayBackend extends SimulatedBackendNotifier {
  _DelayBackend(this.delay);

  final Duration delay;

  @override
  SimulatedBackendConfig build() => SimulatedBackendConfig(delay: delay);
}
