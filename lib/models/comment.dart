/// Domain comment on a [Post]. Flat list + [parentCommentId] is the source of truth.
class Comment {
  const Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.body,
    required this.createdAt,
    this.parentCommentId,
  });

  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String body;
  final DateTime createdAt;

  /// Null for top-level comments; set for one-level replies.
  final String? parentCommentId;

  bool get isTopLevel => parentCommentId == null;

  bool get isReply => parentCommentId != null;

  Comment copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? authorName,
    String? body,
    DateTime? createdAt,
    Object? parentCommentId = _unset,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      parentCommentId: identical(parentCommentId, _unset)
          ? this.parentCommentId
          : parentCommentId as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment &&
        other.id == id &&
        other.postId == postId &&
        other.authorId == authorId &&
        other.authorName == authorName &&
        other.body == body &&
        other.createdAt == createdAt &&
        other.parentCommentId == parentCommentId;
  }

  @override
  int get hashCode => Object.hash(
        id,
        postId,
        authorId,
        authorName,
        body,
        createdAt,
        parentCommentId,
      );
}

const _unset = Object();

/// One visible nesting level: a root comment plus its direct replies.
class CommentThread {
  const CommentThread({required this.root, required this.replies});

  final Comment root;
  final List<Comment> replies;
}
