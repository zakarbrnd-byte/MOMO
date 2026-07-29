import '../../models/post.dart';

/// Raw post persistence. No UI / provider knowledge.
///
/// Implementations: [MockPostDataSource] today,
/// future `SupabasePostDataSource` later — repositories stay stable.
abstract class PostDataSource {
  /// All posts (global community + group-scoped).
  Future<List<Post>> getPosts();

  /// Posts belonging to a single Group (`groupId` match).
  Future<List<Post>> getPostsByGroup(String groupId);

  Future<void> createPost({
    required String title,
    required String content,
    String? authorName,
  });

  /// Insert or replace by id (raw upsert).
  Future<void> updatePost(Post post);

  Future<bool> deletePost(String postId);
}
