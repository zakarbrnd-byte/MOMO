import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../data/models/post.dart';
import '../../data/providers/feed_provider.dart';

/// Form to add a Post card to the mock feed.
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    final post = Post(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      author: user,
      createdAt: DateTime.now(),
    );

    ref.read(feedProvider.notifier).addPost(post);
    ref.read(tabIndexProvider.notifier).state = 0;

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.screenInsets,
          children: [
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Anyone free Thursday?',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Add a title';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _bodyController,
              textCapitalization: TextCapitalization.sentences,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Share a short note for nearby moms…',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Add a message';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton(
              onPressed: _submit,
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
