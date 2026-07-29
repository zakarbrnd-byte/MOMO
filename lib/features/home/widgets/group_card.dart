import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/card_header.dart';
import '../../../core/widgets/momo_button.dart';
import '../../../core/widgets/momo_card.dart';
import '../../../models/group.dart';
import '../../../providers/group_provider.dart';

/// Home / browse card for a persistent Group community.
class GroupCard extends ConsumerWidget {
  const GroupCard({
    super.key,
    required this.group,
    required this.onTap,
    @visibleForTesting this.now,
  });

  final Group group;
  final VoidCallback onTap;

  @visibleForTesting
  final DateTime? now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMember = ref.watch(currentUserGroupIdsProvider).contains(group.id);

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
          const SizedBox(height: AppSpacing.cardFooterGap),
          if (isMember)
            Text(
              'Joined',
              style: AppTextStyles.button.copyWith(color: AppColors.success),
            )
          else
            MomoButton(
              label: 'Join Group',
              fullWidth: true,
              onPressed: () {
                ref.read(groupProvider.notifier).joinGroup(group.id);
              },
            ),
        ],
      ),
    );
  }
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
