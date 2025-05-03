import 'package:flutter/material.dart';
import '../models/section.dart';

class SectionFormDialog extends StatefulWidget {
  final Section? section; // null nếu là thêm mới

  const SectionFormDialog({
    super.key,
    this.section,
  });

  @override
  State<SectionFormDialog> createState() => _SectionFormDialogState();
}

class _SectionFormDialogState extends State<SectionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _requiredCreditsController;
  late TextEditingController _optionalCreditsController;

  @override
  void initState() {
    super.initState();
    final section = widget.section;
    _nameController = TextEditingController(text: section?.name);
    _descriptionController = TextEditingController(text: section?.description);
    _requiredCreditsController = TextEditingController(
      text: section?.requiredCredits.toString(),
    );
    _optionalCreditsController = TextEditingController(
      text: section?.optionalCredits.toString(),
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
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                maxLines: 2,
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
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
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
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
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
          onPressed: _saveSection,
          child: Text(widget.section == null ? 'Thêm' : 'Lưu'),
        ),
      ],
    );
  }

  void _saveSection() {
    if (_formKey.currentState!.validate()) {
      final section = Section(
        id: widget.section?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        requiredCredits: int.parse(_requiredCreditsController.text),
        optionalCredits: int.parse(_optionalCreditsController.text),
        courses: widget.section?.courses ?? [],
      );
      Navigator.of(context).pop(section);
    }
  }
} 