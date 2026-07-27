import '../models/entity_status.dart';
import '../models/post.dart';
import 'json_converters.dart';

/// Wire format for [Post].
///
/// Extra JSON keys (images, likes, comments arrays, deletedAt, …) are ignored.
/// Scalar engagement fields use [viewCount] / [commentCount] / [likeCount].
class PostDto {
  const PostDto({
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
  final String authorName;
  final String? creatorId;
  final String category;
  final String? authorLocation;
  final String? authorContext;
  final int viewCount;
  final int commentCount;
  final int likeCount;
  final PostStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PostDto.fromJson(Map<String, dynamic> json) {
    final categoryRaw = JsonConverters.nullableStringFromJson(json['category']);
    return PostDto(
      id: JsonConverters.stringFromJson(json['id']),
      title: JsonConverters.stringFromJson(json['title']),
      content: JsonConverters.stringFromJson(json['content']),
      authorName: JsonConverters.stringFromJson(json['authorName']),
      creatorId: JsonConverters.nullableStringFromJson(json['creatorId']),
      category: (categoryRaw == null || categoryRaw.isEmpty)
          ? PostCategories.daily
          : categoryRaw,
      authorLocation:
          JsonConverters.nullableStringFromJson(json['authorLocation']),
      authorContext:
          JsonConverters.nullableStringFromJson(json['authorContext']),
      viewCount: JsonConverters.intFromJson(json['viewCount']) ?? 0,
      commentCount: JsonConverters.intFromJson(json['commentCount']) ?? 0,
      likeCount: JsonConverters.intFromJson(json['likeCount']) ?? 0,
      status: JsonConverters.enumFromJson(
        json['status'],
        PostStatus.values,
        fallback: PostStatus.active,
      ),
      createdAt: JsonConverters.dateTimeFromJson(json['createdAt']),
      updatedAt: JsonConverters.dateTimeFromJson(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorName': authorName,
      if (creatorId != null) 'creatorId': creatorId,
      'category': category,
      if (authorLocation != null) 'authorLocation': authorLocation,
      if (authorContext != null) 'authorContext': authorContext,
      'viewCount': viewCount,
      'commentCount': commentCount,
      'likeCount': likeCount,
      'status': JsonConverters.enumToJson(status),
      if (createdAt != null)
        'createdAt': JsonConverters.dateTimeToJson(createdAt),
      if (updatedAt != null)
        'updatedAt': JsonConverters.dateTimeToJson(updatedAt),
    };
  }

  Post toDomain() {
    return Post(
      id: id,
      title: title,
      content: content,
      authorName: authorName,
      creatorId: creatorId,
      category: category,
      authorLocation: authorLocation,
      authorContext: authorContext,
      viewCount: viewCount,
      commentCount: commentCount,
      likeCount: likeCount,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory PostDto.fromDomain(Post post) {
    return PostDto(
      id: post.id,
      title: post.title,
      content: post.content,
      authorName: post.authorName,
      creatorId: post.creatorId,
      category: post.category,
      authorLocation: post.authorLocation,
      authorContext: post.authorContext,
      viewCount: post.viewCount,
      commentCount: post.commentCount,
      likeCount: post.likeCount,
      status: post.status,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
    );
  }
}
