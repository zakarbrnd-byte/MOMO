import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/momo_card.dart';
import '../../models/post.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final title = post.title.trim().isEmpty ? 'Untitled post' : post.title.trim();
    final content = post.content.trim().isEmpty
        ? 'No content provided.'
        : post.content.trim();
    final author =
        post.authorName.trim().isEmpty ? 'A MOMO mom' : post.authorName.trim();
    final hasContent = post.content.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: SingleChildScrollView(
        padding: AppSpacing.pageForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.headlineMedium),
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
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(author, style: textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Shared with the MOMO community',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Post', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            SelectableText(
              content,
              style: textTheme.bodyLarge?.copyWith(
                color: hasContent
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'M';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
