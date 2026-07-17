import 'package:flutter/material.dart';

/// Placeholder — Home Feed feature not built yet.
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MOMO')),
      body: Center(
        child: Text(
          'Home Feed',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
