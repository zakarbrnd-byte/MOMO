import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Shared card shell for MOMO surfaces.
///
/// Feed cards, detail panels, and profile sections should use this instead of
/// raw [Card] widgets. Optional [leading] / [footer] slots stay empty for now
/// but are ready for badges or action rows later.
class MomoCard extends StatelessWidget {
  const MomoCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.showBorder = true,
    this.borderColor,
    this.leading,
    this.footer,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? elevation;
  final bool showBorder;
  final Color? borderColor;

  /// Optional top slot (e.g. future image header / badge row).
  final Widget? leading;

  /// Optional bottom slot (e.g. future action row).
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppSpacing.cardRadius;
    final bodyPadding = padding ?? AppSpacing.cardPadding;

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(height: AppSpacing.cardTitleGap),
        ],
        child,
        if (footer != null) ...[
          const SizedBox(height: AppSpacing.cardFooterGap),
          footer!,
        ],
      ],
    );

    final content = Padding(
      padding: bodyPadding,
      child: column,
    );

    return Card(
      margin: margin ?? EdgeInsets.zero,
      color: backgroundColor ?? AppColors.card,
      elevation: elevation ?? 0,
      shadowColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: showBorder
            ? BorderSide(color: borderColor ?? AppColors.border)
            : BorderSide.none,
      ),
      child: onTap == null
          ? content
          : InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(radius),
              child: content,
            ),
    );
  }
}
