import 'entity_status.dart';
import 'post_category.dart';

export 'post_category.dart';

/// Domain model for a parenting post.
///
/// [authorName] is a denormalized display field for MVP UI.
/// [creatorId] is the stable owner reference for backend sync.
///
/// [category], [viewCount], [commentCount], and [likeCount] are display-ready
/// seed fields for Phase 3.5 cards. Interactive likes/comments/views and
/// category selection UI are deferred.
///
/// Reserved for later (not modeled yet): images.
class Post {
  const Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    this.creatorId,
    this.category = PostCategory.parenting,
    this.viewCount = 0,
    this.commentCount = 0,
    this.likeCount = 0,
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

  /// Topic chip for community cards (default [PostCategory.parenting]).
  final PostCategory category;

  /// Display-only engagement seed (not user-editable; not live-tracked yet).
  final int viewCount;

  /// Display-only engagement seed (comments UI not implemented).
  final int commentCount;

  /// Display-only engagement seed (likes UI not implemented).
  final int likeCount;

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
    PostCategory? category,
    int? viewCount,
    int? commentCount,
    int? likeCount,
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
      category: category ?? this.category,
      viewCount: viewCount ?? this.viewCount,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
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
