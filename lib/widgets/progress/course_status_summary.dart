import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/language_manager.dart';
import '../../../l10n/app_strings.dart';
import '../../../theme/app_colors.dart';
import '../../models/progress_model.dart';

class CourseStatusSummary extends StatelessWidget {
  final ProgressModel progress;

  const CourseStatusSummary({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final strings = Provider.of<LanguageManager>(context).currentStrings;

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
                Expanded(
                  child: Text(
                    strings.courseStatus,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${strings.total}: ${progress.totalCourses} ${strings.courses}',
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
            _buildStatusRow(
              strings.completed,
              progress.completedCourses,
              progress.totalCourses,
              AppColors.success,
              strings,
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              strings.inProgress,
              progress.inProgressCourses,
              progress.totalCourses,
              AppColors.primary,
              strings,
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              strings.registering,
              progress.registeringCourses,
              progress.totalCourses,
              AppColors.info,
              strings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(
    String title,
    int count,
    int total,
    Color color,
    AppStrings strings, {
    bool isTotal = false,
  }) {
    final double progress = total > 0 ? count / total : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.progressBackground,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            children: [
              TextSpan(
                text: '$count',
                style: TextStyle(
                  color: color,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              TextSpan(text: '/$total ${strings.courses}'),
            ],
          ),
        ),
      ],
    );
  }
}
