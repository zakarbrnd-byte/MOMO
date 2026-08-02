import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/card_header.dart';
import '../../../core/widgets/momo_card.dart';
import '../../../models/group.dart';
import '../../../providers/group_provider.dart';

/// Shared Group community card.
///
/// [variant] controls discovery vs personal-library presentation.
/// Membership Join/Leave never appear here — only on Group Detail.
class GroupCard extends ConsumerWidget {
  const GroupCard({
    super.key,
    required this.group,
    required this.onTap,
    this.variant = GroupCardVariant.discovery,
    this.recommendationReasons = const [],
    @visibleForTesting this.now,
  });

  final Group group;
  final VoidCallback onTap;
  final GroupCardVariant variant;

  /// Optional secondary discovery reasons (max two shown).
  final List<String> recommendationReasons;

  @visibleForTesting
  final DateTime? now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isJoined = ref
        .watch(currentUserGroupIdsProvider)
        .maybeWhen(data: (ids) => ids.contains(group.id), orElse: () => false);

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
            trailing: const _BookmarkAffordance(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            group.name,
            style: AppTextStyles.cardTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (recommendationReasons.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            for (final reason in recommendationReasons.take(2))
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text(
                  reason,
                  style: AppTextStyles.metadata,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          if (group.description.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              group.description,
              style: AppTextStyles.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _GroupMetadata(
            location: group.location,
            ageRanges: group.childAgeRanges,
            memberCount: group.memberCount,
          ),
          if (group.interestTags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.xs,
              children: [
                for (final tag in group.interestTags.take(4))
                  Text(
                    '#$tag',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
          if (variant == GroupCardVariant.discovery && isJoined) ...[
            const SizedBox(height: AppSpacing.md),
            const _JoinedMembershipChip(),
          ],
          if (variant == GroupCardVariant.myGroups) ...[
            const SizedBox(height: AppSpacing.md),
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

/// Visual-only bookmark control (no persistence yet).
class _BookmarkAffordance extends StatelessWidget {
  const _BookmarkAffordance();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '북마크',
      button: false,
      child: const SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: Icon(
            Icons.bookmark_border_rounded,
            size: 22,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _GroupMetadata extends StatelessWidget {
  const _GroupMetadata({
    required this.location,
    required this.ageRanges,
    required this.memberCount,
  });

  final String location;
  final List<String> ageRanges;
  final int memberCount;

  @override
  Widget build(BuildContext context) {
    final ages = ageRanges.isEmpty ? null : ageRanges.join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          location,
          style: AppTextStyles.metadata,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (ages != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            ages,
            style: AppTextStyles.metadata,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: AppSpacing.xs),
        Text(
          '👥 $memberCount명',
          style: AppTextStyles.metadata,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Soft, non-interactive membership indicator for Home discovery cards.
class _JoinedMembershipChip extends StatelessWidget {
  const _JoinedMembershipChip();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: AppSpacing.chipPadding,
        child: Text(
          '내 모임',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
