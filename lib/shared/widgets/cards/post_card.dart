import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/post.dart';
import 'base_card.dart';
import 'card_chrome.dart';
import 'card_format.dart';

/// Feed card for a post — same shell as [PlaydateCard], note-focused body.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.now,
  });

  final Post post;
  final VoidCallback? onTap;

  /// Injected clock for stable relative timestamps in tests.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      semanticLabel: 'Post: ${post.title}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CardTypeLabel(label: 'Post'),
              const Spacer(),
              Text(
                CardFormat.postWhen(post.createdAt, now: now),
                style: AppTypography.caption,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            post.title,
            style: AppTypography.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (post.body.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              post.body,
              style: AppTypography.bodySecondary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          CardAuthorRow(
            name: post.author.displayName,
            neighborhood: post.author.neighborhood,
          ),
        ],
      ),
    );
  }
}
