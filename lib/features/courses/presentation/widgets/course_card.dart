import 'package:flutter/material.dart';

import '../../../../core/models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Course Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.id,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Score or Credits
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (course.isCompleted && course.score != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getScoreColor(course.score!).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${course.score!.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getScoreColor(course.score!),
                            ),
                          ),
                        )
                      else
                        Text(
                          '${course.credits} tín chỉ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(height: 4),
                      _buildTypeChip(),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Status and Progress
              Row(
                children: [
                  _buildStatusChip(),
                  const Spacer(),
                  if (course.isCompleted)
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Colors.green[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Hoàn thành',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  else if (course.status == CourseStatus.inProgress)
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: Colors.orange[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Đang học',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: course.type == CourseType.required
            ? Colors.blue.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        course.type == CourseType.required ? 'BB' : 'TC',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: course.type == CourseType.required
              ? Colors.blue[700]
              : Colors.green[700],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (course.status) {
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

  IconData _getStatusIcon() {
    switch (course.status) {
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

  String _getStatusText() {
    switch (course.status) {
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
}
