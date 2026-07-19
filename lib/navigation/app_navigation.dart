import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/main_tab_provider.dart';

/// Bottom-nav indices for [mainTabProvider].
abstract final class MainTabs {
  static const int home = 0;
  static const int create = 1;
  static const int profile = 2;
}

/// Shared navigation helpers for consistent tab + stack behavior.
abstract final class AppNavigation {
  /// Pops the nearest navigator back to its tab root (e.g. close form/detail).
  static void popToTabRoot(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  /// Selects a bottom tab. Caller may also pop the active tab stack when re-tapped.
  static void selectTab(WidgetRef ref, int tabIndex) {
    ref.read(mainTabProvider.notifier).state = tabIndex;
  }

  /// After a successful create: close form stack, go Home, show feedback.
  static void completeCreateAndGoHome(
    BuildContext context,
    WidgetRef ref, {
    required String successMessage,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    popToTabRoot(context);
    selectTab(ref, MainTabs.home);
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(successMessage)));
  }

  /// Push a page on the current tab navigator.
  static Future<T?> pushPage<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
