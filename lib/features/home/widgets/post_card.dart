import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/engagement_row.dart';
import '../../../core/widgets/momo_card.dart';
import '../../../models/post.dart';

/// Feed card for a community post — MissyUSA-inspired, modern mobile layout.
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
    final authorMeta = [
      post.authorName,
      if (post.authorLocation != null && post.authorLocation!.trim().isNotEmpty)
        post.authorLocation!.trim(),
      if (post.authorContext != null && post.authorContext!.trim().isNotEmpty)
        post.authorContext!.trim(),
    ].join(' · ');

    return MomoCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppSpacing.chipPadding,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Text(
              post.category,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.cardTitleGap),
          Text(
            post.title,
            style: AppTextStyles.subtitle.copyWith(fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.cardContentGap),
          Text(
            post.content,
            style: AppTextStyles.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.cardFooterGap),
          Text(
            authorMeta,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          EngagementRow(
            viewCount: post.viewCount,
            commentCount: post.commentCount,
            likeCount: post.likeCount,
            compact: true,
          ),
        ],
      ),
    );
  }
}
