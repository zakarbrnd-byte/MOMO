import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/momo_empty_state.dart';
import '../../core/widgets/momo_error.dart';
import '../../core/widgets/momo_loading.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/group_provider.dart';
import '../home/widgets/group_card.dart';
import 'group_detail_screen.dart';

/// Personal library of Groups the current user has joined.
class MyGroupsScreen extends ConsumerWidget {
  const MyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupProvider);
    final joinedAsync = ref.watch(currentUserGroupIdsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('내 모임')),
      body: groupsAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        loading: () => const MomoLoading(
          title: 'Loading...',
          message: 'Please wait.',
        ),
        error: (error, _) => MomoError(
          title: 'Something went wrong',
          message: '모임을 불러오지 못했습니다.',
          onRetry: () => ref.invalidate(groupProvider),
        ),
        data: (groups) {
          return joinedAsync.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            loading: () => const MomoLoading(
              title: 'Loading...',
              message: 'Please wait.',
            ),
            error: (error, _) => MomoError(
              title: 'Something went wrong',
              message: '가입한 모임을 불러오지 못했습니다.',
              onRetry: () => ref.invalidate(currentUserGroupIdsProvider),
            ),
            data: (joinedIds) {
              final joined = groups
                  .where((group) => joinedIds.contains(group.id))
                  .toList(growable: false);

              if (joined.isEmpty) {
                return ListView(
                  padding: AppSpacing.page,
                  children: [
                    MomoEmptyState(
                      title: '아직 가입한 모임이 없습니다.',
                      message: '관심 있는 모임을 Home에서 찾아보세요.',
                      buttonText: '모임 찾아보기',
                      onPressed: () {
                        AppNavigation.selectTab(ref, MainTabs.home);
                      },
                    ),
                  ],
                );
              }

              return ListView.separated(
                padding: AppSpacing.page,
                itemCount: joined.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.cardListGap),
                itemBuilder: (context, index) {
                  final group = joined[index];
                  return GroupCard(
                    group: group,
                    variant: GroupCardVariant.myGroups,
                    onTap: () {
                      AppNavigation.pushPage(
                        context,
                        GroupDetailScreen(groupId: group.id),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
