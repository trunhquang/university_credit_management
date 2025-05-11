import 'package:flutter/material.dart';
import '../models/course.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';

class SelectedCoursesSummary extends StatelessWidget {
  final List<Course> selectedCourses;
  final LanguageManager languageManager;

  const SelectedCoursesSummary({
    super.key,
    required this.selectedCourses,
    required this.languageManager,
  });

  int get totalCredits => selectedCourses.fold(0, (sum, course) => sum + course.credits);

  @override
  Widget build(BuildContext context) {
    if (selectedCourses.isEmpty) return const SizedBox.shrink();

    return Card(
      color: AppColors.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${languageManager.currentStrings.selectedCourses}: ${selectedCourses.length}',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${languageManager.currentStrings.totalCredits}: $totalCredits',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 