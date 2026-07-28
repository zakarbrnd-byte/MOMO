import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/time/relative_time_ko.dart';
import '../../../core/widgets/engagement_row.dart';
import '../../../core/widgets/momo_card.dart';
import '../../../models/post.dart';
import 'category_chip.dart';

/// Community feed card for a parenting post.
///
/// Hierarchy: category + author/time → title → one-line preview → engagement.
/// Chrome comes from [MomoCard]; metrics and category are display-only.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    @visibleForTesting this.now,
  });

  final Post post;
  final VoidCallback onTap;

  /// Optional clock override for widget tests.
  @visibleForTesting
  final DateTime? now;

  String get _title {
    final value = post.title.trim();
    return value.isEmpty ? 'Untitled post' : value;
  }

  String get _authorMeta => RelativeTimeKo.authorWithTime(
        post.authorName,
        post.createdAt,
        now: now,
      );

  String get _semanticLabel {
    return '${post.category.labelKo} 게시글, $_title, 작성자 $_authorMeta';
  }

  @override
  Widget build(BuildContext context) {
    final preview = post.content.trim();

    return Semantics(
      button: true,
      label: _semanticLabel,
      excludeSemantics: true,
      child: MomoCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(child: CategoryChip(category: post.category)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _authorMeta,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.cardContentGap),
            Text(
              _title,
              style: AppTextStyles.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (preview.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.cardContentGap),
              Text(
                preview,
                style: AppTextStyles.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSpacing.cardFooterGap),
            EngagementRow(
              viewCount: post.viewCount,
              commentCount: post.commentCount,
              likeCount: post.likeCount,
            ),
          ],
        ),
      ),
    );
  }
}
