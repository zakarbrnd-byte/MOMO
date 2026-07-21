import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../navigation/app_navigation.dart';
import '../providers/main_tab_provider.dart';
import '../providers/playdate_provider.dart';
import '../providers/post_provider.dart';
import 'debug_provider.dart';

/// Opens the developer debug bottom sheet.
Future<void> showDebugPanel(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: AppColors.surface,
    builder: (context) => const DebugPanel(),
  );
}

/// Bottom sheet: live app info + async simulation controls.
class DebugPanel extends ConsumerWidget {
  const DebugPanel({super.key});

  static String _tabLabel(int index) {
    return switch (index) {
      MainTabs.home => 'Home',
      MainTabs.create => 'Create',
      MainTabs.profile => 'Profile',
      _ => 'Unknown ($index)',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(debugSessionProvider);
    final playdateCount =
        ref.watch(playdateProvider).valueOrNull?.length ?? 0;
    final postCount = ref.watch(postProvider).valueOrNull?.length ?? 0;
    final tab = ref.watch(mainTabProvider);
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.xl + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Developer Debug', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            _InfoRow(label: 'Current Async State', value: session.opStateLabel),
            _InfoRow(
              label: 'Feed Items',
              value: '${playdateCount + postCount}',
            ),
            _InfoRow(label: 'Playdates', value: '$playdateCount'),
            _InfoRow(label: 'Posts', value: '$postCount'),
            _InfoRow(label: 'Current Selected Tab', value: _tabLabel(tab)),
            _InfoRow(label: 'Last Action', value: session.lastAction),
            const SizedBox(height: AppSpacing.xl),
            Text('Simulations', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(debugSessionProvider.notifier).simulateLoading();
              },
              style: _primaryStyle(),
              child: const Text('Simulate Loading'),
            ),
            const SizedBox(height: AppSpacing.sm),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(debugSessionProvider.notifier).simulateSuccess();
              },
              style: _primaryStyle(),
              child: const Text('Simulate Success'),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(debugSessionProvider.notifier).simulateError();
              },
              style: _outlineStyle(),
              child: const Text('Simulate Error'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () {
                ref.read(debugSessionProvider.notifier).reset();
              },
              child: const Text('Reset State'),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _primaryStyle() {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  ButtonStyle _outlineStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryDark,
      side: const BorderSide(color: AppColors.primary),
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
