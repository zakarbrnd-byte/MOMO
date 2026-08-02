import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

/// Centralized MOMO text styles using the bundled [AppFonts.family].
///
/// Prefer these tokens (or [ThemeData.textTheme] built from them) over
/// inline `TextStyle(fontSize: …)`.
abstract final class AppTextStyles {
  static const String _fontFamily = AppFonts.family;
  static const List<String> _fontFamilyFallback = AppFonts.fallback;

  /// Playful brand wordmark (Home AppBar "MOMO").
  static const TextStyle brandLogo = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    letterSpacing: 1.2,
    height: 1.1,
  );

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1,
    height: 1.2,
  );

  /// Hero headline under the Home header.
  static const TextStyle heroTitle = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
    height: 1.25,
  );

  /// Large screen / AppBar title (non-brand).
  static const TextStyle headline = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.25,
  );

  /// Energetic section headers (e.g. ✨ 추천 모임).
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle title = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  /// Shared Home feed card title (Group / Post / Playdate).
  static const TextStyle cardTitle = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Primary reading text.
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  /// Emphasized body (15 / medium).
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  /// Secondary / meta copy.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Card metadata (location, ages, members).
  static const TextStyle metadata = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.35,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Material [TextTheme] used by [AppTheme].
  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: displayLarge,
      headlineLarge: headline,
      headlineMedium: headlineMedium,
      titleLarge: title,
      titleMedium: subtitle,
      bodyLarge: body,
      bodyMedium: bodySmall,
      labelLarge: button,
      labelMedium: caption,
      bodySmall: caption,
    );
  }
}
