import 'package:flutter/material.dart';

import '../../../core/theme/app_card_style.dart';
import '../../../core/theme/app_colors.dart';

/// Shared card shell — every feed item is a [BaseCard].
///
/// Applies MOMO card chrome (rounded, bordered, flat) so Playdate and Post
/// cards share one design language.
class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = AppCardStyle.padding,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding,
      child: child,
    );

    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      child: Material(
        color: AppColors.surface,
        shape: AppCardStyle.shape,
        clipBehavior: Clip.antiAlias,
        child: onTap == null
            ? content
            : InkWell(
                onTap: onTap,
                customBorder: AppCardStyle.shape,
                splashColor: AppColors.primarySoft.withValues(alpha: 0.5),
                highlightColor: AppColors.primarySoft.withValues(alpha: 0.3),
                child: content,
              ),
      ),
    );
  }
}
