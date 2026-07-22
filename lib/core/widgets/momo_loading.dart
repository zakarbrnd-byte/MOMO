import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Shared loading indicator for async operations.
///
/// Use [inline] for compact rows (buttons, list tiles). Full-screen / page
/// loading is the default (centered).
class MomoLoading extends StatelessWidget {
  const MomoLoading({
    super.key,
    this.title,
    this.message,
    this.inline = false,
  });

  /// Optional primary line (e.g. "Loading...").
  final String? title;

  /// Optional secondary line (e.g. "Please wait.").
  final String? message;

  /// Compact horizontal layout for in-widget loading.
  final bool inline;

  @override
  Widget build(BuildContext context) {
    if (inline) {
      return _InlineLoading(title: title, message: message);
    }
    return _PageLoading(title: title, message: message);
  }
}

class _PageLoading extends StatelessWidget {
  const _PageLoading({this.title, this.message});

  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: AppSpacing.allXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            if (title != null) ...[
              const SizedBox(height: AppSpacing.xl),
              Text(
                title!,
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (message != null) ...[
              SizedBox(
                height: title == null ? AppSpacing.xl : AppSpacing.sm,
              ),
              Text(
                message!,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InlineLoading extends StatelessWidget {
  const _InlineLoading({this.title, this.message});

  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final label = title ?? message;

    return Padding(
      padding: AppSpacing.allMd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: AppSpacing.md),
            Flexible(
              child: Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// @nodoc Backward-compatible alias for Phase 3.2 call sites / tests.
typedef LoadingView = MomoLoading;
