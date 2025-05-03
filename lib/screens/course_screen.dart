import 'package:flutter/material.dart';
import '../services/program_service.dart';
import '../models/section.dart';
import '../models/course.dart';
import '../screens/course_detail_screen.dart';
import '../widgets/section_form_dialog.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final _programService = ProgramService();
  List<Section>? _sections;
  Map<String, dynamic>? _missingCredits;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDataSourcePreference();
  }

  Future<void> _loadDataSourcePreference() async {
    _loadData(); // Load data sau khi biết nguồn dữ liệu
  }

  Future<void> _loadData() async {
    if (!mounted || _isLoading) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final sections = await _programService.getSections();
      _sections = sections;

      // Tạo dữ liệu mẫu cho missing credits
      _missingCredits =
      await _programService.getMissingRequiredCredits();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
    setState(() {
          _errorMessage = 'Lỗi khi tải dữ liệu: $e';
          _isLoading = false;
    });
      }
    }
  }

  Future<void> _addSection() async {
    final section = await showDialog<Section>(
      context: context,
      builder: (context) => const SectionFormDialog(),
    );

    if (section != null) {
      try {
        await _programService.addSection(section);
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã thêm khối kiến thức')),
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

  Future<void> _editSection(Section section) async {
    final updatedSection = await showDialog<Section>(
      context: context,
      builder: (context) => SectionFormDialog(section: section),
    );

    if (updatedSection != null) {
      try {
        await _programService.updateSection(updatedSection);
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã cập nhật khối kiến thức')),
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

  Future<void> _deleteSection(Section section) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc muốn xóa khối kiến thức "${section.name}"?\n'
          'Tất cả môn học trong khối này cũng sẽ bị xóa.',
        ),
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
        await _programService.deleteSection(section.id);
      await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa khối kiến thức')),
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
        title: const Text('Khối kiến thức'),
        actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addSection,
              tooltip: 'Thêm khối kiến thức',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_sections == null || _sections!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Chưa có khối kiến thức nào'),
            ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addSection,
                child: const Text('Thêm khối kiến thức'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sections!.length,
      itemBuilder: (context, index) {
        final section = _sections![index];
        return _buildSectionCard(context, section);
      },
    );
  }

  Widget _buildSectionCard(BuildContext context, Section section) {
    // Tính toán số tín chỉ đã hoàn thành
    final completedRequiredCredits = section.courses
        .where((course) => 
            course.status == CourseStatus.completed && 
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final completedOptionalCredits = section.courses
        .where((course) => 
            course.status == CourseStatus.completed && 
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    // Tính toán số tín chỉ đang học
    final inProgressRequiredCredits = section.courses
        .where((course) => 
            course.status == CourseStatus.inProgress && 
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressOptionalCredits = section.courses
        .where((course) => 
            course.status == CourseStatus.inProgress && 
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final totalCompletedCredits = completedRequiredCredits + completedOptionalCredits;
    final totalInProgressCredits = inProgressRequiredCredits + inProgressOptionalCredits;
    final totalCredits = section.requiredCredits + section.optionalCredits;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(
              section.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              section.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            trailing:
                PopupMenuButton<String>(
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
                          _editSection(section);
                          break;
                        case 'delete':
                          _deleteSection(section);
                          break;
                      }
                    },
                  ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(section: section),
                ),
              ).then((_) => _loadData());
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
                child: Column(
              children: [
                LinearProgressIndicator(
                  value: totalCompletedCredits / totalCredits,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
                        children: [
                          const TextSpan(text: 'Bắt buộc: '),
                          TextSpan(
                            text: '$completedRequiredCredits',
                            style: const TextStyle(color: Colors.green),
                          ),
                          if (inProgressRequiredCredits > 0)
                            TextSpan(
                              text: ' (+$inProgressRequiredCredits)',
                              style: const TextStyle(color: Colors.blue),
                            ),
                          TextSpan(text: '/${section.requiredCredits}'),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
                        children: [
                          const TextSpan(text: 'Tự chọn: '),
                          TextSpan(
                            text: '$completedOptionalCredits',
                            style: const TextStyle(color: Colors.green),
                          ),
                          if (inProgressOptionalCredits > 0)
                            TextSpan(
                              text: ' (+$inProgressOptionalCredits)',
                              style: const TextStyle(color: Colors.blue),
                            ),
                          TextSpan(text: '/${section.optionalCredits}'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      const TextSpan(text: 'Tổng số tín chỉ: '),
                      TextSpan(
                        text: '$totalCompletedCredits',
                        style: const TextStyle(color: Colors.green),
                      ),
                      if (totalInProgressCredits > 0)
                        TextSpan(
                          text: ' (+$totalInProgressCredits)',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      TextSpan(text: '/$totalCredits'),
                  ],
                ),
              ),
              ],
            ),
          ),
        ],
            ),
    );
  }
} 