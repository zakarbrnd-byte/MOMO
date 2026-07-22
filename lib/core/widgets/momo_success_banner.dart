import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Lightweight success feedback (SnackBar) for create / join / future APIs.
///
/// Prefer this over ad-hoc [SnackBar] widgets so success UX stays consistent.
abstract final class MomoSuccessBanner {
  /// Shows a floating success snackbar and clears any existing snackbars.
  ///
  /// Capture [messenger] before navigating away if [context] may unmount
  /// (e.g. after create → Home).
  static void show(
    BuildContext context,
    String message, {
    ScaffoldMessengerState? messenger,
  }) {
    final scaffoldMessenger = messenger ?? ScaffoldMessenger.of(context);
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.onPrimary,
        );

    scaffoldMessenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.onPrimary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(message, style: textStyle),
              ),
            ],
          ),
        ),
      );
  }
}
