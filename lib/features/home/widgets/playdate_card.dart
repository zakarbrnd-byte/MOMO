import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/momo_card.dart';
import '../../../models/playdate.dart';
import '../../../providers/current_user_provider.dart';

/// Feed card for a playdate — content only; chrome comes from [MomoCard].
class PlaydateCard extends ConsumerWidget {
  const PlaydateCard({
    super.key,
    required this.playdate,
    required this.onTap,
  });

  final Playdate playdate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final isOwned = playdate.isOwner(ref.watch(currentUserProvider).id);

    return MomoCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSpacing.chipPadding,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Text(
                  'Playdate',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                playdate.hostName,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.cardTitleGap),
          Text(playdate.title, style: textTheme.titleLarge),
          if (isOwned) ...[
            const SizedBox(height: AppSpacing.cardContentGap),
            Text(
              'Created by you',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.cardTitleGap),
          _MetaRow(icon: Icons.calendar_today_outlined, label: playdate.date),
          if (playdate.time.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.cardContentGap),
            _MetaRow(icon: Icons.access_time, label: playdate.time),
          ],
          const SizedBox(height: AppSpacing.cardContentGap),
          _MetaRow(icon: Icons.place_outlined, label: playdate.location),
          if (playdate.childAge.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.cardContentGap),
            _MetaRow(
              icon: Icons.child_care_outlined,
              label: playdate.childAge,
            ),
          ],
          const SizedBox(height: AppSpacing.cardContentGap),
          _MetaRow(
            icon: Icons.groups_outlined,
            label: playdate.participantsLabel,
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
