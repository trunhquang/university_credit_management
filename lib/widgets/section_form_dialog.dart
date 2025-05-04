import 'package:flutter/material.dart';
import '../models/section.dart';

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
      title: Text(widget.section == null ? 'Thêm khối kiến thức' : 'Sửa khối kiến thức'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên khối kiến thức',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên khối kiến thức';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _requiredCreditsController,
                decoration: const InputDecoration(
                  labelText: 'Số tín chỉ bắt buộc',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tín chỉ bắt buộc';
                  }
                  final credits = int.tryParse(value);
                  if (credits == null || credits < 0) {
                    return 'Số tín chỉ phải là số nguyên không âm';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _optionalCreditsController,
                decoration: const InputDecoration(
                  labelText: 'Số tín chỉ tự chọn',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tín chỉ tự chọn';
                  }
                  final credits = int.tryParse(value);
                  if (credits == null || credits < 0) {
                    return 'Số tín chỉ phải là số nguyên không âm';
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
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final section = Section(
                name: _nameController.text,
                requiredCredits: int.parse(_requiredCreditsController.text),
                optionalCredits : int.parse(_optionalCreditsController.text),
                description: _descriptionController.text,
                id: widget.section?.id,
              );
              Navigator.of(context).pop(section);
            }
          },
          child: Text(widget.section == null ? 'Thêm' : 'Cập nhật'),
        ),
      ],
    );
  }
}