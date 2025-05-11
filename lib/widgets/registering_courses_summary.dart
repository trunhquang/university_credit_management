import 'package:flutter/material.dart';
import '../models/course.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';

class RegisteringCoursesSummary extends StatelessWidget {
  final List<Course> courses;
  final LanguageManager languageManager;

  const RegisteringCoursesSummary({
    super.key,
    required this.courses,
    required this.languageManager,
  });

  int get _registeringCoursesCount => 
      courses.where((course) => course.status == CourseStatus.registering).length;

  int get _totalCredits => 
      courses.where((course) => course.status == CourseStatus.registering)
          .fold(0, (sum, course) => sum + course.credits);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_registeringCoursesCount ${languageManager.currentStrings.courses}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  languageManager.currentStrings.registering,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$_totalCredits ${languageManager.currentStrings.credits}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  languageManager.currentStrings.totalCredits,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 