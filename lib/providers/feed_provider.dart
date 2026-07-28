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

enum HomeFeedFilter { all, playdates, posts }

final homeFeedFilterProvider =
    StateProvider<HomeFeedFilter>((ref) => HomeFeedFilter.all);

final homeCategoryFilterProvider = StateProvider<String?>((ref) => null);

/// Filtered home feed based on tab + optional category (posts only).
final homeFilteredFeedProvider = Provider<AsyncValue<List<FeedItem>>>((ref) {
  final feedAsync = ref.watch(feedProvider);
  final filter = ref.watch(homeFeedFilterProvider);
  final category = ref.watch(homeCategoryFilterProvider);

  return feedAsync.when(
    loading: () => const AsyncLoading(),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
    data: (items) {
      switch (filter) {
        case HomeFeedFilter.playdates:
          return AsyncData([
            for (final item in items)
              if (item is PlaydateFeedItem) item,
          ]);
        case HomeFeedFilter.posts:
          return AsyncData([
            for (final item in items)
              if (item is PostFeedItem)
                if (category == null || item.post.category == category) item,
          ]);
        case HomeFeedFilter.all:
          if (category == null) return AsyncData(items);
          return AsyncData([
            for (final item in items)
              if (item is PlaydateFeedItem)
                item
              else if (item is PostFeedItem && item.post.category == category)
                item,
          ]);
      }
    },
  );
});

final popularPostsProvider = Provider<AsyncValue<List<Post>>>((ref) {
  final postsAsync = ref.watch(postProvider);

  return postsAsync.when(
    loading: () => const AsyncLoading(),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
    data: (posts) {
      final sorted = List<Post>.from(posts)
        ..sort((a, b) => b.viewCount.compareTo(a.viewCount));
      return AsyncData(sorted.take(5).toList());
    },
  );
});

final recentPostsProvider = Provider<AsyncValue<List<Post>>>((ref) {
  final postsAsync = ref.watch(postProvider);

  return postsAsync.when(
    loading: () => const AsyncLoading(),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
    data: (posts) => AsyncData(posts.take(5).toList()),
  );
});

final upcomingPlaydatesProvider = Provider<AsyncValue<List<Playdate>>>((ref) {
  final playdatesAsync = ref.watch(playdateProvider);

  return playdatesAsync.when(
    loading: () => const AsyncLoading(),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
    data: (playdates) {
      final active = [
        for (final playdate in playdates)
          if (!playdate.isCancelled) playdate,
      ];
      return AsyncData(active.take(6).toList());
    },
  );
});
