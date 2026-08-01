import '../models/comment.dart';
import 'json_converters.dart';

/// Wire format for [Comment].
class CommentDto {
  const CommentDto({
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
  final String? parentCommentId;

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    return CommentDto(
      id: JsonConverters.stringFromJson(json['id']),
      postId: JsonConverters.stringFromJson(json['postId']),
      authorId: JsonConverters.stringFromJson(json['authorId']),
      authorName: JsonConverters.stringFromJson(json['authorName']),
      body: JsonConverters.stringFromJson(json['body']),
      createdAt: JsonConverters.dateTimeFromJson(json['createdAt']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      parentCommentId: JsonConverters.nullableStringFromJson(
        json['parentCommentId'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      if (parentCommentId != null) 'parentCommentId': parentCommentId,
    };
  }

  Comment toDomain() {
    return Comment(
      id: id,
      postId: postId,
      authorId: authorId,
      authorName: authorName,
      body: body,
      createdAt: createdAt,
      parentCommentId: parentCommentId,
    );
  }

  factory CommentDto.fromDomain(Comment comment) {
    return CommentDto(
      id: comment.id,
      postId: comment.postId,
      authorId: comment.authorId,
      authorName: comment.authorName,
      body: comment.body,
      createdAt: comment.createdAt,
      parentCommentId: comment.parentCommentId,
    );
  }
}
