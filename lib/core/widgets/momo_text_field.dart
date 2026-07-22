import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Shared text input for MOMO forms.
///
/// Styling comes from [ThemeData.inputDecorationTheme] plus surface fill.
class MomoTextField extends StatelessWidget {
  const MomoTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.sentences,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.spaced = true,
    this.obscureText = false,
    this.autocorrect = true,
  }) : assert(
          controller == null || initialValue == null,
          'Cannot provide both a controller and an initialValue.',
        );

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// Adds bottom spacing for stacked form fields.
  final bool spaced;
  final bool obscureText;
  final bool autocorrect;

  @override
  Widget build(BuildContext context) {
    final isMultiline = maxLines > 1 || (minLines != null && minLines! > 1);

    final field = TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      focusNode: focusNode,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      obscureText: obscureText,
      autocorrect: autocorrect,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction ??
          (isMultiline ? TextInputAction.newline : TextInputAction.next),
      onTap: enabled ? onTap : null,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      keyboardType: keyboardType ??
          (isMultiline ? TextInputType.multiline : TextInputType.text),
      inputFormatters: inputFormatters,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: enabled ? AppColors.textPrimary : AppColors.textDisabled,
          ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        filled: true,
        fillColor: enabled
            ? AppColors.surface
            : AppColors.surface.withValues(alpha: 0.7),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // Comfortable tap target; theme supplies borders/radius.
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
      ),
    );

    if (!spaced) return field;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.formFieldGap),
      child: field,
    );
  }
}
