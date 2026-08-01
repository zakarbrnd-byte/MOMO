import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/core/async/simulated_backend.dart';
import 'package:momo/core/result/result.dart';
import 'package:momo/data/datasources/mock/mock_comment_data_source.dart';
import 'package:momo/data/mock_comments.dart';
import 'package:momo/features/detail/comment_rules.dart';
import 'package:momo/providers/comment_provider.dart';
import 'package:momo/providers/post_provider.dart';
import 'package:momo/repositories/comment_repository_impl.dart';
import 'package:momo/repositories/repository_providers.dart';

import 'support/test_overrides.dart';

void main() {
  group('CommentRepository', () {
    test('load comments by post', () async {
      final repo = CommentRepositoryImpl(MockCommentDataSource());
      final comments = await repo.loadCommentsByPost('gpo_la3_1');
      expect(comments, hasLength(5));
      expect(await repo.loadCommentCount('gpo_la3_1'), 5);
      expect(await repo.loadCommentCount('gpo_global_6'), 0);
    });

    test('create top-level comment', () async {
      final repo = CommentRepositoryImpl(MockCommentDataSource());
      final result = await repo.createComment(
        postId: 'gpo_global_6',
        authorId: 'user_001',
        authorName: '장하은',
        body: '축하해요!',
      );
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull!.parentCommentId, isNull);
      expect(await repo.loadCommentCount('gpo_global_6'), 1);
    });

    test('create reply and reply-to-reply normalize parent', () async {
      final repo = CommentRepositoryImpl(MockCommentDataSource());
      final reply = await repo.createComment(
        postId: 'gpo_la3_1',
        authorId: 'user_001',
        authorName: '장하은',
        body: '좋아요!',
        parentCommentId: 'cmt_la3_1_a',
      );
      expect(reply.dataOrNull!.parentCommentId, 'cmt_la3_1_a');

      final nested = await repo.createComment(
        postId: 'gpo_la3_1',
        authorId: 'user_001',
        authorName: '장하은',
        body: '저도요!',
        parentCommentId: 'cmt_la3_1_a1',
      );
      expect(nested.isSuccess, isTrue);
      expect(nested.dataOrNull!.parentCommentId, 'cmt_la3_1_a');
    });

    test('empty body returns failure and does not insert', () async {
      final source = MockCommentDataSource();
      final repo = CommentRepositoryImpl(source);
      final before = await repo.loadCommentCount('gpo_global_6');
      final result = await repo.createComment(
        postId: 'gpo_global_6',
        authorId: 'user_001',
        authorName: '장하은',
        body: '   ',
      );
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, CommentRules.emptyBodyMessage);
      expect(await repo.loadCommentCount('gpo_global_6'), before);
    });
  });

  group('comment providers', () {
    test('comments load asynchronously and create invalidates', () async {
      final container = ProviderContainer(overrides: testBackendOverrides);
      addTearDown(container.dispose);

      final loading = container.read(commentsByPostProvider('gpo_la3_1'));
      expect(loading.isLoading || loading.hasValue, isTrue);

      final comments = await container.read(
        commentsByPostProvider('gpo_la3_1').future,
      );
      expect(comments, hasLength(mockCommentCountsByPostId['gpo_la3_1']));

      await container.read(postProvider.future);
      final beforeCount = container
          .read(postProvider)
          .requireValue
          .firstWhere((p) => p.id == 'gpo_la3_1')
          .commentCount;

      final repo = container.read(commentRepositoryProvider);
      final created = await repo.createComment(
        postId: 'gpo_la3_1',
        authorId: 'user_001',
        authorName: '장하은',
        body: '새 댓글입니다',
      );
      expect(created.isSuccess, isTrue);

      container.invalidate(commentsByPostProvider('gpo_la3_1'));
      final after = await container.read(
        commentsByPostProvider('gpo_la3_1').future,
      );
      expect(after.length, beforeCount + 1);

      container
          .read(postProvider.notifier)
          .syncCommentCount('gpo_la3_1', after.length);
      expect(
        container
            .read(postProvider)
            .requireValue
            .firstWhere((p) => p.id == 'gpo_la3_1')
            .commentCount,
        after.length,
      );
    });

    test('duplicate submit prevented while mutation busy', () async {
      final container = ProviderContainer(
        overrides: [
          simulatedBackendProvider.overrideWith(
            () => _SlowBackend(const Duration(milliseconds: 200)),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Keep autoDispose mutation alive across awaits.
      final sub = container.listen(createCommentMutationProvider, (_, __) {});
      addTearDown(sub.close);

      final mutation = container.read(createCommentMutationProvider.notifier);
      final first = mutation.runResult(() async {
        await Future<void>.delayed(const Duration(milliseconds: 80));
        return const Success(true);
      });
      final second = mutation.runResult(() async => const Success(true));

      expect(await second, isFalse);
      expect(await first, isTrue);
    });
  });
}

class _SlowBackend extends SimulatedBackendNotifier {
  _SlowBackend(this.delay);

  final Duration delay;

  @override
  SimulatedBackendConfig build() => SimulatedBackendConfig(delay: delay);
}
