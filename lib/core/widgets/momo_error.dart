import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'momo_button.dart';

/// Shared error + retry layout for async failures.
class MomoError extends StatelessWidget {
  const MomoError({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.retryLabel = 'Try again',
    this.icon = Icons.error_outline,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;
  final String retryLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: AppSpacing.allXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSpacing.xxxl,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            MomoButton(
              label: retryLabel,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

/// @nodoc Backward-compatible alias for Phase 3.2 call sites / tests.
typedef ErrorView = MomoError;
