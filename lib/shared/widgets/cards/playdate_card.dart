import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/playdate.dart';
import 'base_card.dart';
import 'card_chrome.dart';
import 'card_format.dart';

/// Feed card for a playdate — same shell as [PostCard], meetup-focused meta.
class PlaydateCard extends StatelessWidget {
  const PlaydateCard({
    super.key,
    required this.playdate,
    this.onTap,
  });

  final Playdate playdate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      semanticLabel: 'Playdate: ${playdate.title}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTypeLabel(label: 'Playdate', emphasized: true),
          const SizedBox(height: AppSpacing.md),
          Text(
            playdate.title,
            style: AppTypography.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          CardMetaRow(
            icon: Icons.schedule_rounded,
            text: CardFormat.playdateWhen(playdate.startsAt),
          ),
          const SizedBox(height: AppSpacing.sm),
          CardMetaRow(
            icon: Icons.place_outlined,
            text: playdate.location,
          ),
          if (playdate.ageRange != null && playdate.ageRange!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            CardMetaRow(
              icon: Icons.child_care_outlined,
              text: 'Ages ${playdate.ageRange}',
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          CardAuthorRow(
            name: playdate.host.displayName,
            neighborhood: playdate.host.neighborhood,
          ),
        ],
      ),
    );
  }
}
