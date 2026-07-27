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
      appBar: AppBar(title: const Text('만들기')),
      body: Padding(
        padding: AppSpacing.pageCreate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '무엇을 공유할까요?',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '플레이데이트로 만나거나, 육아톡에 질문을 남겨보세요.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: _ActionCard(
                icon: Icons.event_available_outlined,
                title: '플레이데이트 만들기',
                subtitle: '우리 동네 엄마들과 오프라인으로 만나요',
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
                title: '글 작성하기',
                subtitle: '육아 질문이나 동네 정보를 나눠요',
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
          Text(title,
              style: textTheme.headlineMedium, textAlign: TextAlign.center),
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
