import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Centered loading indicator shared by all async flows.
class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
    this.message,
    this.title,
  });

  /// Optional primary line (e.g. "Loading...").
  final String? title;

  /// Optional secondary line (e.g. "Please wait.").
  final String? message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            if (title != null) ...[
              const SizedBox(height: 20),
              Text(
                title!,
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (message != null) ...[
              SizedBox(height: title == null ? 20 : 8),
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
