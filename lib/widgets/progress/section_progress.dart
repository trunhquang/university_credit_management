import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/language_manager.dart';
import '../../../l10n/app_strings.dart';
import '../../../theme/app_colors.dart';
import '../../../models/section.dart';
import '../../../models/course.dart';

class SectionProgress extends StatelessWidget {
  final List<Section> sections;

  const SectionProgress({
    super.key,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    final strings = Provider.of<LanguageManager>(context).currentStrings;

    if (sections.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              strings.noSections,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strings.sections,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${strings.total}: ${sections.length} ${strings.sections}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return Column(
                  children: [
                    if (index > 0) const Divider(height: 24, color: AppColors.divider),
                    _buildSectionCard(section, strings),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(Section section, AppStrings strings) {
    final completedCredits = section.allCourses
        .where((course) => course.status == CourseStatus.completed)
        .fold<int>(0, (sum, course) => sum + course.credits);

    final inProgressCredits = section.allCourses
        .where((course) => course.status == CourseStatus.inProgress)
        .fold<int>(0, (sum, course) => sum + course.credits);

    final registeringCredits = section.allCourses
        .where((course) => course.status == CourseStatus.registering)
        .fold<int>(0, (sum, course) => sum + course.credits);

    final totalCredits = section.requiredCredits + section.optionalCredits;
    final progress = totalCredits > 0 ? (completedCredits + inProgressCredits + registeringCredits) / totalCredits : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                section.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.progressBackground,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress == 1.0 ? AppColors.success : AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        _buildCreditRow(
          strings.completed,
          completedCredits,
          totalCredits,
          AppColors.success,
          strings,
        ),
        const SizedBox(height: 8),
        _buildCreditRow(
          strings.inProgress,
          inProgressCredits,
          totalCredits,
          AppColors.primary,
          strings,
        ),
        if (registeringCredits > 0) ...[
          const SizedBox(height: 8),
          _buildCreditRow(
            strings.registering,
            registeringCredits,
            totalCredits,
            AppColors.info,
            strings,
          ),
        ],
        const SizedBox(height: 8),
        _buildCreditRow(
          strings.remainingCredits,
          totalCredits - completedCredits - inProgressCredits - registeringCredits,
          totalCredits,
          AppColors.warning,
          strings,
        ),
      ],
    );
  }

  Widget _buildCreditRow(
    String title,
    int credits,
    int totalCredits,
    Color color,
    AppStrings strings,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            children: [
              TextSpan(
                text: '$credits',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: '/$totalCredits ${strings.credits}'),
            ],
          ),
        ),
      ],
    );
  }
} 