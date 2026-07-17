import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Rounded, quiet card chrome — "Everything is a Card."
abstract final class AppCardStyle {
  static const double radius = 20;
  static const double borderWidth = 1;

  static BorderRadius get borderRadius => BorderRadius.circular(radius);

  static const EdgeInsets padding = AppSpacing.cardInsets;

  static const BoxBorder border = Border.fromBorderSide(
    BorderSide(color: AppColors.border, width: borderWidth),
  );

  static ShapeBorder get shape => RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: const BorderSide(color: AppColors.border, width: borderWidth),
      );

  static BoxDecoration get decoration => BoxDecoration(
        color: AppColors.surface,
        borderRadius: borderRadius,
        border: border,
      );

  static CardThemeData get theme => CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: shape,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      );
}
