import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/course_group.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';

class RegisteringCourseCard extends StatelessWidget {
  final Course course;
  final CourseGroup? group;
  final Function(Course) onToggleOpenStatus;
  final Function(Course) onToggleRegistration;
  final LanguageManager languageManager;
  final bool isGroupCreditMet;

  const RegisteringCourseCard({
    super.key,
    required this.course,
    required this.group,
    required this.onToggleOpenStatus,
    required this.onToggleRegistration,
    required this.languageManager,
    required this.isGroupCreditMet,
  });

  bool get _shouldStrikeThrough {
    return [
      CourseStatus.completed,
      CourseStatus.inProgress,
    ].contains(course.status);
  }

  bool get _canRegister {
    return course.isOpen &&
        !isGroupCreditMet &&
        [
          CourseStatus.notStarted,
          CourseStatus.failed,
          CourseStatus.needToRegister,
        ].contains(course.status);
  }

  bool get _canUnregister {
    return course.isOpen && course.status == CourseStatus.registering;
  }

  String _getStatusText(CourseStatus status) {
    switch (status) {
      case CourseStatus.notStarted:
        return languageManager.currentStrings.notStarted;
      case CourseStatus.needToRegister:
        return languageManager.currentStrings.needToRegister;
      case CourseStatus.registering:
        return languageManager.currentStrings.registering;
      case CourseStatus.inProgress:
        return languageManager.currentStrings.inProgress;
      case CourseStatus.completed:
        return languageManager.currentStrings.completed;
      case CourseStatus.failed:
        return languageManager.currentStrings.failed;
      default:
        return status.toString().split('.').last;
    }
  }

  Color _getStatusColor(CourseStatus status) {
    switch (status) {
      case CourseStatus.notStarted:
        return AppColors.textSecondary;
      case CourseStatus.needToRegister:
        return AppColors.warning;
      case CourseStatus.registering:
        return AppColors.info;
      case CourseStatus.inProgress:
        return AppColors.primary;
      case CourseStatus.completed:
        return AppColors.success;
      case CourseStatus.failed:
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16),
        title: Text(
          '${course.name} (${course.credits} ${languageManager.currentStrings.credits})',
          style: TextStyle(
            decoration:
                _shouldStrikeThrough ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.id,
              style: TextStyle(
                decoration:
                    _shouldStrikeThrough ? TextDecoration.lineThrough : null,
              ),
            ),
            if (group != null)
              Text(
                '${languageManager.currentStrings.group}: ${group!.name}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(course.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _getStatusColor(course.status),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getStatusText(course.status),
                    style: TextStyle(
                      color: _getStatusColor(course.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: course.isOpen
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color:
                          course.isOpen ? AppColors.success : AppColors.error,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        course.isOpen ? Icons.lock_open : Icons.lock,
                        size: 12,
                        color:
                            course.isOpen ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.isOpen
                            ? languageManager.currentStrings.open
                            : languageManager.currentStrings.closed,
                        style: TextStyle(
                          color: course.isOpen
                              ? AppColors.success
                              : AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_canRegister || _canUnregister)
              IconButton(
                icon: Icon(
                  _canRegister
                      ? Icons.add_circle_outline
                      : Icons.remove_circle_outline,
                  size: 16,
                  color: _canRegister ? AppColors.success : AppColors.error,
                ),
                onPressed: () => onToggleRegistration(course),
                tooltip: _canRegister ? 'Đăng ký học phần' : 'Hủy đăng ký',
                constraints: const BoxConstraints(),
              ),
            IconButton(
              icon: Icon(
                course.isOpen ? Icons.lock : Icons.lock_open,
                size: 16,
                color: course.isOpen ? AppColors.error : AppColors.success,
              ),
              onPressed: () => onToggleOpenStatus(course),
              tooltip: course.isOpen
                  ? languageManager.currentStrings.closeCourse
                  : languageManager.currentStrings.openCourse,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
