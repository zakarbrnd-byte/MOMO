import '../models/post.dart';

/// Contract for post access used by providers.
///
/// Persistence is provided by a [PostDataSource] (mock today, Supabase later).
/// Implementations: [PostRepositoryImpl].
abstract class PostRepository {
  Future<List<Post>> getPosts();

  Future<void> createPost({
    required String title,
    required String content,
    String? authorName,
  });

  /// Replaces by id, or inserts at the front when the id is new.
  Future<void> updatePost(Post post);

  Future<bool> deletePost(String postId);
}
