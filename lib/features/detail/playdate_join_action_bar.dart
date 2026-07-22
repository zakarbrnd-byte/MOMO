import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/momo_success_banner.dart';
import '../../models/playdate.dart';
import '../../providers/current_user_provider.dart';
import '../../providers/playdate_provider.dart';

/// Shared join / leave / full / owner control driven by [Playdate.joinStateFor].
class PlaydateJoinActionBar extends ConsumerWidget {
  const PlaydateJoinActionBar({super.key, required this.playdate});

  final Playdate playdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserProvider).id;
    final joinState = playdate.joinStateFor(userId);

    return Material(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.actionBar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                joinState.isOwnerState
                    ? 'My Playdate'
                    : playdate.participantsLabel,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (joinState.isOwnerState) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  playdate.participantsLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              if (joinState.isFullState) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Playdate Full',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryDark,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              switch (joinState) {
                PlaydateJoinState.owner => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit Playdate coming soon'),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryDark,
                          side: const BorderSide(color: AppColors.primary),
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Edit Playdate'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      FilledButton(
                        onPressed: () => _confirmCancel(context, ref, userId),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Cancel Playdate'),
                      ),
                    ],
                  ),
                PlaydateJoinState.leave => OutlinedButton(
                    onPressed: () {
                      final left = ref
                          .read(playdateProvider.notifier)
                          .leavePlaydate(playdate.id, userId);
                      if (left && context.mounted) {
                        MomoSuccessBanner.show(
                          context,
                          'You left this playdate.',
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(joinState.actionLabel),
                  ),
                PlaydateJoinState.join => FilledButton(
                    onPressed: () {
                      final joined = ref
                          .read(playdateProvider.notifier)
                          .joinPlaydate(playdate.id, userId);
                      if (joined && context.mounted) {
                        MomoSuccessBanner.show(
                          context,
                          'Joined successfully!',
                        );
                      }
                    },
                    style: _primaryButtonStyle(),
                    child: Text(joinState.actionLabel),
                  ),
                PlaydateJoinState.full => FilledButton(
                    onPressed: null,
                    style: _primaryButtonStyle(),
                    child: Text(joinState.actionLabel),
                  ),
              },
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cancel this Playdate?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Keep'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Cancel Playdate'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final cancelled = ref
        .read(playdateProvider.notifier)
        .cancelPlaydate(playdate.id, userId);

    if (cancelled && context.mounted) {
      MomoSuccessBanner.show(context, 'Playdate cancelled.');
      Navigator.of(context).pop();
    }
  }

  ButtonStyle _primaryButtonStyle() {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      disabledBackgroundColor: AppColors.border,
      disabledForegroundColor: AppColors.textSecondary,
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
