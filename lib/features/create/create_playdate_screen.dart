import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/playdate.dart';
import '../../data/providers/feed_provider.dart';
import '../../shared/widgets/cards/card_format.dart';

/// Form to add a Playdate card to the mock feed.
class CreatePlaydateScreen extends ConsumerStatefulWidget {
  const CreatePlaydateScreen({super.key});

  @override
  ConsumerState<CreatePlaydateScreen> createState() =>
      _CreatePlaydateScreenState();
}

class _CreatePlaydateScreenState extends ConsumerState<CreatePlaydateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _ageController = TextEditingController();

  DateTime _startsAt = DateTime.now().add(const Duration(days: 1)).copyWith(
        hour: 10,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startsAt,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startsAt),
    );
    if (time == null || !mounted) return;

    setState(() {
      _startsAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    final age = _ageController.text.trim();
    final playdate = Playdate(
      id: 'pd_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      startsAt: _startsAt,
      location: _locationController.text.trim(),
      host: user,
      ageRange: age.isEmpty ? null : age,
    );

    ref.read(feedProvider.notifier).addPlaydate(playdate);
    ref.read(tabIndexProvider.notifier).state = 0;

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Playdate')),
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
                hintText: 'Saturday park morning',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Add a title';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('When', style: AppTypography.label),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: _pickDateTime,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(CardFormat.playdateWhen(_startsAt)),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _locationController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Central Park playground',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Add a location';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Ages (optional)',
                hintText: '3–5',
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton(
              onPressed: _submit,
              child: const Text('Post playdate'),
            ),
          ],
        ),
      ),
    );
  }
}
