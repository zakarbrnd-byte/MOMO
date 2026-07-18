import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'create_playdate_screen.dart';
import 'create_post_screen.dart';

/// Choose Playdate or Post — Create tab root.
class CreateSelectionScreen extends StatelessWidget {
  const CreateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create')),
      body: ListView(
        padding: AppSpacing.screenInsets,
        children: [
          const Text(
            'What would you like to share?',
            style: AppTypography.bodySecondary,
          ),
          const SizedBox(height: AppSpacing.lg),
          _CreateChoiceCard(
            title: 'Playdate',
            subtitle: 'Invite moms to meet offline',
            icon: Icons.child_care_outlined,
            emphasized: true,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CreatePlaydateScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.cardGap),
          _CreateChoiceCard(
            title: 'Post',
            subtitle: 'Ask a question or share a note',
            icon: Icons.chat_bubble_outline_rounded,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CreatePostScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CreateChoiceCard extends StatelessWidget {
  const _CreateChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.emphasized = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final tint = emphasized ? AppColors.primarySoft : AppColors.surfaceMuted;
    final iconColor =
        emphasized ? AppColors.primaryDark : AppColors.textSecondary;

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardInsets,
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text(subtitle, style: AppTypography.bodySecondary),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.navInactive),
            ],
          ),
        ),
      ),
    );
  }
}
