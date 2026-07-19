import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_feed.dart';
import '../models/post.dart';

/// In-memory post list. Seeded from mock data; ready to swap for a repository later.
class PostNotifier extends Notifier<List<Post>> {
  @override
  List<Post> build() => List<Post>.from(mockPosts);

  List<Post> get posts => state;

  void addPost(Post post) {
    state = [post, ...state];
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
    state = [
      for (final item in state)
        if (item.id == post.id) post else item,
    ];
  }
}

final postProvider = NotifierProvider<PostNotifier, List<Post>>(PostNotifier.new);
