import 'package:flutter/material.dart';

/// Warm, minimal palette for MOMO.
///
/// Soft cream backgrounds, coral primary, quiet neutrals.
abstract final class AppColors {
  // Surfaces
  static const Color background = Color(0xFFFFF8F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF7EFE9);

  // Brand
  static const Color primary = Color(0xFFE07A5F);
  static const Color primaryDark = Color(0xFFC45D42);
  static const Color primarySoft = Color(0xFFF6E0D8);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF2D2A26);
  static const Color textSecondary = Color(0xFF6B6560);
  static const Color textTertiary = Color(0xFFA39E99);

  // Lines & chrome
  static const Color border = Color(0xFFEDE4DE);
  static const Color borderStrong = Color(0xFFDCCFC6);
  static const Color navInactive = Color(0xFFA39E99);
  static const Color divider = border;

  // Feedback (kept quiet; use sparingly)
  static const Color danger = Color(0xFFC44B4B);
}
