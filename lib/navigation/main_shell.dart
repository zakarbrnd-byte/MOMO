import 'package:flutter/material.dart';

import '../features/create/create_placeholder_screen.dart';
import '../features/home/home_placeholder_screen.dart';
import '../features/profile/profile_placeholder_screen.dart';

/// Bottom navigation: Home · Create · Profile (CLAUDE.md).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          HomePlaceholderScreen(),
          CreatePlaceholderScreen(),
          ProfilePlaceholderScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: _destinations,
        onDestinationSelected: (index) {
          setState(() => _index = index);
        },
      ),
    );
  }
}
