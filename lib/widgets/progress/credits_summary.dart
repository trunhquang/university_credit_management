import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/language_manager.dart';
import '../../../l10n/app_strings.dart';
import '../../../theme/app_colors.dart';
import '../../models/progress_model.dart';

class CreditsSummary extends StatelessWidget {
  final ProgressModel progress;

  const CreditsSummary({
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
                Text(
                  strings.totalCredits,
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
                    '${strings.total}: ${progress.totalCredits} ${strings.credits}',
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
            _buildCreditRow(
              strings.requiredCredits,
              progress.completedRequiredCredits,
              progress.inProgressRequiredCredits,
              progress.registeringRequiredCredits,
              progress.totalRequiredCredits,
              AppColors.primary,
              strings,
            ),
            const SizedBox(height: 12),
            _buildCreditRow(
              strings.optionalCredits,
              progress.completedOptionalCredits,
              progress.inProgressOptionalCredits,
              progress.registeringOptionalCredits,
              progress.totalOptionalCredits,
              AppColors.secondary,
              strings,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: AppColors.divider),
            ),
            _buildCreditRow(
              strings.totalCredits,
              progress.completedCredits,
              progress.inProgressCredits,
              progress.totalRegisteringCredits,
              progress.totalCredits,
              AppColors.info,
              strings,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditRow(
    String title,
    int completed,
    int inProgress,
    int registering,
    int total,
    Color color,
    AppStrings strings, {
    bool isTotal = false,
  }) {
    final double progress = total > 0 ? (completed + inProgress + registering) / total : 0;
    final remaining = total - completed - inProgress - registering;

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
                text: '$completed',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (inProgress > 0)
                TextSpan(
                  text: ' (+$inProgress)',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              if (registering > 0)
                TextSpan(
                  text: ' (+$registering)',
                  style: TextStyle(
                    color: AppColors.info,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              TextSpan(text: '/$total ${strings.credits}'),
              if (remaining > 0)
                TextSpan(
                  text: ' • ${strings.remainingCredits}: $remaining',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
} 