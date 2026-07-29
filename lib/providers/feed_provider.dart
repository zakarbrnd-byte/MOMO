import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/feed_item.dart';
import '../models/group.dart';
import '../models/post.dart';
import 'group_provider.dart';
import 'post_provider.dart';

/// Home feed helpers retained for mixed-feed composition tests.
///
/// Phase 3.8 Home UI uses [homeDiscoveryProvider] for Group discovery.
/// [composeFeedItems] remains available for featured-group + global-post ordering.
List<FeedItem> composeFeedItems({
  required List<Group> groups,
  required List<Post> posts,
}) {
  final items = <FeedItem>[];

  final featured = groups.where((g) => g.isFeatured).toList();
  final rest = groups.where((g) => !g.isFeatured).toList();
  for (final group in [...featured, ...rest]) {
    items.add(GroupFeedItem(group));
  }

  final globalPosts = posts.where((p) => p.isGlobal).toList();
  for (final post in globalPosts) {
    items.add(PostFeedItem(post));
  }

  return items;
}

/// Derived home feed as [AsyncValue]: loading / data / error.
final feedProvider = Provider<AsyncValue<List<FeedItem>>>((ref) {
  final groupsAsync = ref.watch(groupProvider);
  final postsAsync = ref.watch(postProvider);

  if (groupsAsync.isLoading || postsAsync.isLoading) {
    return const AsyncLoading();
  }

  if (groupsAsync.hasError) {
    return AsyncError(
      groupsAsync.error!,
      groupsAsync.stackTrace ?? StackTrace.current,
    );
  }

  if (postsAsync.hasError) {
    return AsyncError(
      postsAsync.error!,
      postsAsync.stackTrace ?? StackTrace.current,
    );
  }

  return AsyncData(
    composeFeedItems(
      groups: groupsAsync.requireValue,
      posts: postsAsync.requireValue,
    ),
  );
});
