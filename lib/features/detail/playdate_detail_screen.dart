import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/engagement_row.dart';
import '../../core/widgets/momo_card.dart';
import '../../models/playdate.dart';
import '../../providers/playdate_provider.dart';
import 'playdate_join_action_bar.dart';

class PlaydateDetailScreen extends ConsumerWidget {
  const PlaydateDetailScreen({super.key, required this.playdate});

  /// Initial playdate; live data is read from [playdateProvider] by id.
  final Playdate playdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playdates = ref.watch(playdateProvider).valueOrNull;
    final latest =
        playdates?.where((item) => item.id == playdate.id).firstOrNull ??
            playdate;

    final title = latest.title.trim().isEmpty ? '제목 없음' : latest.title.trim();
    final location =
        latest.location.trim().isEmpty ? '장소 미정' : latest.location.trim();
    final date = latest.date.trim().isEmpty ? '날짜 미정' : latest.date.trim();
    final host =
        latest.hostName.trim().isEmpty ? 'MOMO 엄마' : latest.hostName.trim();
    final hasTime = latest.time.trim().isNotEmpty;
    final hasChildAge = latest.childAge.trim().isNotEmpty;
    final hasDescription = latest.description.trim().isNotEmpty;
    final hostLine = [
      host,
      if (latest.hostChildLabel != null &&
          latest.hostChildLabel!.trim().isNotEmpty)
        latest.hostChildLabel!.trim(),
    ].join(' · ');

    return Scaffold(
      appBar: AppBar(title: const Text('플레이데이트')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.page,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: AppSpacing.chipPadding,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                    child: Text(
                      '플레이데이트',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(title, style: AppTextStyles.headlineMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(hostLine, style: AppTextStyles.bodySmall),
                  const SizedBox(height: AppSpacing.md),
                  EngagementRow(
                    viewCount: latest.viewCount,
                    commentCount: latest.commentCount,
                    likeCount: latest.likeCount,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  MomoCard(
                    padding: AppSpacing.cardDetailPadding,
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.place_outlined,
                          label: '장소',
                          value: location,
                        ),
                        _DetailRow(
                          icon: Icons.calendar_today_outlined,
                          label: '날짜',
                          value: date,
                        ),
                        if (hasTime)
                          _DetailRow(
                            icon: Icons.access_time,
                            label: '시간',
                            value: latest.time.trim(),
                          )
                        else
                          const _DetailRow(
                            icon: Icons.access_time,
                            label: '시간',
                            value: '시간 미정',
                            muted: true,
                          ),
                        if (hasChildAge)
                          _DetailRow(
                            icon: Icons.child_care_outlined,
                            label: '아이 연령',
                            value: latest.childAge.trim(),
                          )
                        else
                          const _DetailRow(
                            icon: Icons.child_care_outlined,
                            label: '아이 연령',
                            value: '미정',
                            muted: true,
                          ),
                        _DetailRow(
                          icon: Icons.groups_outlined,
                          label: '참여',
                          value: latest.participantsLabel,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Text('모임 소개', style: AppTextStyles.subtitle),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    hasDescription ? latest.description.trim() : '소개글이 없습니다.',
                    style: AppTextStyles.body.copyWith(
                      color: hasDescription
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    '댓글·좋아요는 표시만 되며, 아직 상호작용은 지원하지 않아요.',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ),
          PlaydateJoinActionBar(playdate: latest),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.muted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: muted ? AppColors.textSecondary : AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 15,
                    color:
                        muted ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
