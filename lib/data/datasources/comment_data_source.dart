import '../../dto/comment_dto.dart';

/// Persistence port for comments (backend-ready).
abstract class CommentDataSource {
  Future<List<CommentDto>> fetchCommentsByPost(String postId);

  Future<CommentDto> insertComment({
    required String postId,
    required String authorId,
    required String authorName,
    required String body,
    String? parentCommentId,
  });
}
