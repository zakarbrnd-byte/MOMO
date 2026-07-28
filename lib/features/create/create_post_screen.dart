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
import '../../models/post.dart';
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

  String? _category = PostCategories.daily;

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
              category: _category,
            );
      },
    );

    if (!succeeded || !mounted) return;

    ref.read(debugSessionProvider.notifier).recordAction('Create Post');

    AppNavigation.completeCreateAndGoHome(
      context,
      ref,
      successMessage: '글을 올렸어요!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(createPostMutationProvider);
    final isBusy = mutation.isLoading;
    final fieldsEnabled = !isBusy;

    return Scaffold(
      appBar: AppBar(title: const Text('글 작성하기')),
      body: switch (mutation) {
        AsyncOpLoading() => const MomoLoading(
            title: '올리는 중...',
            message: '잠시만 기다려 주세요.',
          ),
        AsyncOpError(:final message) => MomoError(
            title: '글을 올리지 못했어요',
            message: message,
            onRetry: () => _post(fromRetry: true),
          ),
        _ => Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: MomoFormBody(
              children: [
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '카테고리',
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _category,
                      items: [
                        for (final category in PostCategories.discovery)
                          DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                      ],
                      onChanged: fieldsEnabled
                          ? (value) {
                              if (value == null) return;
                              setState(() => _category = value);
                            }
                          : null,
                    ),
                  ),
                ),
                MomoTextField(
                  controller: _titleController,
                  focusNode: _titleFocus,
                  label: '제목',
                  hint: '무엇을 나누고 싶나요?',
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
                          fieldLabel: '제목',
                        ),
                  ]),
                ),
                MomoTextField(
                  controller: _contentController,
                  focusNode: _contentFocus,
                  label: '내용',
                  hint: '편하게 적어 주세요…',
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
                          fieldLabel: '내용',
                        ),
                  ]),
                ),
                const MomoFormSubmitGap(),
                MomoButton(
                  label: '올리기',
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
