import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_feed.dart';
import '../models/feed_item.dart';
import '../models/mom_user.dart';
import '../models/playdate.dart';
import '../models/post.dart';

/// Signed-in mock mom for Create / Profile (no auth yet).
final currentUserProvider = Provider<MomUser>((ref) => MockUsers.soojin);

/// Bottom tab index: 0 Home · 1 Create · 2 Profile.
final tabIndexProvider = StateProvider<int>((ref) => 0);

/// In-memory feed seeded from [MockFeed.items].
final feedProvider =
    StateNotifierProvider<FeedNotifier, List<FeedItem>>((ref) {
  return FeedNotifier();
});

class FeedNotifier extends StateNotifier<List<FeedItem>> {
  FeedNotifier([List<FeedItem>? seed])
      : super(List<FeedItem>.of(seed ?? MockFeed.items));

  void addPlaydate(Playdate playdate) {
    state = [PlaydateFeedItem(playdate), ...state];
  }

  void addPost(Post post) {
    state = [PostFeedItem(post), ...state];
  }

  Playdate? playdateById(String id) {
    for (final item in state) {
      if (item is PlaydateFeedItem && item.playdate.id == id) {
        return item.playdate;
      }
    }
    return null;
  }

  Post? postById(String id) {
    for (final item in state) {
      if (item is PostFeedItem && item.post.id == id) {
        return item.post;
      }
    }
    return null;
  }

  List<FeedItem> itemsForUser(String userId) {
    return state.where((item) {
      return switch (item) {
        PlaydateFeedItem(:final playdate) => playdate.host.id == userId,
        PostFeedItem(:final post) => post.author.id == userId,
      };
    }).toList();
  }
}
