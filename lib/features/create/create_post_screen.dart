import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/async/mutation_notifier.dart';
import '../../core/forms/form_validators.dart';
import '../../core/models/async_state.dart';
import '../../core/widgets/momo_button.dart';
import '../../core/widgets/momo_error.dart';
import '../../core/widgets/momo_loading.dart';
import '../../core/widgets/momo_form_body.dart';
import '../../core/widgets/momo_text_field.dart';
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
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _titleFocus.dispose();
    _contentFocus.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get _isBusy => ref.read(createPostMutationProvider).isLoading;

  Future<void> _post({bool fromRetry = false}) async {
    if (_isBusy) return;
    FocusScope.of(context).unfocus();

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
    final fieldsEnabled = !isBusy;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: switch (mutation) {
        AsyncOpLoading() => const MomoLoading(
            title: 'Loading...',
            message: 'Please wait.',
          ),
        AsyncOpError(:final message) => MomoError(
            title: 'Could not create post',
            message: message,
            onRetry: () => _post(fromRetry: true),
          ),
        _ => Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: MomoFormBody(
              children: [
                MomoTextField(
                  controller: _titleController,
                  focusNode: _titleFocus,
                  label: 'Title',
                  hint: 'What do you want to share?',
                  enabled: fieldsEnabled,
                  textInputAction: TextInputAction.next,
                  maxLength: FormValidators.shortTitleMax,
                  onFieldSubmitted: (_) => _contentFocus.requestFocus(),
                  validator: FormValidators.combine([
                    (value) => FormValidators.requiredTrimmed(
                          value,
                          FormValidators.titleRequired,
                        ),
                    (value) => FormValidators.maxLength(
                          value,
                          FormValidators.shortTitleMax,
                          fieldLabel: 'Title',
                        ),
                  ]),
                ),
                MomoTextField(
                  controller: _contentController,
                  focusNode: _contentFocus,
                  label: 'Content',
                  hint: 'Write your post…',
                  maxLines: 6,
                  minLines: 4,
                  maxLength: FormValidators.longTextMax,
                  enabled: fieldsEnabled,
                  textInputAction: TextInputAction.newline,
                  validator: FormValidators.combine([
                    (value) => FormValidators.requiredTrimmed(
                          value,
                          FormValidators.contentRequired,
                        ),
                    (value) => FormValidators.maxLength(
                          value,
                          FormValidators.longTextMax,
                          fieldLabel: 'Content',
                        ),
                  ]),
                ),
                const MomoFormSubmitGap(),
                MomoButton(
                  label: 'Create Post',
                  isLoading: isBusy,
                  enabled: fieldsEnabled,
                  onPressed: _post,
                ),
              ],
            ),
          ),
      },
    );
  }
}
