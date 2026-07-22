import 'entity_status.dart';

/// Domain model for a parenting post.
///
/// [authorName] is a denormalized display field for MVP UI.
/// [creatorId] is the stable owner reference for backend sync.
///
/// Reserved for later (not modeled yet): images, likes, comments.
class Post {
  const Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    this.creatorId,
    this.status = PostStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String content;

  /// Display name shown on cards / detail (denormalized).
  final String authorName;

  /// Owning user id when known.
  final String? creatorId;

  final PostStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isActive => status == PostStatus.active;

  Post copyWith({
    String? id,
    String? title,
    String? content,
    String? authorName,
    Object? creatorId = _unset,
    PostStatus? status,
    Object? createdAt = _unset,
    Object? updatedAt = _unset,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      creatorId: identical(creatorId, _unset)
          ? this.creatorId
          : creatorId as String?,
      status: status ?? this.status,
      createdAt: identical(createdAt, _unset)
          ? this.createdAt
          : createdAt as DateTime?,
      updatedAt: identical(updatedAt, _unset)
          ? this.updatedAt
          : updatedAt as DateTime?,
    );
  }
}

const _unset = Object();
