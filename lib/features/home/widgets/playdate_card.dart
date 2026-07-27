import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/engagement_row.dart';
import '../../../core/widgets/momo_card.dart';
import '../../../models/playdate.dart';
import '../../../providers/current_user_provider.dart';

/// Feed card for a playdate — content only; chrome comes from [MomoCard].
class PlaydateCard extends ConsumerWidget {
  const PlaydateCard({
    super.key,
    required this.playdate,
    required this.onTap,
    this.compact = false,
  });

  final Playdate playdate;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserProvider).id;
    final joinState = playdate.joinStateFor(userId);
    final hostLine = [
      playdate.hostName,
      if (playdate.hostChildLabel != null &&
          playdate.hostChildLabel!.trim().isNotEmpty)
        playdate.hostChildLabel!.trim(),
    ].join(' · ');

    final whenLine = [
      if (playdate.date.trim().isNotEmpty) playdate.date.trim(),
      if (playdate.time.trim().isNotEmpty) playdate.time.trim(),
    ].join(' · ');

    return MomoCard(
      onTap: onTap,
      padding: compact ? AppSpacing.allLg : AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _TypeBadge(label: '플레이데이트'),
              const Spacer(),
              _StatusBadge(joinState: joinState),
            ],
          ),
          const SizedBox(height: AppSpacing.cardTitleGap),
          Text(
            playdate.title,
            style: AppTextStyles.subtitle.copyWith(fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (whenLine.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.cardContentGap),
            _MetaLine(icon: Icons.schedule, text: whenLine),
          ],
          const SizedBox(height: AppSpacing.cardContentGap),
          _MetaLine(icon: Icons.place_outlined, text: playdate.location),
          if (playdate.childAge.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.cardContentGap),
            _MetaLine(
              icon: Icons.child_care_outlined,
              text: playdate.childAge,
            ),
          ],
          const SizedBox(height: AppSpacing.cardContentGap),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primarySoft,
                child: Text(
                  _initial(playdate.hostName),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  hostLine,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                playdate.participantsLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.cardFooterGap),
          EngagementRow(
            viewCount: playdate.viewCount,
            commentCount: playdate.commentCount,
            likeCount: playdate.likeCount,
            compact: true,
          ),
        ],
      ),
    );
  }

  String _initial(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'M';
    return trimmed.substring(0, 1);
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label});

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
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.joinState});

  final PlaydateJoinState joinState;

  @override
  Widget build(BuildContext context) {
    final color = switch (joinState) {
      PlaydateJoinState.owner => AppColors.primaryDark,
      PlaydateJoinState.leave => AppColors.success,
      PlaydateJoinState.full => AppColors.textSecondary,
      PlaydateJoinState.join => AppColors.primary,
    };

    return Text(
      joinState.statusBadgeLabel,
      style: AppTextStyles.caption.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
