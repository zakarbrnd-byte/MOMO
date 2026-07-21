import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/core/theme/app_colors.dart';
import 'package:momo/core/theme/app_text_styles.dart';
import 'package:momo/core/theme/app_theme.dart';

void main() {
  test('AppTheme.light uses design tokens', () {
    final theme = AppTheme.light;

    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.colorScheme.secondary, AppColors.secondary);
    expect(theme.colorScheme.error, AppColors.error);
    expect(theme.textTheme.headlineLarge?.fontSize, AppTextStyles.headline.fontSize);
    expect(theme.textTheme.headlineLarge?.fontWeight, AppTextStyles.headline.fontWeight);
    expect(theme.textTheme.bodyLarge?.fontSize, AppTextStyles.body.fontSize);
    expect(theme.inputDecorationTheme.fillColor, AppColors.surface);
    expect(theme.cardTheme.color, AppColors.card);
  });

  test('AppTextStyles exposes expected scale', () {
    expect(AppTextStyles.displayLarge.fontSize, 36);
    expect(AppTextStyles.headline.fontSize, 28);
    expect(AppTextStyles.title.fontSize, 20);
    expect(AppTextStyles.subtitle.fontSize, 16);
    expect(AppTextStyles.body.fontSize, 16);
    expect(AppTextStyles.bodyMedium.fontWeight, FontWeight.w500);
    expect(AppTextStyles.bodySmall.fontSize, 14);
    expect(AppTextStyles.caption.fontSize, 12);
    expect(AppTextStyles.button.fontWeight, FontWeight.w600);
  });
}
