import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/feed_item.dart';
import '../../data/providers/feed_provider.dart';
import '../../shared/widgets/cards/card_chrome.dart';
import '../../shared/widgets/cards/card_format.dart';

/// Full playdate details from the mock feed.
class PlaydateDetailScreen extends ConsumerWidget {
  const PlaydateDetailScreen({
    super.key,
    required this.playdateId,
  });

  final String playdateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(feedProvider);
    final playdate = feed
        .whereType<PlaydateFeedItem>()
        .map((item) => item.playdate)
        .where((p) => p.id == playdateId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Playdate')),
      body: playdate == null
          ? const Center(
              child: Text(
                'Playdate not found',
                style: AppTypography.bodySecondary,
              ),
            )
          : ListView(
              padding: AppSpacing.screenInsets,
              children: [
                const CardTypeLabel(label: 'Playdate', emphasized: true),
                const SizedBox(height: AppSpacing.md),
                Text(playdate.title, style: AppTypography.headline),
                const SizedBox(height: AppSpacing.xl),
                CardMetaRow(
                  icon: Icons.schedule_rounded,
                  text: CardFormat.playdateWhen(playdate.startsAt),
                ),
                const SizedBox(height: AppSpacing.md),
                CardMetaRow(
                  icon: Icons.place_outlined,
                  text: playdate.location,
                ),
                if (playdate.ageRange != null &&
                    playdate.ageRange!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  CardMetaRow(
                    icon: Icons.child_care_outlined,
                    text: 'Ages ${playdate.ageRange}',
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                const Text('Host', style: AppTypography.label),
                const SizedBox(height: AppSpacing.sm),
                CardAuthorRow(
                  name: playdate.host.displayName,
                  neighborhood: playdate.host.neighborhood,
                ),
                const SizedBox(height: AppSpacing.xxl),
                const Text(
                  'Meet offline — say hi when you arrive.',
                  style: AppTypography.bodySecondary,
                ),
              ],
            ),
    );
  }
}
