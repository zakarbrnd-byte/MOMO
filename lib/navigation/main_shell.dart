import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../debug/debug_overlay.dart';
import '../features/create/create_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/profile_screen.dart';
import '../providers/main_tab_provider.dart';
import 'app_navigation.dart';

/// Bottom navigation: Home · Create · Profile (CLAUDE.md).
///
/// Each tab owns a nested [Navigator] so detail/create routes keep the
/// bottom bar visible and back stacks stay predictable.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  final _homeNavKey = GlobalKey<NavigatorState>();
  final _createNavKey = GlobalKey<NavigatorState>();
  final _profileNavKey = GlobalKey<NavigatorState>();

  List<GlobalKey<NavigatorState>> get _navKeys => [
        _homeNavKey,
        _createNavKey,
        _profileNavKey,
      ];

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

  void _onTabSelected(int selected) {
    final current = ref.read(mainTabProvider);
    if (selected == current) {
      // Re-tapping the active tab returns to that tab's root screen.
      _navKeys[selected].currentState?.popUntil((route) => route.isFirst);
      return;
    }
    AppNavigation.selectTab(ref, selected);
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(mainTabProvider);

    return DebugOverlay(
      child: Scaffold(
        body: IndexedStack(
          index: index,
          children: [
            _TabNavigator(navigatorKey: _homeNavKey, root: const HomeScreen()),
            _TabNavigator(
              navigatorKey: _createNavKey,
              root: const CreateScreen(),
            ),
            _TabNavigator(
              navigatorKey: _profileNavKey,
              root: const ProfileScreen(),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          destinations: _destinations,
          onDestinationSelected: _onTabSelected,
        ),
      ),
    );
  }
}

class _TabNavigator extends StatelessWidget {
  const _TabNavigator({
    required this.navigatorKey,
    required this.root,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget root;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => root,
        );
      },
    );
  }
}
