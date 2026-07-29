import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/momo_button.dart';
import '../../core/widgets/momo_success_banner.dart';
import '../../models/group.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/group_provider.dart';
import '../create/create_event_screen.dart';

/// Lower-frequency Group metadata and membership / event actions.
///
/// Opened from the Group Detail info icon. Membership state comes only from
/// [currentUserGroupIdsProvider] / [groupProvider].
class GroupInfoScreen extends ConsumerWidget {
  const GroupInfoScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(groupProvider);
    final groups = ref.watch(groupProvider).valueOrNull ?? const <Group>[];
    Group? group;
    for (final g in groups) {
      if (g.id == groupId) {
        group = g;
        break;
      }
    }
    group ??= ref.read(groupProvider.notifier).getById(groupId);

    if (group == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('모임 정보')),
        body: const Center(child: Text('Group not found')),
      );
    }

    final current = group;
    final isMember =
        ref.watch(currentUserGroupIdsProvider).contains(current.id);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(title: const Text('모임 정보')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xxl + bottomInset,
        ),
        children: [
          Text(current.name, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(current.category, style: AppTextStyles.caption),
          if (current.description.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(current.description, style: AppTextStyles.bodySmall),
          ],
          const SizedBox(height: AppSpacing.xl),
          const _SectionTitle('위치'),
          Text(current.location, style: AppTextStyles.bodyMedium),
          if (current.childAgeRanges.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const _SectionTitle('아이 연령'),
            Text(
              current.childAgeRanges.join(' · '),
              style: AppTextStyles.bodyMedium,
            ),
          ],
          if (current.interestTags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const _SectionTitle('관심사'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                for (final tag in current.interestTags)
                  Text(
                    '#$tag',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          const _SectionTitle('멤버'),
          Text('${current.memberCount}명', style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.xxl),
          if (isMember) ...[
            const _JoinedStatusChip(),
            const SizedBox(height: AppSpacing.xl),
            const _SectionTitle('모임 활동'),
            const SizedBox(height: AppSpacing.md),
            MomoButton(
              label: '이벤트 만들기',
              onPressed: () {
                AppNavigation.pushPage(
                  context,
                  CreateEventScreen(groupId: current.id),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  final notifier = ref.read(groupProvider.notifier);
                  if (!notifier.isMember(current.id)) return;
                  notifier.leaveGroup(current.id);
                  if (!context.mounted) return;
                  if (notifier.isMember(current.id)) return;
                  MomoSuccessBanner.show(context, '모임에서 나왔습니다.');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Leave Group',
                  style: AppTextStyles.button.copyWith(color: AppColors.error),
                ),
              ),
            ),
          ] else
            MomoButton(
              label: 'Join Group',
              onPressed: () {
                final notifier = ref.read(groupProvider.notifier);
                if (notifier.isMember(current.id)) return;
                notifier.joinGroup(current.id);
                if (!context.mounted) return;
                if (!notifier.isMember(current.id)) return;
                MomoSuccessBanner.show(
                  context,
                  '모임에 가입했습니다.',
                  actionLabel: '내 모임에서 보기',
                  onAction: () {
                    AppNavigation.selectTab(ref, MainTabs.groups);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Soft, non-interactive membership indicator.
class _JoinedStatusChip extends StatelessWidget {
  const _JoinedStatusChip();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Padding(
          padding: AppSpacing.chipPadding,
          child: Text(
            '내 모임',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
