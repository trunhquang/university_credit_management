import 'package:flutter/material.dart';
import '../models/section.dart';

class AddSectionDialog extends StatefulWidget {
  const AddSectionDialog({super.key});

  @override
  State<AddSectionDialog> createState() => _AddSectionDialogState();
}

class _AddSectionDialogState extends State<AddSectionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _requiredCreditsController = TextEditingController();
  final _optionalCreditsController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _requiredCreditsController.dispose();
    _optionalCreditsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm khối kiến thức'),
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
                  hintText: 'Ví dụ: Kiến thức giáo dục đại cương',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên khối kiến thức';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _requiredCreditsController,
                decoration: const InputDecoration(
                  labelText: 'Số tín chỉ bắt buộc',
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
              TextFormField(
                controller: _optionalCreditsController,
                decoration: const InputDecoration(
                  labelText: 'Số tín chỉ tự chọn',
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
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  hintText: 'Mô tả về khối kiến thức này',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final section = Section(
                id: DateTime.now().toString(),
                name: _nameController.text,
                requiredCredits: int.parse(_requiredCreditsController.text),
                optionalCredits: int.parse(_optionalCreditsController.text),
                description: _descriptionController.text,
                courses: [], // Khởi tạo với danh sách môn học rỗng
              );
              Navigator.pop(context, section);
            }
          },
          child: const Text('Thêm'),
        ),
      ],
    );
  }
} 