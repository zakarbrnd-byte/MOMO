import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/playdate.dart';

class PlaydateCard extends StatelessWidget {
  const PlaydateCard({
    super.key,
    required this.playdate,
    required this.onTap,
  });

  final Playdate playdate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Playdate',
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontSize: 12,
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
              const SizedBox(height: 12),
              Text(playdate.title, style: textTheme.titleLarge),
              const SizedBox(height: 12),
              _MetaRow(icon: Icons.calendar_today_outlined, label: playdate.date),
              const SizedBox(height: 6),
              _MetaRow(icon: Icons.access_time, label: playdate.time),
              const SizedBox(height: 6),
              _MetaRow(icon: Icons.place_outlined, label: playdate.location),
              const SizedBox(height: 6),
              _MetaRow(icon: Icons.child_care_outlined, label: playdate.childAge),
            ],
          ),
        ),
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
        const SizedBox(width: 8),
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
