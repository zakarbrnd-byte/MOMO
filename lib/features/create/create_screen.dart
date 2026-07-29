import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/momo_card.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/group_provider.dart';
import 'create_group_screen.dart';
import 'create_post_screen.dart';

class CreateScreen extends ConsumerWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final joinedIds = ref.watch(currentUserGroupIdsProvider);
    final hasJoinedGroup = joinedIds.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Create')),
      body: ListView(
        padding: AppSpacing.pageCreate,
        children: [
          Text(
            'What would you like to share?',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Groups are communities. Event Announcements are created inside a Group.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          _ActionCard(
            icon: Icons.groups_outlined,
            title: 'Create Group',
            subtitle: 'Start a community around interest, age, or location',
            onTap: () {
              AppNavigation.pushPage(
                context,
                const CreateGroupScreen(),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          _ActionCard(
            icon: Icons.edit_note_outlined,
            title: 'Create Post',
            subtitle: 'Ask a question or share with the community',
            onTap: () {
              AppNavigation.pushPage(
                context,
                const CreatePostScreen(),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          if (hasJoinedGroup)
            Text(
              'Event Announcements: open a joined Group → Info → 이벤트 만들기.',
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            )
          else
            _EventMembershipGate(
              onBrowseGroups: () {
                AppNavigation.selectTab(ref, MainTabs.home);
              },
            ),
        ],
      ),
    );
  }
}

class _EventMembershipGate extends StatelessWidget {
  const _EventMembershipGate({required this.onBrowseGroups});

  final VoidCallback onBrowseGroups;

  @override
  Widget build(BuildContext context) {
    return MomoCard(
      padding: AppSpacing.allLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '이벤트 공지를 만들려면 먼저 모임에 가입해야 합니다.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Home에서 관심 있는 모임을 찾아 가입한 뒤, 모임 상세에서 일정을 만들어보세요.',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: onBrowseGroups,
            child: const Text('모임 찾아보기'),
          ),
        ],
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
        mainAxisSize: MainAxisSize.min,
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
