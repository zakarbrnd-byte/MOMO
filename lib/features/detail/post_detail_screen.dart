import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/engagement_row.dart';
import '../../core/widgets/momo_card.dart';
import '../../models/post.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final title = post.title.trim().isEmpty ? '제목 없음' : post.title.trim();
    final content =
        post.content.trim().isEmpty ? '내용이 없습니다.' : post.content.trim();
    final author =
        post.authorName.trim().isEmpty ? 'MOMO 엄마' : post.authorName.trim();
    final hasContent = post.content.trim().isNotEmpty;
    final authorMeta = [
      author,
      if (post.authorLocation != null && post.authorLocation!.trim().isNotEmpty)
        post.authorLocation!.trim(),
      if (post.authorContext != null && post.authorContext!.trim().isNotEmpty)
        post.authorContext!.trim(),
    ].join(' · ');

    return Scaffold(
      appBar: AppBar(title: const Text('육아톡')),
      body: SingleChildScrollView(
        padding: AppSpacing.pageForm,
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
            const SizedBox(height: AppSpacing.md),
            Text(title, style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSpacing.lg),
            MomoCard(
              padding: AppSpacing.allLg,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: Text(
                      _initials(author),
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(author, style: AppTextStyles.subtitle),
                        const SizedBox(height: AppSpacing.xs),
                        Text(authorMeta, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            EngagementRow(
              viewCount: post.viewCount,
              commentCount: post.commentCount,
              likeCount: post.likeCount,
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text('본문', style: AppTextStyles.subtitle),
            const SizedBox(height: AppSpacing.md),
            SelectableText(
              content,
              style: AppTextStyles.body.copyWith(
                color: hasContent
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                height: 1.55,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              '댓글·좋아요는 표시만 되며, 아직 상호작용은 지원하지 않아요.',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'M';
    return trimmed.substring(0, 1);
  }
}
