import '../core/result/result.dart';
import '../models/comment.dart';

/// Comment repository API (backend-request flow).
abstract class CommentRepository {
  Future<List<Comment>> loadCommentsByPost(String postId);

  Future<int> loadCommentCount(String postId);

  Future<Result<Comment>> createComment({
    required String postId,
    required String authorId,
    required String authorName,
    required String body,
    String? parentCommentId,
  });
}
