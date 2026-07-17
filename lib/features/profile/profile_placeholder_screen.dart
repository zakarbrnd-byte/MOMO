import 'package:flutter/material.dart';

/// Placeholder — Profile feature not built yet.
class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
