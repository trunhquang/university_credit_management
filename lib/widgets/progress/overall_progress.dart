import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/language_manager.dart';
import '../../../l10n/app_strings.dart';
import '../../../theme/app_colors.dart';
import '../../models/progress_model.dart';

class OverallProgress extends StatelessWidget {
  final ProgressModel progress;

  const OverallProgress({
    super.key, required this.progress,
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
            Text(
              strings.completionProgress,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress.percentage / 100,
              backgroundColor: AppColors.progressBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress.percentage == 100 ? AppColors.progressCompleted : AppColors.progressInProgress,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${progress.percentage.toStringAsFixed(2)}% ${strings.completed}',
                    style: TextStyle(
                      fontSize: 16,
                      color: progress.percentage == 100 ? AppColors.success : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: '${progress.completedCredits}',
                          style: const TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (progress.inProgressCredits > 0)
                          TextSpan(
                            text: ' (+${progress.inProgressCredits})',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (progress.totalRegisteringCredits > 0)
                          TextSpan(
                            text: ' (+${progress.totalRegisteringCredits})',
                            style: const TextStyle(
                              color: AppColors.info,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        TextSpan(text: '/${progress.totalCredits} ${strings.credits}'),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
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