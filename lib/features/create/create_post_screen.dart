import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/async/mutation_notifier.dart';
import '../../core/models/async_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/loading_view.dart';
import '../../debug/debug_provider.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/post_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get _isBusy => ref.read(createPostMutationProvider).isLoading;

  Future<void> _post({bool fromRetry = false}) async {
    if (_isBusy) return;

    if (!fromRetry) {
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });

      if (!_formKey.currentState!.validate()) return;
    }

    final succeeded = await ref.read(createPostMutationProvider.notifier).run(
      () {
        ref.read(postProvider.notifier).createPost(
              title: _titleController.text,
              content: _contentController.text,
            );
      },
    );

    if (!succeeded || !mounted) return;

    ref.read(debugSessionProvider.notifier).recordAction('Create Post');

    AppNavigation.completeCreateAndGoHome(
      context,
      ref,
      successMessage: 'Post created successfully!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(createPostMutationProvider);
    final isBusy = mutation.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: switch (mutation) {
        AsyncOpLoading() => const LoadingView(
            title: 'Loading...',
            message: 'Please wait.',
          ),
        AsyncOpError(:final message) => ErrorView(
            title: 'Could not create post',
            message: message,
            onRetry: () => _post(fromRetry: true),
          ),
        _ => Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                TextFormField(
                  controller: _titleController,
                  enabled: !isBusy,
                  decoration:
                      _decoration('Title', 'What do you want to share?'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a post title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  maxLines: 6,
                  enabled: !isBusy,
                  decoration: _decoration('Content', 'Write your post…'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please write some content';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: isBusy ? null : _post,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.6),
                    disabledForegroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(isBusy ? 'Creating...' : 'Create Post'),
                ),
              ],
            ),
          ),
      },
    );
  }

  InputDecoration _decoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    );
  }
}
