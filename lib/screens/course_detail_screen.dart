import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/section.dart';
import '../widgets/course_form_dialog.dart';
import '../services/program_service.dart';

class CourseDetailScreen extends StatefulWidget {
  final Section section;

  const CourseDetailScreen({
    super.key,
    required this.section,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Section _section;
  final _programService = ProgramService();

  @override
  void initState() {
    super.initState();
    _section = widget.section;
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (context) => CourseFormDialog(sectionId: _section.id),
    );

    if (course != null) {
      try {
        await _programService.addCourse(_section.id, course);
        final updatedSections = await _programService.getSections();
        setState(() {
          _section = updatedSections.firstWhere((s) => s.id == _section.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã thêm môn học')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e')),
          );
        }
      }
    }
  }

  Future<void> _editCourse(Course course) async {
    final updatedCourse = await showDialog<Course>(
      context: context,
      builder: (context) => CourseFormDialog(
        sectionId: _section.id,
        course: course,
      ),
    );

    if (updatedCourse != null) {
      try {
        await _programService.updateCourse(_section.id, updatedCourse);
        final updatedSections = await _programService.getSections();
        setState(() {
          _section = updatedSections.firstWhere((s) => s.id == _section.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã cập nhật môn học')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteCourse(Course course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa môn ${course.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _programService.deleteCourse(_section.id, course.id);
        final updatedSections = await _programService.getSections();
        setState(() {
          _section = updatedSections.firstWhere((s) => s.id == _section.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa môn học')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_section.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionInfo(),
            const Divider(height: 32),
            _buildCourseList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionInfo() {
    // Tính toán số tín chỉ đã hoàn thành
    final completedRequiredCredits = _section.courses
        .where((course) => 
            course.status == CourseStatus.completed && 
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final completedOptionalCredits = _section.courses
        .where((course) => 
            course.status == CourseStatus.completed && 
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    // Tính toán số tín chỉ đang học
    final inProgressRequiredCredits = _section.courses
        .where((course) => 
            course.status == CourseStatus.inProgress && 
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressOptionalCredits = _section.courses
        .where((course) => 
            course.status == CourseStatus.inProgress && 
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _section.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _section.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            _buildCreditInfo(
              'Tín chỉ bắt buộc:',
              _section.requiredCredits,
              completedCredits: completedRequiredCredits,
              inProgressCredits: inProgressRequiredCredits,
            ),
            const SizedBox(height: 4),
            _buildCreditInfo(
              'Tín chỉ tự chọn:',
              _section.optionalCredits,
              completedCredits: completedOptionalCredits,
              inProgressCredits: inProgressOptionalCredits,
            ),
            const SizedBox(height: 4),
            _buildCreditInfo(
              'Tổng số tín chỉ:',
              _section.requiredCredits + _section.optionalCredits,
              completedCredits: completedRequiredCredits + completedOptionalCredits,
              inProgressCredits: inProgressRequiredCredits + inProgressOptionalCredits,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditInfo(
    String label,
    int credits, {
    int? completedCredits,
    int? inProgressCredits,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            Text(
              completedCredits != null
                  ? '$completedCredits'
                  : '0',
              style: TextStyle(
                color: Colors.green,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (inProgressCredits != null && inProgressCredits > 0) ...[
              Text(
                ' (+$inProgressCredits)',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
            Text(
              '/$credits tín chỉ',
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? Colors.blue : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseList() {
    final completedCourses = _section.courses
        .where((course) => course.status == CourseStatus.completed)
        .toList();
    final inProgressCourses = _section.courses
        .where((course) => course.status == CourseStatus.inProgress)
        .toList();
    final notStartedCourses = _section.courses
        .where((course) => course.status == CourseStatus.notStarted)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (completedCourses.isNotEmpty) ...[
            _buildCourseSection('Đã hoàn thành', completedCourses, Colors.green),
            const SizedBox(height: 16),
          ],
          if (inProgressCourses.isNotEmpty) ...[
            _buildCourseSection('Đang học', inProgressCourses, Colors.blue),
            const SizedBox(height: 16),
          ],
          if (notStartedCourses.isNotEmpty)
            _buildCourseSection('Chưa học', notStartedCourses, Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCourseSection(String title, List<Course> courses, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...courses.map((course) => _buildCourseCard(course, color)),
      ],
    );
  }

  Widget _buildCourseCard(Course course, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          course.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                _buildChip('${course.credits} tín chỉ', Icons.school),
                const SizedBox(width: 8),
                _buildChip(
                  course.type == CourseType.required ? 'Bắt buộc' : 'Tự chọn',
                  Icons.bookmark,
                ),
                if (course.grade != null) ...[
                  const SizedBox(width: 8),
                  _buildChip('Điểm: ${course.grade}', Icons.grade),
                ],
              ],
            ),
            if (course.prerequisiteCourses.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Môn học tiên quyết: ${course.prerequisiteCourses}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Sửa'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Xóa', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _editCourse(course);
                break;
              case 'delete':
                _deleteCourse(course);
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
} 