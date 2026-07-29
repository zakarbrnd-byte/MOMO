import 'package:flutter/foundation.dart';

import '../../../models/post.dart';
import '../../mock_groups.dart';
import '../../mock_user.dart';
import '../post_data_source.dart';
import 'mock_profile_data_source.dart';

/// In-memory post store seeded from [mockAllPosts] (group + global).
///
/// Owns mock collections — repositories must not hold seed lists.
class MockPostDataSource implements PostDataSource {
  MockPostDataSource({List<Post>? seed})
    : _items = List<Post>.from(seed ?? mockAllPosts);

  final List<Post> _items;

  @override
  Future<List<Post>> getPosts() {
    return SynchronousFuture(List<Post>.from(_items));
  }

  @override
  Future<List<Post>> getPostsByGroup(String groupId) {
    return SynchronousFuture([
      for (final post in _items)
        if (post.groupId == groupId) post,
    ]);
  }

  @override
  Future<void> createPost({
    required String title,
    required String content,
    String? authorName,
  }) {
    final now = DateTime.now();
    // Category selection UI is deferred; defaults: parenting + zero engagement.
    final post = Post(
      id: 'po_${now.millisecondsSinceEpoch}',
      title: title.trim(),
      content: content.trim(),
      authorName: authorName?.trim().isNotEmpty == true
          ? authorName!.trim()
          : seedProfile.displayName,
      creatorId: currentUserId,
      createdAt: now,
      updatedAt: now,
    );
    _items.insert(0, post);
    return SynchronousFuture(null);
  }

  @override
  Future<void> updatePost(Post post) {
    final index = _items.indexWhere((item) => item.id == post.id);
    if (index >= 0) {
      _items[index] = post;
    } else {
      _items.insert(0, post);
    }
    return SynchronousFuture(null);
  }

  @override
  Future<bool> deletePost(String postId) {
    final before = _items.length;
    _items.removeWhere((item) => item.id == postId);
    return SynchronousFuture(_items.length < before);
  }
}
