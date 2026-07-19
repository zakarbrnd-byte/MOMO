import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What would you like to share?',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'You can create two types of content for the community.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 16),
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

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, size: 32, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text(title, style: textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
