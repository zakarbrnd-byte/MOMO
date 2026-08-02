import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/momo_empty_state.dart';
import '../../core/widgets/momo_error.dart';
import '../../core/widgets/momo_loading.dart';
import '../../models/group.dart';
import '../../models/post.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/group_discovery_provider.dart';
import '../../providers/group_provider.dart';
import '../create/create_group_screen.dart';
import '../create/create_post_screen.dart';
import '../detail/post_detail_screen.dart';
import '../groups/group_detail_screen.dart';
import 'discovery/group_discovery_filters.dart';
import 'discovery/group_recommendation.dart';
import 'widgets/group_card.dart';
import 'widgets/group_filter_sheet.dart';
import 'widgets/post_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  var _searchExpanded = false;

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(groupSearchQueryProvider);
    _searchController = TextEditingController(text: initialQuery);
    _searchFocusNode = FocusNode();
    _searchExpanded = initialQuery.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(groupSearchQueryProvider.notifier).state = value;
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(groupSearchQueryProvider.notifier).state = '';
  }

  void _openSearch() {
    setState(() => _searchExpanded = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _closeSearch() {
    _clearSearch();
    _searchFocusNode.unfocus();
    setState(() => _searchExpanded = false);
  }

  String _filterBadgeLabel(int count) {
    if (count >= 3) return '3+';
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    final discoveryAsync = ref.watch(homeDiscoveryProvider);
    final filters = ref.watch(groupDiscoveryFiltersProvider);
    final query = ref.watch(groupSearchQueryProvider);
    final postsAsync = ref.watch(homeCommunityPostsProvider);
    final showSearch = _searchExpanded || query.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: showSearch
            ? IconButton(
                tooltip: '검색 닫기',
                onPressed: _closeSearch,
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        title: showSearch
            ? _SearchField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _onSearchChanged,
                onClear: _clearSearch,
                autofocus: _searchExpanded && query.isEmpty,
              )
            : const Text('MOMO', style: AppTextStyles.brandLogo),
        actions: [
          _HeaderCircleIconButton(
            tooltip: filters.activeCount > 0
                ? '필터 ${filters.activeCount}개 적용됨'
                : '필터',
            onPressed: () => showGroupFilterSheet(context, ref),
            icon: Icons.tune_rounded,
            badgeLabel: filters.activeCount > 0
                ? _filterBadgeLabel(filters.activeCount)
                : null,
          ),
          if (!showSearch)
            _HeaderCircleIconButton(
              tooltip: '검색',
              onPressed: _openSearch,
              icon: Icons.search_rounded,
            ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: discoveryAsync.when(
        loading: () =>
            const MomoLoading(title: 'Loading...', message: 'Please wait.'),
        error: (error, _) => MomoError(
          title: '모임을 불러오지 못했습니다.',
          message: '다시 시도해 주세요.',
          retryLabel: '다시 시도',
          onRetry: () {
            ref.invalidate(groupProvider);
            ref.invalidate(currentUserGroupIdsProvider);
          },
        ),
        data: (discovery) {
          final catalogEmpty =
              (ref.watch(groupProvider).valueOrNull ?? const []).isEmpty;

          return SingleChildScrollView(
            padding: AppSpacing.page,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!showSearch && filters.isEmpty && !catalogEmpty) ...[
                  const _HomeHero(),
                  const SizedBox(height: AppSpacing.xl),
                ],
                if (!filters.isEmpty) ...[
                  _ActiveFilterChips(
                    filters: filters,
                    onClearAll: () {
                      ref.read(groupDiscoveryFiltersProvider.notifier).clear();
                    },
                    onRemoveLocation: (v) => ref
                        .read(groupDiscoveryFiltersProvider.notifier)
                        .removeLocation(v),
                    onRemoveAge: (v) => ref
                        .read(groupDiscoveryFiltersProvider.notifier)
                        .removeAgeRange(v),
                    onRemoveInterest: (v) => ref
                        .read(groupDiscoveryFiltersProvider.notifier)
                        .removeInterest(v),
                    onRemoveCategory: (v) => ref
                        .read(groupDiscoveryFiltersProvider.notifier)
                        .removeCategory(v),
                    onClearMembership: () => ref
                        .read(groupDiscoveryFiltersProvider.notifier)
                        .clearMembership(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (catalogEmpty)
                  MomoEmptyState(
                    title: '아직 등록된 모임이 없습니다.',
                    message: '관심사·나이·지역으로 첫 커뮤니티를 만들어보세요.',
                    buttonText: 'Create Group',
                    onPressed: () {
                      AppNavigation.pushPage(
                        context,
                        const CreateGroupScreen(),
                      );
                    },
                  )
                else if (discovery.isSearchMode)
                  _SearchResultsBody(
                    discovery: discovery,
                    filters: filters,
                    query: query,
                    onClearSearch: _clearSearch,
                    onClearFilters: () {
                      ref.read(groupDiscoveryFiltersProvider.notifier).clear();
                    },
                  )
                else if (discovery.allGroups.isEmpty && !filters.isEmpty)
                  _FilterEmptyBody(
                    onClearFilters: () {
                      ref.read(groupDiscoveryFiltersProvider.notifier).clear();
                    },
                  )
                else ...[
                  ..._browseSections(
                    context,
                    discovery,
                    includeAllGroups: false,
                  ),
                  postsAsync.maybeWhen(
                    data: (posts) {
                      if (posts.isEmpty) {
                        return MomoEmptyState(
                          title: '아직 커뮤니티 게시글이 없습니다.',
                          message: '첫 번째 이야기를 공유해보세요.',
                          buttonText: 'Create Post',
                          onPressed: () {
                            AppNavigation.pushPage(
                              context,
                              const CreatePostScreen(),
                            );
                          },
                        );
                      }
                      return _CommunityPostsSection(posts: posts);
                    },
                    orElse: () => const SizedBox.shrink(),
                  ),
                  ..._browseSections(context, discovery, onlyAllGroups: true),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _browseSections(
    BuildContext context,
    HomeDiscoveryView discovery, {
    bool includeAllGroups = true,
    bool onlyAllGroups = false,
  }) {
    final widgets = <Widget>[];

    void addSection(String title, List<Widget> cards) {
      if (cards.isEmpty) return;
      if (widgets.isNotEmpty) {
        widgets.add(const SizedBox(height: AppSpacing.xl));
      }
      widgets.add(_SectionHeader(title: title));
      widgets.add(const SizedBox(height: AppSpacing.md));
      for (var i = 0; i < cards.length; i++) {
        if (i > 0) {
          widgets.add(const SizedBox(height: AppSpacing.cardListGap));
        }
        widgets.add(cards[i]);
      }
    }

    if (!onlyAllGroups) {
      addSection('✨ 추천 모임', [
        for (final item in discovery.recommended)
          _groupCard(context, item.group, item.visibleReasons),
      ]);
      addSection('내 주변 모임', [
        for (final item in discovery.nearby)
          _groupCard(
            context,
            item.group,
            item.visibleReasons.isNotEmpty
                ? item.visibleReasons
                : const ['같은 지역'],
          ),
      ]);
      addSection('아이 연령이 비슷한 모임', [
        for (final item in discovery.similarAge)
          _groupCard(context, item.group, item.visibleReasons),
      ]);
      addSection('새로운 모임', [
        for (final group in discovery.newest)
          _groupCard(context, group, const []),
      ]);
    }

    if (includeAllGroups || onlyAllGroups) {
      addSection('전체 모임', [
        for (final group in discovery.allGroups)
          _groupCard(context, group, const []),
      ]);
    }

    return widgets;
  }

  Widget _groupCard(BuildContext context, Group group, List<String> reasons) {
    return GroupCard(
      group: group,
      recommendationReasons: reasons,
      variant: GroupCardVariant.discovery,
      onTap: () {
        AppNavigation.pushPage(context, GroupDetailScreen(groupId: group.id));
      },
    );
  }
}

/// Circular light-pink header action button (Filter / Search).
class _HeaderCircleIconButton extends StatelessWidget {
  const _HeaderCircleIconButton({
    required this.tooltip,
    required this.onPressed,
    required this.icon,
    this.badgeLabel,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final IconData icon;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    final button = Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.lightPink,
        shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Semantics(
        button: true,
        label: tooltip,
        child: badgeLabel == null
            ? button
            : Badge(
                label: Text(badgeLabel!),
                backgroundColor: AppColors.primary,
                textColor: AppColors.onPrimary,
                child: button,
              ),
      ),
    );
  }
}

/// Friendly hero under the Home header.
class _HomeHero extends StatelessWidget {
  const _HomeHero();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: '우리 동네 엄마들의 모임을 만나보세요',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.softBlush,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 340;
              const headline = Text(
                '우리 동네 엄마들의\n모임을 만나보세요!',
                style: AppTextStyles.heroTitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              );
              final art = Image.asset(
                'assets/images/hero_moms.png',
                height: narrow ? 88 : 112,
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
                semanticLabel: '엄마들의 모임 일러스트',
              );

              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    headline,
                    const SizedBox(height: AppSpacing.md),
                    Align(alignment: Alignment.centerRight, child: art),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(flex: 5, child: headline),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(flex: 4, child: art),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.focusNode,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool autofocus;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerTick);
  }

  @override
  void didUpdateWidget(covariant _SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerTick);
      widget.controller.addListener(_onControllerTick);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerTick);
    super.dispose();
  }

  void _onControllerTick() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '모임 검색',
      textField: true,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: '모임 이름, 지역, 관심사 검색',
          hintStyle: AppTextStyles.bodySmall,
          border: InputBorder.none,
          isDense: true,
          suffixIcon: widget.controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: '검색어 지우기',
                  onPressed: widget.onClear,
                  icon: const Icon(Icons.clear_rounded),
                ),
        ),
      ),
    );
  }
}

/// Removable active-filter chips only (entry point lives in the AppBar).
class _ActiveFilterChips extends StatelessWidget {
  const _ActiveFilterChips({
    required this.filters,
    required this.onClearAll,
    required this.onRemoveLocation,
    required this.onRemoveAge,
    required this.onRemoveInterest,
    required this.onRemoveCategory,
    required this.onClearMembership,
  });

  final GroupDiscoveryFilters filters;
  final VoidCallback onClearAll;
  final ValueChanged<String> onRemoveLocation;
  final ValueChanged<String> onRemoveAge;
  final ValueChanged<String> onRemoveInterest;
  final ValueChanged<String> onRemoveCategory;
  final VoidCallback onClearMembership;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      for (final location in filters.locations)
        InputChip(
          label: Text(location),
          onDeleted: () => onRemoveLocation(location),
          deleteButtonTooltipMessage: '필터 제거',
        ),
      for (final age in filters.ageRanges)
        InputChip(
          label: Text(age),
          onDeleted: () => onRemoveAge(age),
          deleteButtonTooltipMessage: '필터 제거',
        ),
      for (final interest in filters.interests)
        InputChip(
          label: Text(interest),
          onDeleted: () => onRemoveInterest(interest),
          deleteButtonTooltipMessage: '필터 제거',
        ),
      for (final category in filters.categories)
        InputChip(
          label: Text(category),
          onDeleted: () => onRemoveCategory(category),
          deleteButtonTooltipMessage: '필터 제거',
        ),
      if (filters.membership != GroupMembershipFilter.all)
        InputChip(
          label: Text(
            filters.membership == GroupMembershipFilter.joined ? '가입' : '미가입',
          ),
          onDeleted: onClearMembership,
          deleteButtonTooltipMessage: '필터 제거',
        ),
      ActionChip(label: const Text('전체 초기화'), onPressed: onClearAll),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            chips[i],
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.sectionTitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _SearchResultsBody extends StatelessWidget {
  const _SearchResultsBody({
    required this.discovery,
    required this.filters,
    required this.query,
    required this.onClearSearch,
    required this.onClearFilters,
  });

  final HomeDiscoveryView discovery;
  final GroupDiscoveryFilters filters;
  final String query;
  final VoidCallback onClearSearch;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    if (discovery.resultCount == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('검색 결과가 없습니다.', style: AppTextStyles.cardTitle),
          const SizedBox(height: AppSpacing.sm),
          const Text('다른 검색어나 필터를 사용해보세요.', style: AppTextStyles.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          if (query.trim().isNotEmpty)
            OutlinedButton(
              onPressed: onClearSearch,
              child: const Text('검색어 지우기'),
            ),
          if (!filters.isEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: onClearFilters,
              child: const Text('필터 초기화'),
            ),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '검색 결과 ${discovery.resultCount}개',
          style: AppTextStyles.sectionTitle,
        ),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < discovery.filteredGroups.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.cardListGap),
          GroupCard(
            group: discovery.filteredGroups[i],
            variant: GroupCardVariant.discovery,
            onTap: () {
              AppNavigation.pushPage(
                context,
                GroupDetailScreen(groupId: discovery.filteredGroups[i].id),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _FilterEmptyBody extends StatelessWidget {
  const _FilterEmptyBody({required this.onClearFilters});

  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('조건에 맞는 모임이 없습니다.', style: AppTextStyles.cardTitle),
        const SizedBox(height: AppSpacing.sm),
        const Text('필터를 조정해보세요.', style: AppTextStyles.bodySmall),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton(onPressed: onClearFilters, child: const Text('필터 초기화')),
      ],
    );
  }
}

class _CommunityPostsSection extends StatelessWidget {
  const _CommunityPostsSection({required this.posts});

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        const _SectionHeader(title: '커뮤니티 이야기'),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < posts.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.cardListGap),
          PostCard(
            post: posts[i],
            onTap: () {
              AppNavigation.pushPage(context, PostDetailScreen(post: posts[i]));
            },
          ),
        ],
      ],
    );
  }
}
