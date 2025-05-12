import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/language_manager.dart';
import '../models/progress_model.dart';
import '../theme/app_colors.dart';

class ProgramOverview extends StatelessWidget {
  final ProgressModel? progress;
  final double gpa;
  final Map<String, dynamic>? englishCert;

  const ProgramOverview({
    super.key,
    required this.progress,
    required this.gpa,
    required this.englishCert,
  });

  @override
  Widget build(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(context);
    final percentage = progress?.percentage ?? 0;
    final totalCredits = progress?.totalCredits ?? 0;
    final completedCredits = progress?.completedCredits ?? 0;

    // Get credits by status and type
    final completedRequiredCredits = progress?.completedRequiredCredits ?? 0;
    final completedOptionalCredits = progress?.completedOptionalCredits ?? 0;
    final inProgressRequiredCredits = progress?.inProgressRequiredCredits ?? 0;
    final inProgressOptionalCredits = progress?.inProgressOptionalCredits ?? 0;
    final registeringRequiredCredits = progress?.registeringRequiredCredits ?? 0;
    final registeringOptionalCredits = progress?.registeringOptionalCredits ?? 0;
    final needToRegisterRequiredCredits = progress?.needToRegisterRequiredCredits ?? 0;
    final needToRegisterOptionalCredits = progress?.needToRegisterOptionalCredits ?? 0;
    final notStartedRequiredCredits = progress?.notStartedRequiredCredits ?? 0;
    final notStartedOptionalCredits = progress?.notStartedOptionalCredits ?? 0;
    final failedRequiredCredits = progress?.failedRequiredCredits ?? 0;
    final failedOptionalCredits = progress?.failedOptionalCredits ?? 0;
    final totalRequiredCredits = progress?.totalRequiredCredits ?? 0;
    final totalOptionalCredits = progress?.totalOptionalCredits ?? 0;

    // Calculate total credits by status
    final totalInProgressCredits = inProgressRequiredCredits + inProgressOptionalCredits;
    final totalRegisteringCredits = registeringRequiredCredits + registeringOptionalCredits;
    final totalNeedToRegisterCredits = needToRegisterRequiredCredits + needToRegisterOptionalCredits;
    final totalNotStartedCredits = notStartedRequiredCredits + notStartedOptionalCredits;
    final totalFailedCredits = failedRequiredCredits + failedOptionalCredits;

    // Get course counts by status
    final completedCourses = progress?.completedCourses ?? 0;
    final inProgressCourses = progress?.inProgressCourses ?? 0;
    final registeringCourses = progress?.registeringCourses ?? 0;
    final needToRegisterCourses = progress?.needToRegisterCourses ?? 0;
    final notStartedCourses = progress?.notStartedCourses ?? 0;
    final failedCourses = progress?.failedCourses ?? 0;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageManager.currentStrings.programOverview,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(languageManager.currentStrings.gpa),
                Text(
                  gpa.toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.progressBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage >= 100 ? AppColors.success : AppColors.progressValue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${languageManager.currentStrings.completionProgress}: ${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: percentage >= 100 ? AppColors.success : AppColors.progressValue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Course status summary
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (completedCourses > 0)
                  _buildStatusChip(
                    AppColors.success,
                    '${languageManager.currentStrings.completed}: $completedCourses (${completedCredits ?? 0} ${languageManager.currentStrings.credits})',
                  ),
                if (inProgressCourses > 0)
                  _buildStatusChip(
                    AppColors.primary,
                    '${languageManager.currentStrings.inProgress}: $inProgressCourses ($totalInProgressCredits ${languageManager.currentStrings.credits})',
                  ),
                if (registeringCourses > 0)
                  _buildStatusChip(
                    AppColors.info,
                    '${languageManager.currentStrings.registering}: $registeringCourses ($totalRegisteringCredits ${languageManager.currentStrings.credits})',
                  ),
                if (needToRegisterCourses > 0)
                  _buildStatusChip(
                    AppColors.warning,
                    '${languageManager.currentStrings.needToRegister}: $needToRegisterCourses ($totalNeedToRegisterCredits ${languageManager.currentStrings.credits})',
                  ),
                if (notStartedCourses > 0)
                  _buildStatusChip(
                    AppColors.textSecondary,
                    '${languageManager.currentStrings.notStarted}: $notStartedCourses ($totalNotStartedCredits ${languageManager.currentStrings.credits})',
                  ),
                if (failedCourses > 0)
                  _buildStatusChip(
                    AppColors.error,
                    '${languageManager.currentStrings.failed}: $failedCourses ($totalFailedCredits ${languageManager.currentStrings.credits})',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionTitle(languageManager.currentStrings.credits),
            const SizedBox(height: 8),
            if (totalRequiredCredits > 0) ...[
              _buildDetailedCreditInfo(
                context,
                languageManager.currentStrings.requiredCredits,
                totalRequiredCredits,
                completedRequiredCredits,
                inProgressRequiredCredits,
                registeringRequiredCredits,
              ),
              const SizedBox(height: 8),
            ],
            if (totalOptionalCredits > 0) ...[
              _buildDetailedCreditInfo(
                context,
                languageManager.currentStrings.optionalCredits,
                totalOptionalCredits,
                completedOptionalCredits,
                inProgressOptionalCredits,
                registeringOptionalCredits,
              ),
              const SizedBox(height: 8),
            ],
            _buildDetailedCreditInfo(
              context,
              languageManager.currentStrings.totalCredits,
              totalCredits ?? 0,
              completedCredits ?? 0,
              totalInProgressCredits,
              totalRegisteringCredits,
              isTotal: true,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle(languageManager.currentStrings.englishCertificate),
            const SizedBox(height: 8),
            _buildEnglishCertInfo(languageManager),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedCreditInfo(
    BuildContext context,
    String label,
    int totalCredits,
    int completedCredits,
    int inProgressCredits,
    int registeringCredits, {
    bool isTotal = false,
  }) {
    final languageManager = Provider.of<LanguageManager>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '$completedCredits',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (inProgressCredits > 0)
                TextSpan(
                  text: ' (+$inProgressCredits)',
                  style: TextStyle(
                    color: AppColors.progressInProgress,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              if (registeringCredits > 0)
                TextSpan(
                  text: ' (+$registeringCredits)',
                  style: TextStyle(
                    color: AppColors.info,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              TextSpan(
                text: '/$totalCredits ${languageManager.currentStrings.credits}',
                style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? AppColors.primary : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEnglishCertInfo(LanguageManager languageManager) {
    final certType = englishCert?['type'] as String?;
    final currentScore = englishCert?['score'] as int?;
    final requiredScore = englishCert?['required'] as int?;
    final bool isPassed = currentScore != null && currentScore >= (requiredScore ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${languageManager.currentStrings.certificateType}: $certType'),
            Icon(
              isPassed ? Icons.check_circle : Icons.warning,
              color: isPassed ? AppColors.success : AppColors.warning,
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(languageManager.currentStrings.requiredScore),
            Text(
              requiredScore.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(languageManager.currentStrings.achievedScore),
            Text(
              currentScore?.toString() ?? languageManager.currentStrings.noCertificate,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: currentScore == null 
                    ? AppColors.textSecondary
                    : (isPassed ? AppColors.success : AppColors.error),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 