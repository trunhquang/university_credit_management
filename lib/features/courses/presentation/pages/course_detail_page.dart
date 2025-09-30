import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/state/curriculum_provider.dart';
import '../../../../core/models/course.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/services/notification_service.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;

  const CourseDetailPage({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final TextEditingController _scoreController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết môn học',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.goBack(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          ),
        ],
      ),
      body: Consumer<CurriculumProvider>(
        builder: (context, provider, child) {
          final course = provider.getCourseById(widget.courseId);
          
          if (course == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Không tìm thấy môn học',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Header
                _buildCourseHeader(course),
                const SizedBox(height: 24),

                // Course Info
                _buildCourseInfo(course),
                const SizedBox(height: 24),

                // Status Section
                _buildStatusSection(course, provider),
                const SizedBox(height: 24),

                // Score Section
                _buildScoreSection(course, provider),
                const SizedBox(height: 24),

                // Actions
                _buildActionButtons(course, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseHeader(Course course) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.book,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.id,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo(Course course) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin môn học',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Số tín chỉ', '${course.credits} tín chỉ'),
          _buildInfoRow('Loại môn', course.type == CourseType.required ? 'Bắt buộc' : 'Tự chọn'),
          _buildInfoRow('Trạng thái', _getStatusText(course.status)),
          if (course.prerequisiteCourses.isNotEmpty)
            _buildInfoRow('Môn tiên quyết', course.prerequisiteCourses.join(', ')),
        ],
      ),
    );
  }

  Widget _buildStatusSection(Course course, CurriculumProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trạng thái học tập',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_isEditing) ...[
            _buildStatusSelector(course, provider),
          ] else ...[
            _buildStatusDisplay(course),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreSection(Course course, CurriculumProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Điểm số',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_isEditing && course.isCompleted) ...[
            _buildScoreEditor(course, provider),
          ] else ...[
            _buildScoreDisplay(course),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDisplay(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(course.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(course.status).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(course.status),
            color: _getStatusColor(course.status),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            _getStatusText(course.status),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _getStatusColor(course.status),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSelector(Course course, CurriculumProvider provider) {
    return Column(
      children: CourseStatus.values.map((status) {
        return RadioListTile<CourseStatus>(
          title: Text(_getStatusText(status)),
          value: status,
          groupValue: course.status,
          onChanged: (CourseStatus? value) {
            if (value != null) {
              provider.updateCourseStatus(course.id, value);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildScoreDisplay(Course course) {
    if (course.isCompleted && course.score != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getScoreColor(course.score!).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getScoreColor(course.score!).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.grade,
              color: _getScoreColor(course.score!),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              '${course.score!.toStringAsFixed(1)}/10',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getScoreColor(course.score!),
              ),
            ),
            const Spacer(),
            Text(
              _getScoreGrade(course.score!),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getScoreColor(course.score!),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.grey,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Chưa có điểm số',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildScoreEditor(Course course, CurriculumProvider provider) {
    _scoreController.text = course.score?.toString() ?? '';
    
    return Column(
      children: [
        TextField(
          controller: _scoreController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Điểm số (0-10)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.grade),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final score = double.tryParse(_scoreController.text);
              if (score != null && score >= 0 && score <= 10) {
                provider.updateCourseScore(course.id, score);
                setState(() => _isEditing = false);
                NotificationService.showSnack(context, 'Đã cập nhật điểm số');
              } else {
                NotificationService.showSnack(context, 'Điểm số phải từ 0-10');
              }
            },
            child: const Text('Lưu điểm số'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Course course, CurriculumProvider provider) {
    return Column(
      children: [
        if (_isEditing) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _isEditing = false),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Hủy chỉnh sửa'),
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _isEditing = true),
              icon: const Icon(Icons.edit),
              label: const Text('Chỉnh sửa'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(CourseStatus status) {
    switch (status) {
      case CourseStatus.completed:
        return Colors.green;
      case CourseStatus.inProgress:
        return Colors.orange;
      case CourseStatus.notStarted:
        return Colors.grey;
      case CourseStatus.failed:
        return Colors.red;
      case CourseStatus.registering:
        return Colors.blue;
      case CourseStatus.needToRegister:
        return Colors.purple;
    }
  }

  IconData _getStatusIcon(CourseStatus status) {
    switch (status) {
      case CourseStatus.completed:
        return Icons.check_circle;
      case CourseStatus.inProgress:
        return Icons.schedule;
      case CourseStatus.notStarted:
        return Icons.pending;
      case CourseStatus.failed:
        return Icons.error;
      case CourseStatus.registering:
        return Icons.app_registration;
      case CourseStatus.needToRegister:
        return Icons.notification_important;
    }
  }

  String _getStatusText(CourseStatus status) {
    switch (status) {
      case CourseStatus.completed:
        return 'Đã hoàn thành';
      case CourseStatus.inProgress:
        return 'Đang học';
      case CourseStatus.notStarted:
        return 'Chưa học';
      case CourseStatus.failed:
        return 'Thi lại';
      case CourseStatus.registering:
        return 'Đang đăng ký';
      case CourseStatus.needToRegister:
        return 'Cần đăng ký';
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 8.0) return Colors.green;
    if (score >= 6.5) return Colors.blue;
    if (score >= 5.0) return Colors.orange;
    return Colors.red;
  }

  String _getScoreGrade(double score) {
    if (score >= 9.0) return 'Xuất sắc';
    if (score >= 8.0) return 'Giỏi';
    if (score >= 6.5) return 'Khá';
    if (score >= 5.0) return 'Trung bình';
    return 'Yếu';
  }
}
