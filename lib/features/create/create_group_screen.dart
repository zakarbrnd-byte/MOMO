import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/async/mutation_notifier.dart';
import '../../core/models/async_state.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/momo_button.dart';
import '../../core/widgets/momo_error.dart';
import '../../core/widgets/momo_form_body.dart';
import '../../core/widgets/momo_text_field.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/group_provider.dart';

/// Local Create Group form (Phase 3.7).
class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController(text: '육아');
  final _location = TextEditingController();
  final _ages = TextEditingController();
  final _tags = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _category.dispose();
    _location.dispose();
    _ages.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    final name = _name.text.trim();
    final description = _description.text.trim();
    final category = _category.text.trim();
    final location = _location.text.trim();
    if (name.isEmpty || description.isEmpty || location.isEmpty) {
      setState(() => _error = '이름, 소개, 지역은 필수입니다.');
      return;
    }

    final ages = _ages.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final tags = _tags.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    await ref.read(createGroupMutationProvider.notifier).run(() async {
      ref.read(groupProvider.notifier).createGroup(
            name: name,
            description: description,
            category: category.isEmpty ? '커뮤니티' : category,
            location: location,
            childAgeRanges: ages,
            interestTags: tags,
          );
    });

    if (!mounted) return;
    final state = ref.read(createGroupMutationProvider);
    if (state.isSuccess) {
      AppNavigation.completeCreateAndGoHome(
        context,
        ref,
        successMessage: 'Group created',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(createGroupMutationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: MomoFormBody(
        children: [
          MomoTextField(controller: _name, label: 'Group name'),
          const SizedBox(height: AppSpacing.formFieldGap),
          MomoTextField(
            controller: _description,
            label: 'Description',
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.formFieldGap),
          MomoTextField(controller: _category, label: 'Category'),
          const SizedBox(height: AppSpacing.formFieldGap),
          MomoTextField(controller: _location, label: 'Location'),
          const SizedBox(height: AppSpacing.formFieldGap),
          MomoTextField(
            controller: _ages,
            label: 'Child ages (comma-separated)',
          ),
          const SizedBox(height: AppSpacing.formFieldGap),
          MomoTextField(
            controller: _tags,
            label: 'Interest tags (comma-separated)',
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(_error!),
          ],
          if (mutation.isError) ...[
            const SizedBox(height: AppSpacing.md),
            MomoError(
              title: 'Could not create',
              message: switch (mutation) {
                AsyncOpError(:final message) => message,
                _ => 'Try again',
              },
              onRetry: _submit,
            ),
          ],
          const SizedBox(height: AppSpacing.formSubmitGap),
          MomoButton(
            label: 'Create Group',
            isLoading: mutation.isLoading,
            onPressed: mutation.isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
