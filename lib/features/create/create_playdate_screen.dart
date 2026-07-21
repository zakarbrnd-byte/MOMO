import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/async/mutation_notifier.dart';
import '../../core/models/async_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/loading_view.dart';
import '../../debug/debug_provider.dart';
import '../../navigation/app_navigation.dart';
import '../../providers/playdate_provider.dart';

class CreatePlaydateScreen extends ConsumerStatefulWidget {
  const CreatePlaydateScreen({super.key});

  @override
  ConsumerState<CreatePlaydateScreen> createState() =>
      _CreatePlaydateScreenState();
}

class _CreatePlaydateScreenState extends ConsumerState<CreatePlaydateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _childAgeController = TextEditingController();
  final _capacityController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _childAgeController.dispose();
    _capacityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int? _parseCapacity() {
    final raw = _capacityController.text.trim();
    if (raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  String _formatDate(DateTime date) {
    return MaterialLocalizations.of(context).formatFullDate(date);
  }

  String _formatTime(TimeOfDay time) {
    return MaterialLocalizations.of(context).formatTimeOfDay(
      time,
      alwaysUse24HourFormat: false,
    );
  }

  bool get _isBusy =>
      ref.read(createPlaydateMutationProvider).isLoading;

  Future<void> _pickDate() async {
    if (_isBusy) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: today,
      lastDate: DateTime(now.year + 2),
      helpText: 'Select Date',
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedDate = picked;
      _dateController.text = _formatDate(picked);
    });
  }

  Future<void> _pickTime() async {
    if (_isBusy) return;

    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: 'Select Time',
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedTime = picked;
      _timeController.text = _formatTime(picked);
    });
  }

  Future<void> _save({bool fromRetry = false}) async {
    if (_isBusy) return;

    if (!fromRetry) {
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });

      if (!_formKey.currentState!.validate()) return;
    }

    final succeeded = await ref.read(createPlaydateMutationProvider.notifier).run(
      () {
        ref.read(playdateProvider.notifier).createPlaydate(
              title: _titleController.text,
              date: _dateController.text,
              time: _timeController.text,
              location: _locationController.text,
              childAge: _childAgeController.text,
              description: _descriptionController.text,
              maxParticipants: _parseCapacity(),
            );
      },
    );

    if (!succeeded || !mounted) return;

    ref.read(debugSessionProvider.notifier).recordAction('Create Playdate');

    AppNavigation.completeCreateAndGoHome(
      context,
      ref,
      successMessage: 'Playdate created successfully!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(createPlaydateMutationProvider);
    final isBusy = mutation.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Playdate')),
      body: switch (mutation) {
        AsyncOpLoading() => const LoadingView(
            title: 'Loading...',
            message: 'Please wait.',
          ),
        AsyncOpError(:final message) => ErrorView(
            title: 'Could not create playdate',
            message: message,
            onRetry: () => _save(fromRetry: true),
          ),
        _ => Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: ListView(
              padding: AppSpacing.pageForm,
              children: [
                _Field(
                  controller: _titleController,
                  label: 'Title',
                  hint: 'e.g. Saturday Park Playdate',
                  enabled: !isBusy,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                _PickerField(
                  key: const Key('playdate_date_field'),
                  controller: _dateController,
                  label: 'Date',
                  hint: 'Select Date',
                  icon: Icons.calendar_today_outlined,
                  enabled: !isBusy,
                  onTap: _pickDate,
                  validator: (value) {
                    if (_selectedDate == null ||
                        value == null ||
                        value.trim().isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                _PickerField(
                  key: const Key('playdate_time_field'),
                  controller: _timeController,
                  label: 'Time (Optional)',
                  hint: 'Select Time',
                  helperText: 'Example: 10:30 AM',
                  icon: Icons.access_time,
                  enabled: !isBusy,
                  onTap: _pickTime,
                ),
                _Field(
                  controller: _locationController,
                  label: 'Location',
                  hint: 'e.g. Irvine Park',
                  enabled: !isBusy,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select a location';
                    }
                    return null;
                  },
                ),
                _Field(
                  controller: _childAgeController,
                  label: 'Child Age (Optional)',
                  hint: 'Example: 2-4 years old',
                  enabled: !isBusy,
                ),
                _Field(
                  key: const Key('playdate_capacity_field'),
                  controller: _capacityController,
                  label: 'Maximum Participants (Optional)',
                  hint: 'Example: 5',
                  helperText: 'Leave empty for unlimited spots',
                  enabled: !isBusy,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    final raw = value?.trim() ?? '';
                    if (raw.isEmpty) return null;
                    final parsed = int.tryParse(raw);
                    if (parsed == null || parsed <= 0) {
                      return 'Please enter a valid participant limit';
                    }
                    return null;
                  },
                ),
                _Field(
                  controller: _descriptionController,
                  label: 'Description (Optional)',
                  hint: 'Share a few details for other moms',
                  maxLines: 4,
                  enabled: !isBusy,
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton(
                  onPressed: isBusy ? null : _save,
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
                  child: Text(isBusy ? 'Creating...' : 'Create Playdate'),
                ),
              ],
            ),
          ),
      },
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.helperText,
    this.maxLines = 1,
    this.enabled = true,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? helperText;
  final int maxLines;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: helperText,
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
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.onTap,
    this.helperText,
    this.enabled = true,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? helperText;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        enabled: enabled,
        onTap: enabled ? onTap : null,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: helperText,
          filled: true,
          fillColor: AppColors.surface,
          suffixIcon: Icon(icon, color: AppColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}
