import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Compact view / comment / like metrics row (display-only in Phase 3.5).
class EngagementRow extends StatelessWidget {
  const EngagementRow({
    super.key,
    required this.viewCount,
    required this.commentCount,
    required this.likeCount,
    this.compact = false,
  });

  final int viewCount;
  final int commentCount;
  final int likeCount;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final style = (compact ? AppTextStyles.caption : AppTextStyles.bodySmall)
        .copyWith(color: AppColors.textSecondary);

    return Semantics(
      label: '조회 $viewCount, 댓글 $commentCount, 좋아요 $likeCount',
      child: Row(
        children: [
          _Metric(
            icon: Icons.visibility_outlined,
            value: viewCount,
            style: style,
            semantic: '조회',
          ),
          SizedBox(width: compact ? AppSpacing.md : AppSpacing.lg),
          _Metric(
            icon: Icons.chat_bubble_outline,
            value: commentCount,
            style: style,
            semantic: '댓글',
          ),
          SizedBox(width: compact ? AppSpacing.md : AppSpacing.lg),
          _Metric(
            icon: Icons.favorite_border,
            value: likeCount,
            style: style,
            semantic: '좋아요',
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.value,
    required this.style,
    required this.semantic,
  });

  final IconData icon;
  final int value;
  final TextStyle style;
  final String semantic;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$semantic $value',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text('$value', style: style),
        ],
      ),
    );
  }
}
