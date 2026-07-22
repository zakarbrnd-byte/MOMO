import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Shared primary action button for MOMO.
class MomoButton extends StatelessWidget {
  const MomoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.fullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final bool fullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  bool get _canTap => enabled && !isLoading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: AppSpacing.lg,
            width: AppSpacing.lg,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.onPrimary,
            ),
          )
        : _ButtonLabel(
            label: label,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
          );

    final button = FilledButton(
      onPressed: _canTap ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
        disabledForegroundColor: AppColors.onPrimary,
        textStyle: AppTextStyles.button.copyWith(color: AppColors.onPrimary),
        minimumSize: Size(
          fullWidth ? double.infinity : 0,
          52,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: child,
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

class _ButtonLabel extends StatelessWidget {
  const _ButtonLabel({
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 20),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.button.copyWith(color: AppColors.onPrimary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(trailingIcon, size: 20),
        ],
      ],
    );
  }
}
