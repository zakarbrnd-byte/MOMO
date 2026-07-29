import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/card_header.dart';
import '../../../core/widgets/momo_card.dart';
import '../../../models/group.dart';

/// Shared Group community card.
///
/// [variant] controls discovery vs personal-library presentation.
/// Membership Join/Leave never appear here — only on Group Detail.
class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.group,
    required this.onTap,
    this.variant = GroupCardVariant.discovery,
    @visibleForTesting this.now,
  });

  final Group group;
  final VoidCallback onTap;
  final GroupCardVariant variant;

  @visibleForTesting
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    return MomoCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            categoryBadge: _GroupCategoryBadge(label: group.category),
            authorName: group.ownerName,
            createdAt: group.recentActivityAt ?? group.createdAt,
            now: now,
          ),
          const SizedBox(height: AppSpacing.cardContentGap),
          Text(
            group.name,
            style: AppTextStyles.cardTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (group.description.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.cardContentGap),
            Text(
              group.description,
              style: AppTextStyles.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.cardContentGap),
          Text(
            [
              group.location,
              if (group.childAgeRanges.isNotEmpty)
                group.childAgeRanges.join(' · '),
              '멤버 ${group.memberCount}명',
            ].join(' · '),
            style: AppTextStyles.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (group.interestTags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.cardContentGap),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                for (final tag in group.interestTags.take(4))
                  Text(
                    '#$tag',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
              ],
            ),
          ],
          if (variant == GroupCardVariant.myGroups) ...[
            const SizedBox(height: AppSpacing.cardContentGap),
            Text(
              'Joined',
              style: AppTextStyles.caption.copyWith(color: AppColors.success),
            ),
          ],
        ],
      ),
    );
  }
}

enum GroupCardVariant {
  /// Home discovery — info only, no membership CTA.
  discovery,

  /// My Groups library — optional joined caption, no Join button.
  myGroups,
}

class _GroupCategoryBadge extends StatelessWidget {
  const _GroupCategoryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
