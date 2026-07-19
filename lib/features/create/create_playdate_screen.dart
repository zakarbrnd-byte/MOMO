import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CreatePlaydateScreen extends StatefulWidget {
  const CreatePlaydateScreen({super.key});

  @override
  State<CreatePlaydateScreen> createState() => _CreatePlaydateScreenState();
}

class _CreatePlaydateScreenState extends State<CreatePlaydateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _childAgeController = TextEditingController();
  final _descriptionController = TextEditingController();

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

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Playdate saved (mock)')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Playdate')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _Field(
              controller: _titleController,
              label: 'Title',
              hint: 'e.g. Saturday Park Playdate',
            ),
            _Field(
              controller: _dateController,
              label: 'Date',
              hint: 'e.g. Sat, Jul 19',
            ),
            _Field(
              controller: _timeController,
              label: 'Time',
              hint: 'e.g. 10:00 AM',
            ),
            _Field(
              controller: _locationController,
              label: 'Location',
              hint: 'e.g. Olympic Park, Songpa',
            ),
            _Field(
              controller: _childAgeController,
              label: 'Child Age',
              hint: 'e.g. 3–5 years',
            ),
            _Field(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Share a few details for other moms',
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Save'),
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
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
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
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
