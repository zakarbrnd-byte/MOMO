import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'debug_panel.dart';
import 'debug_provider.dart';

/// Small FAB that opens [DebugPanel]. Only mount when debug is enabled.
class DebugFab extends StatelessWidget {
  const DebugFab({super.key});

  @override
  Widget build(BuildContext context) {
    if (!isDeveloperDebugPanelEnabled) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.small(
      key: const Key('debug_fab'),
      heroTag: 'momo_debug_fab',
      tooltip: 'Developer Debug',
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.white,
      onPressed: () => showDebugPanel(context),
      child: const Icon(Icons.bug_report_outlined),
    );
  }
}
