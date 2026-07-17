import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Quiet type label shared by Playdate and Post cards.
class CardTypeLabel extends StatelessWidget {
  const CardTypeLabel({
    super.key,
    required this.label,
    this.emphasized = false,
  });

  final String label;

  /// Playdate uses a soft coral tint; Post stays muted.
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final background =
        emphasized ? AppColors.primarySoft : AppColors.surfaceMuted;
    final foreground =
        emphasized ? AppColors.primaryDark : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Icon + text meta row used inside cards.
class CardMetaRow extends StatelessWidget {
  const CardMetaRow({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySecondary,
          ),
        ),
      ],
    );
  }
}

/// Author / host footer shared by both card types.
class CardAuthorRow extends StatelessWidget {
  const CardAuthorRow({
    super.key,
    required this.name,
    this.neighborhood,
  });

  final String name;
  final String? neighborhood;

  @override
  Widget build(BuildContext context) {
    final subtitle = neighborhood;
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primarySoft,
          child: Text(
            _initials(name),
            style: AppTypography.caption.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            subtitle == null || subtitle.isEmpty ? name : '$name · $subtitle',
            style: AppTypography.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
