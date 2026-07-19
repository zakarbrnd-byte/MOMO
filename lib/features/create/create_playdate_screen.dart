import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/main_tab_provider.dart';
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
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _childAgeController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  Future<void> _pickDate() async {
    if (_isSubmitting) return;

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
    if (_isSubmitting) return;

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

  void _save() {
    if (_isSubmitting) return;

    setState(() {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    ref.read(playdateProvider.notifier).createPlaydate(
          title: _titleController.text,
          date: _dateController.text,
          time: _timeController.text,
          location: _locationController.text,
          childAge: _childAgeController.text,
          description: _descriptionController.text,
        );

    ref.read(mainTabProvider.notifier).state = 0;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Playdate created successfully!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Playdate')),
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _Field(
              controller: _titleController,
              label: 'Title',
              hint: 'e.g. Saturday Park Playdate',
              enabled: !_isSubmitting,
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
              enabled: !_isSubmitting,
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
              enabled: !_isSubmitting,
              onTap: _pickTime,
            ),
            _Field(
              controller: _locationController,
              label: 'Location',
              hint: 'e.g. Irvine Park',
              enabled: !_isSubmitting,
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
              enabled: !_isSubmitting,
            ),
            _Field(
              controller: _descriptionController,
              label: 'Description (Optional)',
              hint: 'Share a few details for other moms',
              maxLines: 4,
              enabled: !_isSubmitting,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _isSubmitting ? null : _save,
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
              child: Text(_isSubmitting ? 'Creating...' : 'Create Playdate'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.enabled = true,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool enabled;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        validator: validator,
        decoration: InputDecoration(
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
      padding: const EdgeInsets.only(bottom: 16),
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
