import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/playdate.dart';

class PlaydateDetailScreen extends StatelessWidget {
  const PlaydateDetailScreen({super.key, required this.playdate});

  final Playdate playdate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Playdate')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(playdate.title, style: textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Hosted by ${playdate.hostName}',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _DetailRow(icon: Icons.calendar_today_outlined, label: 'Date', value: playdate.date),
          _DetailRow(icon: Icons.access_time, label: 'Time', value: playdate.time),
          _DetailRow(icon: Icons.place_outlined, label: 'Location', value: playdate.location),
          _DetailRow(icon: Icons.child_care_outlined, label: 'Child age', value: playdate.childAge),
          const SizedBox(height: 8),
          Text('Description', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(playdate.description, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
