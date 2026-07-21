import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/playdate.dart';
import '../../providers/playdate_provider.dart';
import 'playdate_join_action_bar.dart';

class PlaydateDetailScreen extends ConsumerWidget {
  const PlaydateDetailScreen({super.key, required this.playdate});

  /// Initial playdate; live data is read from [playdateProvider] by id.
  final Playdate playdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playdates = ref.watch(playdateProvider).valueOrNull;
    final latest = playdates
            ?.where((item) => item.id == playdate.id)
            .firstOrNull ??
        playdate;

    final textTheme = Theme.of(context).textTheme;
    final title =
        latest.title.trim().isEmpty ? 'Untitled playdate' : latest.title.trim();
    final location = latest.location.trim().isEmpty
        ? 'Location not specified'
        : latest.location.trim();
    final date =
        latest.date.trim().isEmpty ? 'Date not specified' : latest.date.trim();
    final host =
        latest.hostName.trim().isEmpty ? 'A MOMO mom' : latest.hostName.trim();
    final hasTime = latest.time.trim().isNotEmpty;
    final hasChildAge = latest.childAge.trim().isNotEmpty;
    final hasDescription = latest.description.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Playdate')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.page,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Hosted by $host',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _InfoCard(
                    children: [
                      _DetailRow(
                        icon: Icons.place_outlined,
                        label: 'Location',
                        value: location,
                      ),
                      _DetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date',
                        value: date,
                      ),
                      if (hasTime)
                        _DetailRow(
                          icon: Icons.access_time,
                          label: 'Time',
                          value: latest.time.trim(),
                        )
                      else
                        const _DetailRow(
                          icon: Icons.access_time,
                          label: 'Time',
                          value: 'Time not specified',
                          muted: true,
                        ),
                      if (hasChildAge)
                        _DetailRow(
                          icon: Icons.child_care_outlined,
                          label: 'Child Age',
                          value: latest.childAge.trim(),
                        )
                      else
                        const _DetailRow(
                          icon: Icons.child_care_outlined,
                          label: 'Child Age',
                          value: 'Not specified',
                          muted: true,
                        ),
                      _DetailRow(
                        icon: Icons.groups_outlined,
                        label: 'Participants',
                        value: latest.participantsLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Description', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    hasDescription
                        ? latest.description.trim()
                        : 'No description provided.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: hasDescription
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PlaydateJoinActionBar(playdate: latest),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: Column(children: children),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.muted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: muted ? AppColors.textSecondary : AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: textTheme.bodyLarge?.copyWith(
                    color:
                        muted ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
