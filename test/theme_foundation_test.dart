import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/core/theme/app_colors.dart';
import 'package:momo/core/theme/app_fonts.dart';
import 'package:momo/core/theme/app_spacing.dart';
import 'package:momo/core/theme/app_text_styles.dart';
import 'package:momo/core/theme/app_theme.dart';

void main() {
  test('AppTheme.light uses design tokens', () {
    final theme = AppTheme.light;

    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.colorScheme.secondary, AppColors.secondary);
    expect(theme.colorScheme.error, AppColors.error);
    expect(theme.textTheme.bodyLarge?.fontFamily, AppFonts.family);
    expect(theme.textTheme.headlineLarge?.fontFamily, AppFonts.family);
    expect(theme.textTheme.labelLarge?.fontFamily, AppFonts.family);
    expect(theme.appBarTheme.titleTextStyle?.fontFamily, AppFonts.family);
    expect(
      theme.textTheme.headlineLarge?.fontSize,
      AppTextStyles.headline.fontSize,
    );
    expect(
      theme.textTheme.headlineLarge?.fontWeight,
      AppTextStyles.headline.fontWeight,
    );
    expect(theme.textTheme.bodyLarge?.fontSize, AppTextStyles.body.fontSize);
    expect(theme.inputDecorationTheme.fillColor, AppColors.surface);
    expect(theme.cardTheme.color, AppColors.card);
    expect(
      theme.appBarTheme.titleTextStyle?.fontSize,
      AppTextStyles.brandLogo.fontSize,
    );
    expect(theme.navigationBarTheme.indicatorColor, AppColors.lightPink);
  });

  test('AppTextStyles use bundled Pretendard family', () {
    expect(AppFonts.family, 'Pretendard');
    expect(AppTextStyles.body.fontFamily, AppFonts.family);
    expect(AppTextStyles.cardTitle.fontFamily, AppFonts.family);
    expect(AppTextStyles.brandLogo.fontFamily, AppFonts.family);
    expect(AppTextStyles.heroTitle.fontFamily, AppFonts.family);
    expect(AppTextStyles.sectionTitle.fontFamily, AppFonts.family);
    expect(AppTextStyles.caption.fontFamilyFallback, AppFonts.fallback);
  });

  test('AppColors expose modern friendly pink palette', () {
    expect(AppColors.primary, const Color(0xFFFF4D6D));
    expect(AppColors.lightPink, const Color(0xFFFFE7EA));
    expect(AppColors.softBlush, const Color(0xFFFFF3F4));
    expect(AppColors.heroBanner, const Color(0xFFFFF1F4));
    expect(AppColors.background, const Color(0xFFFFF9F7));
    expect(AppColors.card, const Color(0xFFFFFFFF));
    expect(AppColors.border, const Color(0xFFF1E5E3));
    expect(AppColors.textPrimary, const Color(0xFF1A1A1A));
    expect(AppColors.textSecondary, const Color(0xFF6B7280));
    expect(AppColors.primarySoft, AppColors.lightPink);
  });

  test('AppTextStyles exposes expected scale', () {
    expect(AppTextStyles.brandLogo.fontSize, 40);
    expect(AppTextStyles.brandLogo.fontWeight, FontWeight.w800);
    expect(AppTextStyles.displayLarge.fontSize, 40);
    expect(AppTextStyles.heroTitle.fontSize, 26);
    expect(AppTextStyles.heroTitle.fontWeight, FontWeight.w700);
    expect(AppTextStyles.headline.fontSize, 30);
    expect(AppTextStyles.sectionTitle.fontSize, 24);
    expect(AppTextStyles.title.fontSize, 24);
    expect(AppTextStyles.subtitle.fontSize, 16);
    expect(AppTextStyles.cardTitle.fontSize, 22);
    expect(AppTextStyles.cardTitle.fontWeight, FontWeight.w700);
    expect(AppTextStyles.body.fontSize, 15);
    expect(AppTextStyles.bodyMedium.fontWeight, FontWeight.w500);
    expect(AppTextStyles.bodySmall.fontSize, 14);
    expect(AppTextStyles.metadata.fontSize, 13);
    expect(AppTextStyles.caption.fontSize, 13);
    expect(AppTextStyles.button.fontWeight, FontWeight.w600);
  });

  test('AppSpacing exposes scale and card helpers', () {
    expect(AppSpacing.xs, 4);
    expect(AppSpacing.sm, 8);
    expect(AppSpacing.md, 12);
    expect(AppSpacing.lg, 16);
    expect(AppSpacing.xl, 24);
    expect(AppSpacing.xxl, 32);
    expect(AppSpacing.xxxl, 48);
    expect(AppSpacing.cardPadding, const EdgeInsets.all(24));
    expect(AppSpacing.cardTitleGap, AppSpacing.md);
    expect(AppSpacing.cardContentGap, AppSpacing.sm);
    expect(AppSpacing.cardRadius, 20);
    expect(AppSpacing.cardListGap, AppSpacing.lg);
    expect(AppSpacing.formFieldGap, AppSpacing.lg);
    expect(AppSpacing.formSubmitGap, AppSpacing.xl);
  });
}
