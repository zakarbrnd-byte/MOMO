import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'momo_button.dart';
import 'momo_card.dart';

/// Shared empty-state block for lists and search results.
///
/// Use for no playdates, no posts, future search / notifications / messages.
class MomoEmptyState extends StatelessWidget {
  const MomoEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
    this.illustration,
  });

  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  /// Optional visual placeholder (icon, image, etc.).
  final Widget? illustration;

  bool get _hasAction =>
      buttonText != null &&
      buttonText!.trim().isNotEmpty &&
      onPressed != null;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MomoCard(
      padding: AppSpacing.emptyStatePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (illustration != null) ...[
            Center(child: illustration),
            const SizedBox(height: AppSpacing.lg),
          ],
          Text(
            title,
            style: textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (_hasAction) ...[
            const SizedBox(height: AppSpacing.xl),
            MomoButton(
              label: buttonText!,
              onPressed: onPressed,
            ),
          ],
        ],
      ),
    );
  }
}

/// @nodoc Backward-compatible alias — requires [buttonText] + [onPressed].
typedef EmptyState = MomoEmptyState;
