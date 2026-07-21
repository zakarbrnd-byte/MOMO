import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/async_state.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/widgets/error_view.dart';
import '../core/widgets/loading_view.dart';
import 'debug_fab.dart';
import 'debug_provider.dart';

/// Overlays Loading / Error simulations and the debug FAB on the app shell.
///
/// No-ops in release builds when [isDeveloperDebugPanelEnabled] is false.
class DebugOverlay extends ConsumerWidget {
  const DebugOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isDeveloperDebugPanelEnabled) {
      return child;
    }

    final session = ref.watch(debugSessionProvider);

    // FAB stays above overlays so the panel remains reachable during sims.
    return Stack(
      children: [
        child,
        if (session.opState case AsyncOpLoading())
          const Positioned.fill(
            child: Material(
              color: AppColors.background,
              child: LoadingView(
                title: 'Loading...',
                message: 'Please wait.',
              ),
            ),
          ),
        if (session.opState case AsyncOpError(:final message))
          Positioned.fill(
            child: Material(
              color: AppColors.background,
              child: ErrorView(
                title: 'Something went wrong',
                message: message,
                onRetry: () {
                  ref.read(debugSessionProvider.notifier).retryAfterError();
                },
              ),
            ),
          ),
        const Positioned(
          right: AppSpacing.lg,
          bottom: AppSpacing.xxxl * 2,
          child: DebugFab(),
        ),
      ],
    );
  }
}
