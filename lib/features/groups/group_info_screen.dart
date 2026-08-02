import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/async/mutation_notifier.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/momo_button.dart';
import '../../core/widgets/momo_error.dart';
import '../../core/widgets/momo_error_banner.dart';
import '../../core/widgets/momo_loading.dart';
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
    final groupAsync = ref.watch(groupByIdProvider(groupId));
    final joinedAsync = ref.watch(currentUserGroupIdsProvider);
    final joinMutation = ref.watch(joinGroupMutationProvider);
    final leaveMutation = ref.watch(leaveGroupMutationProvider);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(title: const Text('모임 정보')),
      body: groupAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        loading: () =>
            const MomoLoading(title: 'Loading...', message: 'Please wait.'),
        error: (error, _) => MomoError(
          title: 'Something went wrong',
          message: '모임 정보를 불러오지 못했습니다.',
          onRetry: () => ref.invalidate(groupByIdProvider(groupId)),
        ),
        data: (group) {
          if (group == null) {
            return const Center(child: Text('Group not found'));
          }

          final isMember = joinedAsync.maybeWhen(
            data: (ids) => ids.contains(group.id),
            orElse: () => false,
          );
          final membershipLoading =
              joinedAsync.isLoading && !joinedAsync.hasValue;

          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.xl,
              AppSpacing.xxl + bottomInset,
            ),
            children: [
              Text(group.name, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.sm),
              Text(group.category, style: AppTextStyles.caption),
              if (group.description.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(group.description, style: AppTextStyles.bodySmall),
              ],
              const SizedBox(height: AppSpacing.xl),
              const _SectionTitle('위치'),
              Text(group.location, style: AppTextStyles.bodyMedium),
              if (group.childAgeRanges.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                const _SectionTitle('아이 연령'),
                Text(
                  group.childAgeRanges.join(' · '),
                  style: AppTextStyles.bodyMedium,
                ),
              ],
              if (group.interestTags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                const _SectionTitle('관심사'),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final tag in group.interestTags)
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
              Text('${group.memberCount}명', style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppSpacing.xxl),
              if (membershipLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (isMember) ...[
                const _JoinedStatusChip(),
                const SizedBox(height: AppSpacing.xl),
                const _SectionTitle('모임 활동'),
                const SizedBox(height: AppSpacing.md),
                MomoButton(
                  label: '이벤트 만들기',
                  onPressed: leaveMutation.isLoading
                      ? null
                      : () {
                          AppNavigation.pushPage(
                            context,
                            CreateEventScreen(groupId: group.id),
                          );
                        },
                ),
                const SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: leaveMutation.isLoading
                        ? null
                        : () => _leave(context, ref, group),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: leaveMutation.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Leave Group',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                  ),
                ),
              ] else
                MomoButton(
                  label: 'Join Group',
                  isLoading: joinMutation.isLoading,
                  onPressed: joinMutation.isLoading
                      ? null
                      : () => _join(context, ref, group),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _join(BuildContext context, WidgetRef ref, Group group) async {
    final joined = ref.read(currentUserGroupIdsProvider).valueOrNull ?? {};
    if (joined.contains(group.id)) return;

    final ok = await ref.read(joinGroupMutationProvider.notifier).run(() async {
      await ref.read(groupProvider.notifier).joinGroup(group.id);
    });

    if (!context.mounted) return;
    if (ok) {
      MomoSuccessBanner.show(
        context,
        '모임에 가입했습니다.',
        actionLabel: '내 모임에서 보기',
        onAction: () {
          AppNavigation.selectTab(ref, MainTabs.groups);
        },
      );
    } else {
      MomoErrorBanner.show(context, '모임에 가입하지 못했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> _leave(BuildContext context, WidgetRef ref, Group group) async {
    final joined = ref.read(currentUserGroupIdsProvider).valueOrNull ?? {};
    if (!joined.contains(group.id)) return;

    final ok = await ref.read(leaveGroupMutationProvider.notifier).run(
      () async {
        await ref.read(groupProvider.notifier).leaveGroup(group.id);
      },
    );

    if (!context.mounted) return;
    if (ok) {
      MomoSuccessBanner.show(context, '모임에서 나왔습니다.');
    } else {
      MomoErrorBanner.show(context, '모임에서 나가지 못했습니다. 다시 시도해주세요.');
    }
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
