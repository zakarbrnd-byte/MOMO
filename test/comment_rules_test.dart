import 'package:flutter_test/flutter_test.dart';

import 'package:momo/data/mock_comments.dart';
import 'package:momo/features/detail/comment_rules.dart';
import 'package:momo/models/comment.dart';

void main() {
  final now = mockCommentSeedNow;

  Comment top({String id = 'c1', String postId = 'p1', DateTime? createdAt}) {
    return Comment(
      id: id,
      postId: postId,
      authorId: 'u1',
      authorName: '김소라',
      body: '안녕하세요',
      createdAt: createdAt ?? now,
    );
  }

  Comment reply({
    required String id,
    required String parentId,
    String postId = 'p1',
    DateTime? createdAt,
    String authorName = '박민지',
  }) {
    return Comment(
      id: id,
      postId: postId,
      authorId: 'u2',
      authorName: authorName,
      body: '답글입니다',
      createdAt: createdAt ?? now.add(const Duration(minutes: 1)),
      parentCommentId: parentId,
    );
  }

  group('Comment model', () {
    test('construction and copyWith', () {
      final comment = top();
      expect(comment.isTopLevel, isTrue);
      expect(comment.isReply, isFalse);

      final copied = comment.copyWith(body: '수정', parentCommentId: 'root');
      expect(copied.body, '수정');
      expect(copied.parentCommentId, 'root');
      expect(copied.id, comment.id);
      expect(comment == top(), isTrue);
    });

    test('top-level has null parent; reply has parent id', () {
      expect(top().parentCommentId, isNull);
      expect(reply(id: 'r1', parentId: 'c1').parentCommentId, 'c1');
    });
  });

  group('CommentRules validation', () {
    test('empty and whitespace-only rejected', () {
      expect(CommentRules.validateBody(''), CommentRules.emptyBodyMessage);
      expect(CommentRules.validateBody('   '), CommentRules.emptyBodyMessage);
    });

    test('over 500 characters rejected', () {
      final body = '가' * 501;
      expect(CommentRules.validateBody(body), CommentRules.tooLongMessage);
    });

    test('valid body accepted and normalized', () {
      expect(CommentRules.validateBody('  안녕하세요  '), isNull);
      expect(CommentRules.normalizeBody('  안녕하세요  '), '안녕하세요');
    });
  });

  group('resolveReplyParentId', () {
    test('replying to top-level uses that comment', () {
      final root = top(id: 'root');
      final all = [root];
      expect(
        CommentRules.resolveReplyParentId(target: root, allComments: all),
        'root',
      );
    });

    test('reply-to-reply resolves to original top-level parent', () {
      final root = top(id: 'root');
      final child = reply(id: 'child', parentId: 'root');
      final all = [root, child];
      expect(
        CommentRules.resolveReplyParentId(target: child, allComments: all),
        'root',
      );
    });
  });

  group('buildCommentThreads', () {
    test('groups replies and keeps stable oldest-first order', () {
      final rootB = top(
        id: 'b',
        createdAt: now.add(const Duration(minutes: 2)),
      );
      final rootA = top(id: 'a', createdAt: now);
      final r2 = reply(
        id: 'r2',
        parentId: 'a',
        createdAt: now.add(const Duration(minutes: 5)),
      );
      final r1 = reply(
        id: 'r1',
        parentId: 'a',
        createdAt: now.add(const Duration(minutes: 3)),
      );

      final threads = CommentRules.buildCommentThreads([rootB, r2, rootA, r1]);
      expect(threads.map((t) => t.root.id), ['a', 'b']);
      expect(threads.first.replies.map((r) => r.id), ['r1', 'r2']);
    });

    test('orphaned reply does not crash and becomes top-level fallback', () {
      final orphan = reply(id: 'orphan', parentId: 'missing');
      final threads = CommentRules.buildCommentThreads([orphan]);
      expect(threads, hasLength(1));
      expect(threads.first.root.id, 'orphan');
      expect(threads.first.replies, isEmpty);
    });

    test('comment count includes replies', () {
      final comments = [
        top(id: 'a'),
        reply(id: 'r1', parentId: 'a'),
        reply(id: 'r2', parentId: 'a'),
      ];
      expect(CommentRules.totalCount(comments), 3);
      expect(mockCommentCountsByPostId['gpo_la3_1'], 5);
    });
  });
}
