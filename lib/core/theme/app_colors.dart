import 'package:flutter/material.dart';

/// Centralized MOMO color tokens.
///
/// Prefer [AppColors] over raw `Color(...)` in feature UI.
abstract final class AppColors {
  // Brand — Modern & Friendly pink
  static const Color primary = Color(0xFFFF4D6D);
  static const Color secondary = Color(0xFFE83A5A);

  /// Accent for badges / emphasis (matches primary brand pink).
  static const Color primaryDark = primary;

  /// Light pink fill for chips, icon buttons, nav indicator.
  static const Color lightPink = Color(0xFFFFE7EA);

  /// Soft blush surface accent.
  static const Color softBlush = Color(0xFFFFF3F4);

  /// Compact Home hero banner fill.
  static const Color heroBanner = Color(0xFFFFF1F4);

  // Surfaces
  static const Color background = Color(0xFFFFF9F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = surface;

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Borders / chrome
  static const Color border = Color(0xFFF1E5E3);
  static const Color divider = border;
  static const Color navInactive = Color(0xFF6B7280);

  /// Soft card shadow tint.
  static const Color cardShadow = Color(0x1A1A1A1A);

  // Status
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF5B8C5A);
  static const Color warning = Color(0xFFD4A017);

  // Soft fills (chips, indicators)
  static Color get primarySoft => lightPink;
  static Color get secondarySoft => softBlush;
}
