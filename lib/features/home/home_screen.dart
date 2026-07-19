import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_feed.dart';
import '../../providers/feed_provider.dart';
import '../detail/playdate_detail_screen.dart';
import '../detail/post_detail_screen.dart';
import 'widgets/playdate_card.dart';
import 'widgets/post_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedItems = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MOMO')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: feedItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = feedItems[index];
          return switch (item) {
            PlaydateFeedItem(:final playdate) => PlaydateCard(
                playdate: playdate,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PlaydateDetailScreen(playdate: playdate),
                    ),
                  );
                },
              ),
            PostFeedItem(:final post) => PostCard(
                post: post,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(post: post),
                    ),
                  );
                },
              ),
          };
        },
      ),
    );
  }
}
