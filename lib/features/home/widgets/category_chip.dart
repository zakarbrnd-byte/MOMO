import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/post_category.dart';

/// Compact Post category chip using [PostCategory.labelKo].
///
/// Display-only — no filter/tap behavior unless [onTap] is provided later.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    this.onTap,
  });

  final PostCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = category.labelKo;

    final chip = Container(
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    return Semantics(
      label: '카테고리 $label',
      button: onTap != null,
      excludeSemantics: true,
      child: onTap == null
          ? chip
          : InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              child: chip,
            ),
    );
  }
}
