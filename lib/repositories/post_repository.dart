import '../core/result/result.dart';
import '../models/post.dart';

/// Standard post repository API (backend-request flow).
///
/// Convention: [load], [create], [update], [delete] — all async;
/// mutations return [Result] (`true` on success).
abstract class PostRepository {
  /// Load all posts — global + group-scoped (future: GET /posts).
  Future<List<Post>> load();

  /// Load posts for one Group (future: GET /groups/:id/posts).
  Future<List<Post>> loadByGroup(String groupId);

  /// Create a post (future: POST /posts).
  Future<Result<bool>> create({
    required String title,
    required String content,
    String? authorName,
  });

  /// Replace or insert by id (future: PATCH /posts/:id).
  Future<Result<bool>> update(Post post);

  Future<Result<bool>> delete(String postId);
}
