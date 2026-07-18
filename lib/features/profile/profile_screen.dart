import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_feed.dart';
import '../../data/models/feed_item.dart';
import '../../data/providers/feed_provider.dart';
import '../../features/playdate/playdate_detail_screen.dart';
import '../../features/post/post_detail_screen.dart';
import '../../shared/widgets/cards/card_chrome.dart';
import '../../shared/widgets/cards/playdate_card.dart';
import '../../shared/widgets/cards/post_card.dart';

/// Simple profile — current mock user and their cards.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final mine = ref.watch(feedProvider).where((item) {
      return switch (item) {
        PlaydateFeedItem(:final playdate) => playdate.host.id == user.id,
        PostFeedItem(:final post) => post.author.id == user.id,
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: AppSpacing.screenInsets,
        children: [
          CardAuthorRow(
            name: user.displayName,
            neighborhood: user.neighborhood,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Your cards on MOMO (mock)',
            style: AppTypography.bodySecondary,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (mine.isEmpty)
            const Text(
              'You have not posted yet.',
              style: AppTypography.bodySecondary,
            )
          else
            ...mine.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
                child: switch (item) {
                  PlaydateFeedItem(:final playdate) => PlaydateCard(
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
                      post: post,
                      now: MockFeed.now,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                PostDetailScreen(postId: post.id),
                          ),
                        );
                      },
                    ),
                },
              );
            }),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'No account yet — browsing as ${user.displayName}.',
            style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
