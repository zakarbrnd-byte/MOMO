import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/async/mutation_notifier.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/momo_button.dart';
import '../../core/widgets/momo_error.dart';
import '../../core/widgets/momo_error_banner.dart';
import '../../core/widgets/momo_form_body.dart';
import '../../core/widgets/momo_text_field.dart';
import '../../providers/group_provider.dart';

/// Create Event Announcement inside a Group the user belongs to.
class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _location = TextEditingController();
  final _childAge = TextEditingController();
  final _limit = TextEditingController();
  DateTime _dateTime = DateTime.now().add(const Duration(days: 3));
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _location.dispose();
    _childAge.dispose();
    _limit.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (time == null || !mounted) return;
    setState(() {
      _dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    final joinedIds =
        ref.read(currentUserGroupIdsProvider).valueOrNull ?? const <String>{};
    if (!joinedIds.contains(widget.groupId)) {
      setState(() => _error = '그룹 멤버만 일정을 만들 수 있어요.');
      return;
    }
    final title = _title.text.trim();
    final description = _description.text.trim();
    final location = _location.text.trim();
    if (title.isEmpty || description.isEmpty || location.isEmpty) {
      setState(() => _error = '제목, 소개, 장소는 필수입니다.');
      return;
    }
    final limitText = _limit.text.trim();
    final limit = limitText.isEmpty ? null : int.tryParse(limitText);
    if (limitText.isNotEmpty && (limit == null || limit < 1)) {
      setState(() => _error = '정원은 1 이상 숫자여야 합니다.');
      return;
    }

    final ok = await ref.read(createEventMutationProvider.notifier).run(
      () async {
        await ref
            .read(groupProvider.notifier)
            .createEvent(
              groupId: widget.groupId,
              title: title,
              description: description,
              dateTime: _dateTime,
              location: location,
              childAgeRange: _childAge.text.trim(),
              participantLimit: limit,
            );
      },
    );

    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      MomoErrorBanner.show(context, '이벤트를 만들지 못했습니다. 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(createEventMutationProvider);
    final local = _dateTime.toLocal();
    final when =
        '${local.month}/${local.day} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: const Text('Create Event Announcement')),
      body: MomoFormBody(
        children: [
          MomoTextField(controller: _title, label: 'Title'),
          const SizedBox(height: AppSpacing.formFieldGap),
          MomoTextField(
            controller: _description,
            label: 'Description',
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.formFieldGap),
          MomoTextField(controller: _location, label: 'Location'),
          const SizedBox(height: AppSpacing.formFieldGap),
          MomoTextField(controller: _childAge, label: 'Child age (optional)'),
          const SizedBox(height: AppSpacing.formFieldGap),
          MomoTextField(
            controller: _limit,
            label: 'Participant limit (optional)',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.formFieldGap),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date & time'),
            subtitle: Text(when),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickDateTime,
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(_error!),
          ],
          if (mutation.isError) ...[
            const SizedBox(height: AppSpacing.md),
            MomoError(
              title: 'Could not create',
              message: '이벤트를 만들지 못했습니다. 다시 시도해주세요.',
              onRetry: _submit,
            ),
          ],
          const SizedBox(height: AppSpacing.formSubmitGap),
          MomoButton(
            label: 'Create Event',
            isLoading: mutation.isLoading,
            onPressed: mutation.isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
