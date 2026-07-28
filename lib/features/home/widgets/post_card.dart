import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/engagement_row.dart';
import '../../../core/widgets/momo_card.dart';
import '../../../models/post.dart';
import 'category_chip.dart';

/// Community feed card for a parenting post.
///
/// Hierarchy: category + author → title → one-line preview → engagement.
/// Chrome comes from [MomoCard]; metrics and category are display-only.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  final Post post;
  final VoidCallback onTap;

  String get _title {
    final value = post.title.trim();
    return value.isEmpty ? 'Untitled post' : value;
  }

  String get _author {
    final value = post.authorName.trim();
    return value.isEmpty ? 'A MOMO mom' : value;
  }

  String get _semanticLabel {
    return '${post.category.labelKo} 게시글, $_title, 작성자 $_author';
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
                    _author,
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
