import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/category_discovery_row.dart';
import '../../core/widgets/feed_filter_tabs.dart';
import '../../core/widgets/momo_empty_state.dart';
import '../../core/widgets/momo_error.dart';
import '../../core/widgets/momo_loading.dart';
import '../../core/widgets/playdate_hero_cta.dart';
import '../../core/widgets/section_header.dart';
import '../../models/feed_item.dart';
import '../../models/playdate.dart';
import '../../models/post.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/feed_provider.dart';
import '../../providers/playdate_provider.dart';
import '../../providers/post_provider.dart';
import '../create/create_playdate_screen.dart';
import '../create/create_post_screen.dart';
import '../detail/playdate_detail_screen.dart';
import '../detail/post_detail_screen.dart';
import 'widgets/playdate_card.dart';
import 'widgets/post_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(homeFeedFilterProvider);
    final feedAsync = ref.watch(homeFilteredFeedProvider);
    final upcomingAsync = ref.watch(upcomingPlaydatesProvider);
    final popularAsync = ref.watch(popularPostsProvider);
    final recentAsync = ref.watch(recentPostsProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.lg,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MOMO',
              style: AppTextStyles.title.copyWith(fontSize: 22),
            ),
            const Text(
              '우리 동네 엄마들과 같이 키워요',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: '검색',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('검색은 곧 제공될 예정이에요')),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: '알림',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('알림은 곧 제공될 예정이에요')),
              );
            },
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: feedAsync.when(
        loading: () => const MomoLoading(
          title: '불러오는 중...',
          message: '잠시만 기다려 주세요.',
        ),
        error: (error, _) => MomoError(
          title: '문제가 발생했어요',
          message: error.toString(),
          onRetry: () {
            ref.invalidate(playdateProvider);
            ref.invalidate(postProvider);
          },
        ),
        data: (feedItems) {
          return ListView(
            padding: AppSpacing.page,
            children: [
              const FeedFilterTabs(),
              const SizedBox(height: AppSpacing.lg),
              PlaydateHeroCta(
                onCreate: () {
                  AppNavigation.pushPage(
                    context,
                    const CreatePlaydateScreen(),
                  );
                },
              ),
              if (filter == HomeFeedFilter.all ||
                  filter == HomeFeedFilter.playdates) ...[
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(
                  title: '이번 주 가까운 플레이데이트',
                  subtitle: '우리 동네에서 바로 만날 수 있어요',
                ),
                ..._upcomingPlaydateCards(
                  context,
                  upcomingAsync,
                  onEmptyCreate: () {
                    AppNavigation.pushPage(
                      context,
                      const CreatePlaydateScreen(),
                    );
                  },
                ),
              ],
              if (filter == HomeFeedFilter.all) ...[
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(title: '오늘 많이 보는 글'),
                _PostListSection(
                  asyncPosts: popularAsync,
                  emptyTitle: '아직 게시글이 없습니다.',
                  emptyMessage: '첫 번째 이야기를 공유해보세요.',
                  emptyButton: '글 작성하기',
                  onEmptyPressed: () {
                    AppNavigation.pushPage(
                      context,
                      const CreatePostScreen(),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(title: '새로 올라온 글'),
                _PostListSection(asyncPosts: recentAsync),
                const SizedBox(height: AppSpacing.xl),
                const CategoryDiscoveryRow(),
                const SizedBox(height: AppSpacing.xxl),
              ] else ...[
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(
                  title:
                      filter == HomeFeedFilter.playdates ? '모든 플레이데이트' : '육아톡',
                ),
                if (feedItems.isEmpty)
                  MomoEmptyState(
                    title: filter == HomeFeedFilter.playdates
                        ? '아직 등록된 플레이데이트가 없습니다.'
                        : '아직 게시글이 없습니다.',
                    message: filter == HomeFeedFilter.playdates
                        ? '첫 번째 모임을 만들어보세요.'
                        : '첫 번째 이야기를 공유해보세요.',
                    buttonText: filter == HomeFeedFilter.playdates
                        ? '플레이데이트 만들기'
                        : '글 작성하기',
                    onPressed: () {
                      AppNavigation.pushPage(
                        context,
                        filter == HomeFeedFilter.playdates
                            ? const CreatePlaydateScreen()
                            : const CreatePostScreen(),
                      );
                    },
                  )
                else
                  for (var i = 0; i < feedItems.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.cardListGap),
                    _FeedCard(item: feedItems[i]),
                  ],
                const SizedBox(height: AppSpacing.xxl),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _UpcomingPlaydates {
  /// Expands upcoming playdates into individual list children so ListView
  /// lazily builds later Home sections (popular / recent) correctly.
  static List<Widget> cards(
    BuildContext context,
    AsyncValue<List<Playdate>> asyncPlaydates, {
    required VoidCallback onEmptyCreate,
  }) {
    return asyncPlaydates.when(
      loading: () => const [
        SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
      error: (error, _) => [
        Text(
          error.toString(),
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
        ),
      ],
      data: (playdates) {
        if (playdates.isEmpty) {
          return [
            MomoEmptyState(
              title: '아직 등록된 플레이데이트가 없습니다.',
              message: '첫 번째 모임을 만들어보세요.',
              buttonText: '플레이데이트 만들기',
              onPressed: onEmptyCreate,
            ),
          ];
        }

        return [
          for (var i = 0; i < playdates.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.cardListGap),
            PlaydateCard(
              playdate: playdates[i],
              compact: true,
              onTap: () {
                AppNavigation.pushPage(
                  context,
                  PlaydateDetailScreen(playdate: playdates[i]),
                );
              },
            ),
          ],
        ];
      },
    );
  }
}

List<Widget> _upcomingPlaydateCards(
  BuildContext context,
  AsyncValue<List<Playdate>> asyncPlaydates, {
  required VoidCallback onEmptyCreate,
}) {
  return _UpcomingPlaydates.cards(
    context,
    asyncPlaydates,
    onEmptyCreate: onEmptyCreate,
  );
}

class _PostListSection extends StatelessWidget {
  const _PostListSection({
    required this.asyncPosts,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyButton,
    this.onEmptyPressed,
  });

  final AsyncValue<List<Post>> asyncPosts;
  final String? emptyTitle;
  final String? emptyMessage;
  final String? emptyButton;
  final VoidCallback? onEmptyPressed;

  @override
  Widget build(BuildContext context) {
    return asyncPosts.when(
      loading: () => const SizedBox(height: 80),
      error: (_, __) => const SizedBox.shrink(),
      data: (posts) {
        if (posts.isEmpty) {
          if (emptyTitle == null || onEmptyPressed == null) {
            return const SizedBox.shrink();
          }
          return MomoEmptyState(
            title: emptyTitle!,
            message: emptyMessage ?? '',
            buttonText: emptyButton,
            onPressed: onEmptyPressed,
          );
        }
        return Column(
          children: [
            for (var i = 0; i < posts.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.cardListGap),
              PostCard(
                post: posts[i],
                onTap: () {
                  AppNavigation.pushPage(
                    context,
                    PostDetailScreen(post: posts[i]),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({required this.item});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return switch (item) {
      PlaydateFeedItem(:final playdate) => PlaydateCard(
          playdate: playdate,
          onTap: () {
            AppNavigation.pushPage(
              context,
              PlaydateDetailScreen(playdate: playdate),
            );
          },
        ),
      PostFeedItem(:final post) => PostCard(
          post: post,
          onTap: () {
            AppNavigation.pushPage(
              context,
              PostDetailScreen(post: post),
            );
          },
        ),
    };
  }
}
