import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Shared scrollable form layout: padding + drag-to-dismiss keyboard.
///
/// Use for Create, Login, Profile Edit, and other form screens.
class MomoFormBody extends StatelessWidget {
  const MomoFormBody({
    super.key,
    required this.children,
    this.padding,
    this.keyboardDismissOnDrag = true,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final bool keyboardDismissOnDrag;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding ?? AppSpacing.pageForm,
      keyboardDismissBehavior: keyboardDismissOnDrag
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      children: children,
    );
  }
}

/// Standard gap between the last field and the primary submit button.
class MomoFormSubmitGap extends StatelessWidget {
  const MomoFormSubmitGap({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: AppSpacing.formSubmitGap);
  }
}
