import 'package:flutter/material.dart';

/// Placeholder — Create Selection feature not built yet.
class CreatePlaceholderScreen extends StatelessWidget {
  const CreatePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create')),
      body: Center(
        child: Text(
          'Create',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
