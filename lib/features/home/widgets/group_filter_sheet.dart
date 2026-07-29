import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../features/home/discovery/group_discovery_filters.dart';
import '../../../features/home/discovery/group_discovery_service.dart';
import '../../../models/group.dart';
import '../../../providers/group_discovery_provider.dart';
import '../../../providers/group_provider.dart';

/// Filter bottom sheet with draft state; applies only on "결과 보기".
Future<void> showGroupFilterSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return const _GroupFilterSheet();
    },
  );
}

class _GroupFilterSheet extends ConsumerStatefulWidget {
  const _GroupFilterSheet();

  @override
  ConsumerState<_GroupFilterSheet> createState() => _GroupFilterSheetState();
}

class _GroupFilterSheetState extends ConsumerState<_GroupFilterSheet> {
  late GroupDiscoveryFilters _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(groupDiscoveryFiltersProvider);
  }

  int _draftResultCount(List<Group> groups, Set<String> joined) {
    return GroupDiscoveryService.applySearchAndFilters(
      groups: groups,
      query: ref.read(groupSearchQueryProvider),
      filters: _draft,
      joinedGroupIds: joined,
    ).length;
  }

  @override
  Widget build(BuildContext context) {
    final optionsAsync = ref.watch(groupFilterOptionsProvider);
    final groups = ref.watch(groupProvider).valueOrNull ?? const [];
    final joined =
        ref.watch(currentUserGroupIdsProvider).valueOrNull ?? const {};
    final resultCount = _draftResultCount(groups, joined);

    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.88;

    return SizedBox(
      height: maxHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.xl,
              AppSpacing.md,
            ),
            child: Text('모임 필터', style: AppTextStyles.title),
          ),
          Expanded(
            child: optionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: AppSpacing.allXl,
                  child: Text(
                    '필터 옵션을 불러오지 못했습니다.',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (options) => ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  0,
                  AppSpacing.xl,
                  AppSpacing.xl,
                ),
                children: [
                  _FilterSection(
                    title: '지역',
                    child: _MultiSelectChips(
                      options: options.locations,
                      selected: _draft.locations,
                      onToggle: (value) {
                        setState(() {
                          final next = {..._draft.locations};
                          if (next.contains(value)) {
                            next.remove(value);
                          } else {
                            next.add(value);
                          }
                          _draft = _draft.copyWith(locations: next);
                        });
                      },
                    ),
                  ),
                  _FilterSection(
                    title: '아이 연령',
                    child: _MultiSelectChips(
                      options: options.ageRanges,
                      selected: _draft.ageRanges,
                      onToggle: (value) {
                        setState(() {
                          final next = {..._draft.ageRanges};
                          if (next.contains(value)) {
                            next.remove(value);
                          } else {
                            next.add(value);
                          }
                          _draft = _draft.copyWith(ageRanges: next);
                        });
                      },
                    ),
                  ),
                  _FilterSection(
                    title: '관심사',
                    child: _MultiSelectChips(
                      options: options.interests,
                      selected: _draft.interests,
                      onToggle: (value) {
                        setState(() {
                          final next = {..._draft.interests};
                          if (next.contains(value)) {
                            next.remove(value);
                          } else {
                            next.add(value);
                          }
                          _draft = _draft.copyWith(interests: next);
                        });
                      },
                    ),
                  ),
                  _FilterSection(
                    title: '카테고리',
                    child: _MultiSelectChips(
                      options: options.categories,
                      selected: _draft.categories,
                      onToggle: (value) {
                        setState(() {
                          final next = {..._draft.categories};
                          if (next.contains(value)) {
                            next.remove(value);
                          } else {
                            next.add(value);
                          }
                          _draft = _draft.copyWith(categories: next);
                        });
                      },
                    ),
                  ),
                  _FilterSection(
                    title: '가입 상태',
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final option in GroupMembershipFilter.values)
                          FilterChip(
                            label: Text(_membershipLabel(option)),
                            selected: _draft.membership == option,
                            showCheckmark: true,
                            onSelected: (_) {
                              setState(() {
                                _draft = _draft.copyWith(membership: option);
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _draft = GroupDiscoveryFilters.empty;
                        });
                      },
                      child: const Text('초기화'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: () {
                        ref
                            .read(groupDiscoveryFiltersProvider.notifier)
                            .setFilters(_draft);
                        Navigator.of(context).pop();
                      },
                      child: Text('결과 보기 ($resultCount)'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _membershipLabel(GroupMembershipFilter value) {
    return switch (value) {
      GroupMembershipFilter.all => '전체',
      GroupMembershipFilter.joined => '가입',
      GroupMembershipFilter.notJoined => '미가입',
    };
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _MultiSelectChips extends StatelessWidget {
  const _MultiSelectChips({
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return Text(
        '선택 가능한 옵션이 없습니다.',
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      );
    }

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final option in options)
          FilterChip(
            label: Text(option),
            selected: selected.contains(option),
            showCheckmark: true,
            onSelected: (_) => onToggle(option),
          ),
      ],
    );
  }
}
