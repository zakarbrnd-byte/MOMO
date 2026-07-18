import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers/feed_provider.dart';
import '../features/create/create_selection_screen.dart';
import '../features/home/home_feed_screen.dart';
import '../features/profile/profile_screen.dart';

/// Bottom navigation: Home · Create · Profile (CLAUDE.md).
///
/// Home and Create each get a nested [Navigator] for detail / form stacks.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.add_circle_outline),
      selectedIcon: Icon(Icons.add_circle),
      label: 'Create',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(tabIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          _TabNavigator(root: HomeFeedScreen()),
          _TabNavigator(root: CreateSelectionScreen()),
          _TabNavigator(root: ProfileScreen()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        destinations: _destinations,
        onDestinationSelected: (value) {
          ref.read(tabIndexProvider.notifier).state = value;
        },
      ),
    );
  }
}

class _TabNavigator extends StatelessWidget {
  const _TabNavigator({required this.root});

  final Widget root;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (_) => root,
          settings: settings,
        );
      },
    );
  }
}
