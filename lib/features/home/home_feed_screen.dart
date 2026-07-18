import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_feed.dart';
import '../../data/models/feed_item.dart';
import '../../data/providers/feed_provider.dart';
import '../../features/playdate/playdate_detail_screen.dart';
import '../../features/post/post_detail_screen.dart';
import '../../shared/widgets/cards/playdate_card.dart';
import '../../shared/widgets/cards/post_card.dart';

/// Home Feed — vertical mix of playdate and post cards (mock / Riverpod).
class HomeFeedScreen extends ConsumerWidget {
  const HomeFeedScreen({
    super.key,
    this.items,
    this.now,
  });

  /// Override feed in tests. When null, reads [feedProvider].
  final List<FeedItem>? items;

  /// Clock for relative post timestamps.
  final DateTime? now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FeedItem> feed = items ?? ref.watch(feedProvider);
    final clock = now ?? MockFeed.now;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MOMO'),
      ),
      body: feed.isEmpty
          ? const _EmptyFeed()
          : CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      AppSpacing.sm,
                      AppSpacing.page,
                      AppSpacing.md,
                    ),
                    child: Text(
                      'Playdates near you',
                      style: AppTypography.bodySecondary,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    0,
                    AppSpacing.page,
                    AppSpacing.xl,
                  ),
                  sliver: SliverList.separated(
                    itemCount: feed.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.cardGap),
                    itemBuilder: (context, index) {
                      final item = feed[index];
                      return switch (item) {
                        PlaydateFeedItem(:final playdate) => PlaydateCard(
                            key: ValueKey(item.id),
                            playdate: playdate,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => PlaydateDetailScreen(
                                    playdateId: playdate.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        PostFeedItem(:final post) => PostCard(
                            key: ValueKey(item.id),
                            post: post,
                            now: clock,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => PostDetailScreen(
                                    postId: post.id,
                                  ),
                                ),
                              );
                            },
                          ),
                      };
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: AppSpacing.pageInsets,
        child: Text(
          'No cards yet.\nCreate a playdate or post to get started.',
          textAlign: TextAlign.center,
          style: AppTypography.bodySecondary,
        ),
      ),
    );
  }
}
