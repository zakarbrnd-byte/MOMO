import 'package:flutter/material.dart';

/// Centralized MOMO color tokens.
///
/// Prefer [AppColors] over raw `Color(...)` in feature UI.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFE07A5F);
  static const Color secondary = Color(0xFFC45D42);

  /// Darker brand accent (same as [secondary]; kept for existing call sites).
  static const Color primaryDark = secondary;

  // Surfaces
  static const Color background = Color(0xFFFFF8F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = surface;

  // Text
  static const Color textPrimary = Color(0xFF2D2A26);
  static const Color textSecondary = Color(0xFF6B6560);
  static const Color textDisabled = Color(0xFFA39E99);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Borders / chrome
  static const Color border = Color(0xFFEDE4DE);
  static const Color divider = border;
  static const Color navInactive = textDisabled;

  // Status
  static const Color error = Color(0xFFC45D42);
  static const Color success = Color(0xFF5B8C5A);
  static const Color warning = Color(0xFFD4A017);

  // Soft fills (chips, indicators)
  static Color get primarySoft => primary.withValues(alpha: 0.12);
  static Color get secondarySoft => secondary.withValues(alpha: 0.15);
}
