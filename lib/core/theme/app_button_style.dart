import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Soft, rounded button styles — large tap targets, minimal chrome.
abstract final class AppButtonStyle {
  static const double radius = 16;
  static const double minHeight = AppSpacing.tapTarget;

  static BorderRadius get borderRadius => BorderRadius.circular(radius);

  static Size get minimumSize => const Size(64, minHeight);

  static EdgeInsetsGeometry get padding => const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      );

  static RoundedRectangleBorder get shape =>
      RoundedRectangleBorder(borderRadius: borderRadius);

  /// Primary CTA — coral fill, white label.
  static ButtonStyle get primary => ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.primarySoft;
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primaryDark;
          }
          return AppColors.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.textTertiary;
          }
          return AppColors.onPrimary;
        }),
        textStyle: const WidgetStatePropertyAll(AppTypography.button),
        minimumSize: WidgetStatePropertyAll(minimumSize),
        padding: WidgetStatePropertyAll(padding),
        shape: WidgetStatePropertyAll(shape),
      );

  /// Secondary — outlined on warm surface.
  static ButtonStyle get secondary => ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: const WidgetStatePropertyAll(AppColors.surface),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.textTertiary;
          }
          return AppColors.primary;
        }),
        textStyle: WidgetStatePropertyAll(
          AppTypography.button.copyWith(color: AppColors.primary),
        ),
        minimumSize: WidgetStatePropertyAll(minimumSize),
        padding: WidgetStatePropertyAll(padding),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const BorderSide(color: AppColors.border);
          }
          return const BorderSide(color: AppColors.primary, width: 1.5);
        }),
        shape: WidgetStatePropertyAll(shape),
      );

  /// Quiet text action.
  static ButtonStyle get text => ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.textTertiary;
          }
          return AppColors.primary;
        }),
        textStyle: WidgetStatePropertyAll(
          AppTypography.button.copyWith(color: AppColors.primary),
        ),
        minimumSize: WidgetStatePropertyAll(minimumSize),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        ),
        shape: WidgetStatePropertyAll(shape),
      );

  static ElevatedButtonThemeData get elevatedTheme =>
      ElevatedButtonThemeData(style: primary);

  static FilledButtonThemeData get filledTheme =>
      FilledButtonThemeData(style: primary);

  static OutlinedButtonThemeData get outlinedTheme =>
      OutlinedButtonThemeData(style: secondary);

  static TextButtonThemeData get textTheme => TextButtonThemeData(style: text);
}
