import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_feed.dart';
import 'playdate_provider.dart';
import 'post_provider.dart';

/// Derived home feed: interleaves playdates and posts (same pattern as original mock feed).
final feedProvider = Provider<List<FeedItem>>((ref) {
  final playdates = ref.watch(playdateProvider);
  final posts = ref.watch(postProvider);

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
});
