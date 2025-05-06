import 'package:flutter/material.dart';
import '../models/section.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';

class SectionFormDialog extends StatefulWidget {
  final Section? section;

  const SectionFormDialog({super.key, this.section});

  @override
  State<SectionFormDialog> createState() => _SectionFormDialogState();
}

class _SectionFormDialogState extends State<SectionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _requiredCreditsController;
  late final TextEditingController _optionalCreditsController;
  final _languageManager = LanguageManager();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.section?.name ?? '');
    _descriptionController = TextEditingController(text: widget.section?.description ?? '');
    _requiredCreditsController = TextEditingController(
      text: widget.section?.requiredCredits.toString() ?? '0',
    );
    _optionalCreditsController = TextEditingController(
      text: widget.section?.optionalCredits.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _requiredCreditsController.dispose();
    _optionalCreditsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.section == null 
          ? _languageManager.currentStrings.addSection 
          : _languageManager.currentStrings.editSection,
        style: TextStyle(color: AppColors.primary),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: _languageManager.currentStrings.sectionName,
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: AppColors.primary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _languageManager.currentStrings.sectionNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: _languageManager.currentStrings.description,
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: AppColors.primary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _requiredCreditsController,
                decoration: InputDecoration(
                  labelText: _languageManager.currentStrings.requiredCredits,
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: AppColors.primary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _languageManager.currentStrings.requiredCreditsRequired;
                  }
                  final credits = int.tryParse(value);
                  if (credits == null || credits < 0) {
                    return _languageManager.currentStrings.creditsMustBePositive;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _optionalCreditsController,
                decoration: InputDecoration(
                  labelText: _languageManager.currentStrings.optionalCredits,
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: AppColors.primary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _languageManager.currentStrings.optionalCreditsRequired;
                  }
                  final credits = int.tryParse(value);
                  if (credits == null || credits < 0) {
                    return _languageManager.currentStrings.creditsMustBePositive;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            _languageManager.currentStrings.cancel,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final section = Section(
                name: _nameController.text,
                requiredCredits: int.parse(_requiredCreditsController.text),
                optionalCredits: int.parse(_optionalCreditsController.text),
                description: _descriptionController.text,
                id: widget.section?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                courseGroups: widget.section?.courseGroups ?? [],
              );
              Navigator.of(context).pop(section);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(
            widget.section == null 
              ? _languageManager.currentStrings.add 
              : _languageManager.currentStrings.update,
          ),
        ),
      ],
    );
  }
}