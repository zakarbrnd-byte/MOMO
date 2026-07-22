import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/async/mutation_notifier.dart';
import '../../core/forms/form_validators.dart';
import '../../core/models/async_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/momo_button.dart';
import '../../core/widgets/momo_error.dart';
import '../../core/widgets/momo_loading.dart';
import '../../core/widgets/momo_form_body.dart';
import '../../core/widgets/momo_text_field.dart';
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
  final _titleFocus = FocusNode();
  final _locationFocus = FocusNode();
  final _childAgeFocus = FocusNode();
  final _capacityFocus = FocusNode();
  final _descriptionFocus = FocusNode();

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
    _titleFocus.dispose();
    _locationFocus.dispose();
    _childAgeFocus.dispose();
    _capacityFocus.dispose();
    _descriptionFocus.dispose();
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
    FocusScope.of(context).unfocus();

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
    FocusScope.of(context).unfocus();

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
    FocusScope.of(context).unfocus();

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
    final fieldsEnabled = !isBusy;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Playdate')),
      body: switch (mutation) {
        AsyncOpLoading() => const MomoLoading(
            title: 'Loading...',
            message: 'Please wait.',
          ),
        AsyncOpError(:final message) => MomoError(
            title: 'Could not create playdate',
            message: message,
            onRetry: () => _save(fromRetry: true),
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
                  hint: 'e.g. Saturday Park Playdate',
                  enabled: fieldsEnabled,
                  textInputAction: TextInputAction.next,
                  maxLength: FormValidators.shortTitleMax,
                  onFieldSubmitted: (_) => _locationFocus.requestFocus(),
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
                  key: const Key('playdate_date_field'),
                  controller: _dateController,
                  label: 'Date',
                  hint: 'Select Date',
                  enabled: fieldsEnabled,
                  readOnly: true,
                  onTap: _pickDate,
                  textInputAction: TextInputAction.next,
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textSecondary,
                  ),
                  validator: (value) {
                    if (_selectedDate == null ||
                        value == null ||
                        value.trim().isEmpty) {
                      return FormValidators.dateRequired;
                    }
                    return null;
                  },
                ),
                MomoTextField(
                  key: const Key('playdate_time_field'),
                  controller: _timeController,
                  label: 'Time (Optional)',
                  hint: 'Select Time',
                  helperText: 'Example: 10:30 AM',
                  enabled: fieldsEnabled,
                  readOnly: true,
                  onTap: _pickTime,
                  textInputAction: TextInputAction.next,
                  suffixIcon: const Icon(
                    Icons.access_time,
                    color: AppColors.textSecondary,
                  ),
                ),
                MomoTextField(
                  controller: _locationController,
                  focusNode: _locationFocus,
                  label: 'Location',
                  hint: 'e.g. Irvine Park',
                  enabled: fieldsEnabled,
                  textInputAction: TextInputAction.next,
                  maxLength: FormValidators.shortTitleMax,
                  onFieldSubmitted: (_) => _childAgeFocus.requestFocus(),
                  validator: FormValidators.combine([
                    (value) => FormValidators.requiredTrimmed(
                          value,
                          FormValidators.locationRequired,
                        ),
                    (value) => FormValidators.maxLength(
                          value,
                          FormValidators.shortTitleMax,
                          fieldLabel: 'Location',
                        ),
                  ]),
                ),
                MomoTextField(
                  controller: _childAgeController,
                  focusNode: _childAgeFocus,
                  label: 'Child Age (Optional)',
                  hint: 'Example: 2-4 years old',
                  enabled: fieldsEnabled,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _capacityFocus.requestFocus(),
                ),
                MomoTextField(
                  key: const Key('playdate_capacity_field'),
                  controller: _capacityController,
                  focusNode: _capacityFocus,
                  label: 'Maximum Participants (Optional)',
                  hint: 'Example: 5',
                  helperText: 'Leave empty for unlimited spots',
                  enabled: fieldsEnabled,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onFieldSubmitted: (_) => _descriptionFocus.requestFocus(),
                  validator: FormValidators.optionalPositiveInt,
                ),
                MomoTextField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocus,
                  label: 'Description (Optional)',
                  hint: 'Share a few details for other moms',
                  maxLines: 4,
                  minLines: 3,
                  maxLength: FormValidators.mediumTextMax,
                  enabled: fieldsEnabled,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _save(),
                  validator: (value) => FormValidators.maxLength(
                    value,
                    FormValidators.mediumTextMax,
                    fieldLabel: 'Description',
                  ),
                ),
                const MomoFormSubmitGap(),
                MomoButton(
                  label: 'Create Playdate',
                  isLoading: isBusy,
                  enabled: fieldsEnabled,
                  onPressed: _save,
                ),
              ],
            ),
          ),
      },
    );
  }
}
