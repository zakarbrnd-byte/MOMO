import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/momo_empty_state.dart';
import '../../core/widgets/momo_error.dart';
import '../../core/widgets/momo_loading.dart';
import '../../models/feed_item.dart';
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
        loading: () => const MomoLoading(
          title: 'Loading...',
          message: 'Please wait.',
        ),
        error: (error, _) => MomoError(
          title: 'Something went wrong',
          message: error.toString(),
          onRetry: () {
            ref.invalidate(playdateProvider);
            ref.invalidate(postProvider);
          },
        ),
        data: (feedItems) {
          final playdates = playdatesAsync.valueOrNull ?? const [];
          final posts = postsAsync.valueOrNull ?? const [];

          return ListView(
            padding: AppSpacing.page,
            children: [
              if (playdates.isEmpty) ...[
                MomoEmptyState(
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
                const SizedBox(height: AppSpacing.cardListGap),
              ],
              if (posts.isEmpty) ...[
                MomoEmptyState(
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
                const SizedBox(height: AppSpacing.cardListGap),
              ],
              for (var i = 0; i < feedItems.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.cardListGap),
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
