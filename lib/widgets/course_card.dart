import 'package:flutter/material.dart';
import '../models/course.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';
import 'course_status_dropdown.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final LanguageManager languageManager;
  final void Function(CourseStatus) onChangeCourseStatus;

  const CourseCard({
    super.key,
    required this.course,
    required this.languageManager,
    required this.onChangeCourseStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 8),
        title: Text(
          "${course.id} - ${course.name}",
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${course.credits} ${languageManager.currentStrings.credits}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              course.type == CourseType.required
                  ? languageManager.currentStrings.required
                  : languageManager.currentStrings.optional,
              style: TextStyle(
                fontSize: 12,
                color: course.type == CourseType.required
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: CourseStatusDropdown(
          course: course,
          languageManager: languageManager,
          onChangeCourseStatus: (status) {
            onChangeCourseStatus(status);
            debugPrint('Changing status to $status');
          },
        ),
      ),
    );
  }
}
