import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_feed.dart';
import '../models/post.dart';

/// In-memory posts as [AsyncValue] for loading / data / error UX.
/// Seeded from mock data; swap [build] for a repository later.
class PostNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    return List<Post>.from(mockPosts);
  }

  List<Post> get posts => state.valueOrNull ?? const [];

  void addPost(Post post) {
    state = AsyncData([post, ...posts]);
  }

  /// Builds a post from form fields and prepends it to local state.
  void createPost({
    required String title,
    required String content,
    String? authorName,
  }) {
    addPost(
      Post(
        id: 'po_${DateTime.now().millisecondsSinceEpoch}',
        title: title.trim(),
        content: content.trim(),
        authorName: authorName?.trim().isNotEmpty == true
            ? authorName!.trim()
            : mockProfile.displayName,
      ),
    );
  }

  void updatePost(Post post) {
    state = AsyncData([
      for (final item in posts)
        if (item.id == post.id) post else item,
    ]);
  }
}

final postProvider =
    AsyncNotifierProvider<PostNotifier, List<Post>>(PostNotifier.new);
