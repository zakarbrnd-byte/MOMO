import 'entity_status.dart';

/// Common post category labels for the Korean mom community feed.
abstract final class PostCategories {
  static const parenting = '육아질문';
  static const school = '학교·킨더';
  static const local = '지역정보';
  static const health = '병원·건강';
  static const food = '음식·간식';
  static const daily = '일상';
  static const market = '장터';

  /// Categories shown in Home discovery chips (MVP).
  static const discovery = <String>[
    parenting,
    school,
    local,
    health,
    food,
    daily,
  ];
}

/// Domain model for a parenting post.
///
/// [authorName] is a denormalized display field for MVP UI.
/// [creatorId] is the stable owner reference for backend sync.
///
/// Phase 3.5: [category], [authorLocation], [authorContext], and engagement
/// counts are denormalized display fields (mock). Likes/comments are not
/// interactive yet.
class Post {
  const Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    this.creatorId,
    this.category = PostCategories.daily,
    this.authorLocation,
    this.authorContext,
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

  /// Community category label (e.g. `학교·킨더`).
  final String category;

  /// Optional neighborhood / city for the author.
  final String? authorLocation;

  /// Optional parent context, e.g. `아이 4세`.
  final String? authorContext;

  /// Display-only engagement (mock / future analytics).
  final int viewCount;
  final int commentCount;
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
    String? category,
    Object? authorLocation = _unset,
    Object? authorContext = _unset,
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
      creatorId:
          identical(creatorId, _unset) ? this.creatorId : creatorId as String?,
      category: category ?? this.category,
      authorLocation: identical(authorLocation, _unset)
          ? this.authorLocation
          : authorLocation as String?,
      authorContext: identical(authorContext, _unset)
          ? this.authorContext
          : authorContext as String?,
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
