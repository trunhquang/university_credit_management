import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseFormDialog extends StatefulWidget {
  final Course? course; // null nếu là thêm mới
  final String sectionId;

  const CourseFormDialog({
    super.key,
    this.course,
    required this.sectionId,
  });

  @override
  State<CourseFormDialog> createState() => _CourseFormDialogState();
}

class _CourseFormDialogState extends State<CourseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _creditsController;
  late TextEditingController _gradeController;
  late TextEditingController _idController;
  late TextEditingController _prerequisiteController;
  
  CourseType _type = CourseType.required;
  CourseStatus _status = CourseStatus.notStarted;
  bool _isPassed = false;

  @override
  void initState() {
    super.initState();
    final course = widget.course;
    _nameController = TextEditingController(text: course?.name);
    _creditsController = TextEditingController(text: course?.credits.toString());
    _gradeController = TextEditingController(text: course?.grade?.toString());
    _idController = TextEditingController(text: course?.id);
    _prerequisiteController = TextEditingController(text: course?.prerequisiteCourses);
    
    if (course != null) {
      _type = course.type;
      _status = course.status;
      _isPassed = course.isPassed;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _creditsController.dispose();
    _gradeController.dispose();
    _idController.dispose();
    _prerequisiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.course == null ? 'Thêm môn học' : 'Sửa môn học'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'BV120002',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên môn học',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên môn học';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditsController,
                decoration: const InputDecoration(
                  labelText: 'Số tín chỉ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tín chỉ';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CourseType>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Loại môn học',
                  border: OutlineInputBorder(),
                ),
                items: CourseType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type == CourseType.required ? 'Bắt buộc' : 'Tự chọn'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _type = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CourseStatus>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Trạng thái',
                  border: OutlineInputBorder(),
                ),
                items: CourseStatus.values.map((status) {
                  String label;
                  switch (status) {
                    case CourseStatus.completed:
                      label = 'Đã hoàn thành';
                      break;
                    case CourseStatus.inProgress:
                      label = 'Đang học';
                      break;
                    case CourseStatus.notStarted:
                      label = 'Chưa học';
                      break;
                  }
                  return DropdownMenuItem(value: status, child: Text(label));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _status = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gradeController,
                decoration: const InputDecoration(
                  labelText: 'Điểm số',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  final grade = double.tryParse(value);
                  if (grade == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  if (grade < 0 || grade > 10) {
                    return 'Điểm phải từ 0 đến 10';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prerequisiteController,
                decoration: const InputDecoration(
                  labelText: 'Môn học tiên quyết',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Đã đạt'),
                value: _isPassed,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _isPassed = value);
                  }
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
          onPressed: _saveCourse,
          child: Text(widget.course == null ? 'Thêm' : 'Lưu'),
        ),
      ],
    );
  }

  void _saveCourse() {
    if (_formKey.currentState!.validate()) {
      final course = Course(
        id: widget.course?.id ?? _idController.text,
        name: _nameController.text,
        credits: int.parse(_creditsController.text),
        grade: _gradeController.text.isEmpty ? null : double.parse(_gradeController.text),
        isPassed: _isPassed,
        type: _type,
        status: _status,
        prerequisiteCourses: _prerequisiteController.text,
      );
      Navigator.of(context).pop(course);
    }
  }
} 