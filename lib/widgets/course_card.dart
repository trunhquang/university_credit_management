import 'package:flutter/material.dart';
import '../models/course.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';
import 'course_status_dropdown.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final LanguageManager languageManager;
  final void Function(CourseStatus) onChangeCourseStatus;
  final void Function(double)? onScoreChanged;
  final bool isAcceptedChangeStatus;


  const CourseCard({
    super.key,
    required this.course,
    required this.languageManager,
    required this.onChangeCourseStatus,
    this.onScoreChanged,
    this.isAcceptedChangeStatus = false,
  });

  void _showScoreDialog(BuildContext context) {
    final scoreController = TextEditingController(
      text: course.score?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageManager.currentStrings.enterScore),
        content: TextField(
          controller: scoreController,
          decoration: InputDecoration(
            labelText: languageManager.currentStrings.score,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageManager.currentStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final score = double.tryParse(scoreController.text);
              if (score != null) {
                course.setScore(score);
                onScoreChanged?.call(score);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(languageManager.currentStrings.save),
          ),
        ],
      ),
    );
  }

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
            if (course.status == CourseStatus.completed ||
                course.status == CourseStatus.failed)
              TextButton.icon(
                onPressed: () => _showScoreDialog(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  course.score != null ? Icons.edit : Icons.add_circle_outline,
                  size: 16,
                  color: course.score != null
                      ? AppColors.primary
                      : AppColors.error,
                ),
                label: Text(
                  course.score != null
                      ? '${languageManager.currentStrings.score}: ${course.score!.toStringAsFixed(1)}'
                      : languageManager.currentStrings.enterScore,
                  style: TextStyle(
                    fontSize: 12,
                    color: course.score != null
                        ? AppColors.primary
                        : AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        trailing: CourseStatusDropdown(
          course: course,
          languageManager: languageManager,
          onChangeCourseStatus: (status) {
            if (status != CourseStatus.completed) {
              course.setScore(0);
            }
            onChangeCourseStatus(status);
            debugPrint('Changing status to $status');
          }, isAcceptedChangeStatus: isAcceptedChangeStatus,
        ),
      ),
    );
  }
}
