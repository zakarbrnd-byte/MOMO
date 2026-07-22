import '../../models/post.dart';

/// Raw post persistence. No UI / provider knowledge.
///
/// Implementations: [MockPostDataSource] today,
/// future `SupabasePostDataSource` later — repositories stay stable.
abstract class PostDataSource {
  Future<List<Post>> getPosts();

  Future<void> createPost({
    required String title,
    required String content,
    String? authorName,
  });

  /// Insert or replace by id (raw upsert).
  Future<void> updatePost(Post post);

  Future<bool> deletePost(String postId);
}
