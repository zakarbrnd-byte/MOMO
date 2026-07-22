import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/momo_card.dart';
import '../../navigation/app_navigation.dart';
import 'create_playdate_screen.dart';
import 'create_post_screen.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Create')),
      body: Padding(
        padding: AppSpacing.pageCreate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What would you like to share?',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You can create two types of content for the community.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: _ActionCard(
                icon: Icons.event_available_outlined,
                title: 'Create Playdate',
                subtitle: 'Invite moms to meet offline',
                onTap: () {
                  AppNavigation.pushPage(
                    context,
                    const CreatePlaydateScreen(),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: _ActionCard(
                icon: Icons.edit_note_outlined,
                title: 'Create Post',
                subtitle: 'Ask a question or share an idea',
                onTap: () {
                  AppNavigation.pushPage(
                    context,
                    const CreatePostScreen(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MomoCard(
      onTap: onTap,
      padding: AppSpacing.allXl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, size: 32, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(title, style: textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
