import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_feed.dart';
import '../../data/models/feed_item.dart';
import '../../data/providers/feed_provider.dart';
import '../../shared/widgets/cards/card_chrome.dart';
import '../../shared/widgets/cards/card_format.dart';

/// Full post details from the mock feed.
class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(feedProvider);
    final post = feed
        .whereType<PostFeedItem>()
        .map((item) => item.post)
        .where((p) => p.id == postId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: post == null
          ? const Center(
              child: Text(
                'Post not found',
                style: AppTypography.bodySecondary,
              ),
            )
          : ListView(
              padding: AppSpacing.screenInsets,
              children: [
                Row(
                  children: [
                    const CardTypeLabel(label: 'Post'),
                    const Spacer(),
                    Text(
                      CardFormat.postWhen(post.createdAt, now: MockFeed.now),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(post.title, style: AppTypography.headline),
                const SizedBox(height: AppSpacing.lg),
                Text(post.body, style: AppTypography.body),
                const SizedBox(height: AppSpacing.xl),
                const Text('Author', style: AppTypography.label),
                const SizedBox(height: AppSpacing.sm),
                CardAuthorRow(
                  name: post.author.displayName,
                  neighborhood: post.author.neighborhood,
                ),
              ],
            ),
    );
  }
}
