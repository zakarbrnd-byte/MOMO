import 'package:flutter/material.dart';

import '../../models/post.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(post.title, style: textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Posted by ${post.authorName}',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Text(post.content, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
