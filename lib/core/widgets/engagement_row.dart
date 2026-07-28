import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Display-only engagement metrics row (views · comments · likes).
///
/// Metrics are not interactive — taps belong to a later Phase 3.5 task.
class EngagementRow extends StatelessWidget {
  const EngagementRow({
    super.key,
    required this.viewCount,
    required this.commentCount,
    required this.likeCount,
  });

  final int viewCount;
  final int commentCount;
  final int likeCount;

  static const double _iconSize = 16;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Metric(
            icon: Icons.visibility_outlined,
            count: viewCount,
            semanticLabel: '조회수 $viewCount',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _Metric(
            icon: Icons.chat_bubble_outline,
            count: commentCount,
            semanticLabel: '댓글 $commentCount개',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _Metric(
            icon: Icons.favorite_border,
            count: likeCount,
            semanticLabel: '좋아요 $likeCount개',
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.count,
    required this.semanticLabel,
  });

  final IconData icon;
  final int count;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: EngagementRow._iconSize,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              '$count',
              style: AppTextStyles.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
