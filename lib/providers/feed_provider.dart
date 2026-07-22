import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/feed_item.dart';
import '../models/playdate.dart';
import '../models/post.dart';
import 'playdate_provider.dart';
import 'post_provider.dart';

List<FeedItem> composeFeedItems({
  required List<Playdate> playdates,
  required List<Post> posts,
}) {
  final items = <FeedItem>[];
  final length =
      playdates.length > posts.length ? playdates.length : posts.length;

  for (var i = 0; i < length; i++) {
    if (i < playdates.length) {
      items.add(PlaydateFeedItem(playdates[i]));
    }
    if (i < posts.length) {
      items.add(PostFeedItem(posts[i]));
    }
  }

  return items;
}

/// Derived home feed as [AsyncValue]: loading / data / error.
final feedProvider = Provider<AsyncValue<List<FeedItem>>>((ref) {
  final playdatesAsync = ref.watch(playdateProvider);
  final postsAsync = ref.watch(postProvider);

  if (playdatesAsync.isLoading || postsAsync.isLoading) {
    return const AsyncLoading();
  }

  if (playdatesAsync.hasError) {
    return AsyncError(
      playdatesAsync.error!,
      playdatesAsync.stackTrace ?? StackTrace.current,
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
      playdates: playdatesAsync.requireValue,
      posts: postsAsync.requireValue,
    ),
  );
});
