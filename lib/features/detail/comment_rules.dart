import '../../models/comment.dart';

/// Pure comment helpers (no providers / BuildContext).
abstract final class CommentRules {
  static const int maxBodyLength = 500;

  static const String emptyBodyMessage = '댓글을 입력해주세요.';
  static const String tooLongMessage = '댓글은 500자까지 작성할 수 있습니다.';

  /// Trims [raw]. Returns null when valid; otherwise a user-facing error.
  static String? validateBody(String raw) {
    final body = raw.trim();
    if (body.isEmpty) return emptyBodyMessage;
    if (body.length > maxBodyLength) return tooLongMessage;
    return null;
  }

  static String normalizeBody(String raw) => raw.trim();

  /// Reply-to-reply attaches to the original top-level parent.
  static String resolveReplyParentId({
    required Comment target,
    required List<Comment> allComments,
  }) {
    if (target.parentCommentId == null) {
      return target.id;
    }

    final parentId = target.parentCommentId!;
    for (final comment in allComments) {
      if (comment.id == parentId) {
        return comment.parentCommentId ?? comment.id;
      }
    }
    // Orphaned reply target — treat as top-level parent id.
    return parentId;
  }

  /// Groups flat comments into one-level threads.
  ///
  /// Top-level comments: oldest first.
  /// Replies within a thread: oldest first.
  /// Orphaned replies (unknown parent): rendered as top-level fallback.
  static List<CommentThread> buildCommentThreads(List<Comment> comments) {
    final roots = <Comment>[];
    final repliesByParent = <String, List<Comment>>{};
    final ids = {for (final c in comments) c.id};

    for (final comment in comments) {
      final parentId = comment.parentCommentId;
      if (parentId == null) {
        roots.add(comment);
        continue;
      }
      if (!ids.contains(parentId)) {
        // Orphaned reply → safe top-level fallback.
        roots.add(comment);
        continue;
      }
      repliesByParent.putIfAbsent(parentId, () => []).add(comment);
    }

    int byCreatedAt(Comment a, Comment b) {
      final byTime = a.createdAt.compareTo(b.createdAt);
      if (byTime != 0) return byTime;
      return a.id.compareTo(b.id);
    }

    roots.sort(byCreatedAt);
    for (final replies in repliesByParent.values) {
      replies.sort(byCreatedAt);
    }

    return [
      for (final root in roots)
        CommentThread(
          root: root,
          replies: List<Comment>.unmodifiable(
            repliesByParent[root.id] ?? const [],
          ),
        ),
    ];
  }

  static int totalCount(List<Comment> comments) => comments.length;
}
