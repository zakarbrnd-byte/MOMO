import '../models/entity_status.dart';
import '../models/post.dart';
import 'json_converters.dart';

/// Wire format for [Post].
///
/// Extra JSON keys (images, likes, comments, deletedAt, …) are ignored.
class PostDto {
  const PostDto({
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
  final String authorName;
  final String? creatorId;
  final PostStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(
      id: JsonConverters.stringFromJson(json['id']),
      title: JsonConverters.stringFromJson(json['title']),
      content: JsonConverters.stringFromJson(json['content']),
      authorName: JsonConverters.stringFromJson(json['authorName']),
      creatorId: JsonConverters.nullableStringFromJson(json['creatorId']),
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
      status: post.status,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
    );
  }
}
