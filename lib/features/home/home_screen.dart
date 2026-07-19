import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/mock_feed.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/feed_provider.dart';
import '../../providers/playdate_provider.dart';
import '../../providers/post_provider.dart';
import '../create/create_playdate_screen.dart';
import '../create/create_post_screen.dart';
import '../detail/playdate_detail_screen.dart';
import '../detail/post_detail_screen.dart';
import 'widgets/playdate_card.dart';
import 'widgets/post_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);
    final playdatesAsync = ref.watch(playdateProvider);
    final postsAsync = ref.watch(postProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MOMO')),
      body: feedAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (_, __) => _FeedError(
          onRetry: () {
            ref.invalidate(playdateProvider);
            ref.invalidate(postProvider);
          },
        ),
        data: (feedItems) {
          final playdates = playdatesAsync.valueOrNull ?? const [];
          final posts = postsAsync.valueOrNull ?? const [];

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              if (playdates.isEmpty) ...[
                EmptyState(
                  title: '아직 등록된 Play Date가 없습니다.',
                  message: '첫 번째 모임을 만들어보세요.',
                  buttonText: 'Create Playdate',
                  onPressed: () {
                    AppNavigation.pushPage(
                      context,
                      const CreatePlaydateScreen(),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (posts.isEmpty) ...[
                EmptyState(
                  title: '아직 게시글이 없습니다.',
                  message: '첫 번째 이야기를 공유해보세요.',
                  buttonText: 'Create Post',
                  onPressed: () {
                    AppNavigation.pushPage(
                      context,
                      const CreatePostScreen(),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
              for (var i = 0; i < feedItems.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                _FeedCard(item: feedItems[i]),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({required this.item});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return switch (item) {
      PlaydateFeedItem(:final playdate) => PlaydateCard(
          playdate: playdate,
          onTap: () {
            AppNavigation.pushPage(
              context,
              PlaydateDetailScreen(playdate: playdate),
            );
          },
        ),
      PostFeedItem(:final post) => PostCard(
          post: post,
          onTap: () {
            AppNavigation.pushPage(
              context,
              PostDetailScreen(post: post),
            );
          },
        ),
    };
  }
}

class _FeedError extends StatelessWidget {
  const _FeedError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Something went wrong.', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Try again.', style: textTheme.bodyMedium),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
