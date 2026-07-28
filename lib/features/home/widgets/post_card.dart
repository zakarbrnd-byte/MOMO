import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/author_summary.dart';
import '../../../core/widgets/engagement_row.dart';
import '../../../core/widgets/momo_card.dart';
import '../../../models/post.dart';
import 'category_chip.dart';

/// Feed card for a post — content only; chrome comes from [MomoCard].
///
/// Minimal Phase 3.5.2 integration: [CategoryChip], [AuthorSummary], and
/// [EngagementRow]. Full visual redesign is deferred.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MomoCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryChip(category: post.category),
          const SizedBox(height: AppSpacing.cardContentGap),
          AuthorSummary(displayName: post.authorName),
          const SizedBox(height: AppSpacing.cardTitleGap),
          Text(post.title, style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.cardContentGap),
          Text(
            post.content,
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.cardFooterGap),
          EngagementRow(
            viewCount: post.viewCount,
            commentCount: post.commentCount,
            likeCount: post.likeCount,
          ),
        ],
      ),
    );
  }
}
