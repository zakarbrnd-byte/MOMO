import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/feed_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Home feed filter: 전체 · 플레이데이트 · 육아톡
class FeedFilterTabs extends ConsumerWidget {
  const FeedFilterTabs({super.key});

  static const _labels = <HomeFeedFilter, String>{
    HomeFeedFilter.all: '전체',
    HomeFeedFilter.playdates: '플레이데이트',
    HomeFeedFilter.posts: '육아톡',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(homeFeedFilterProvider);

    return Semantics(
      label: '피드 필터',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final entry in _labels.entries) ...[
              if (entry.key != HomeFeedFilter.all)
                const SizedBox(width: AppSpacing.sm),
              _Chip(
                key: ValueKey('feed_filter_${entry.key.name}'),
                label: entry.value,
                selected: selected == entry.key,
                onTap: () {
                  ref.read(homeFeedFilterProvider.notifier).state = entry.key;
                  // Clear category when leaving posts-focused filters.
                  if (entry.key == HomeFeedFilter.playdates) {
                    ref.read(homeCategoryFilterProvider.notifier).state = null;
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.button.copyWith(
              color: selected ? AppColors.onPrimary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
