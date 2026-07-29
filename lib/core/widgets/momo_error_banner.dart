import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Lightweight error feedback (SnackBar) for failed mutations.
abstract final class MomoErrorBanner {
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
          backgroundColor: AppColors.error,
          content: Row(
            children: [
              const Icon(
                Icons.error_outline,
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
