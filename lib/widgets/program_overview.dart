import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/language_manager.dart';

class ProgramOverview extends StatelessWidget {
  final Map<String, dynamic>? progress;
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
    final percentage = (progress?['percentage'] as num?)?.toDouble() ?? 0;
    final totalCredits = progress?['totalCredits'] as int?;
    final completedCredits = progress?['completedCredits'] as int?;

    final inProgressCredits = (progress?['inProgressCredits'] as int?) ?? 0;
    final completedRequiredCredits = (progress?['completedRequiredCredits'] as int?) ?? 0;
    final completedOptionalCredits = (progress?['completedOptionalCredits'] as int?) ?? 0;
    final inProgressRequiredCredits = (progress?['inProgressRequiredCredits'] as int?) ?? 0;
    final inProgressOptionalCredits = (progress?['inProgressOptionalCredits'] as int?) ?? 0;
    final totalRequiredCredits = (progress?['totalRequiredCredits'] as int?) ?? 0;
    final totalOptionalCredits = (progress?['totalOptionalCredits'] as int?) ?? 0;

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
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage >= 100 ? Colors.green : Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${languageManager.currentStrings.completionProgress}: ${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: percentage >= 100 ? Colors.green : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
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
              ),
              const SizedBox(height: 8),
            ],
            _buildDetailedCreditInfo(
              context,
              languageManager.currentStrings.totalCredits,
              totalCredits ?? 0,
              completedCredits ?? 0,
              inProgressCredits,
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
            color: Colors.blue,
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
    int inProgressCredits, {
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
                  color: Colors.green,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (inProgressCredits > 0)
                TextSpan(
                  text: ' (+$inProgressCredits)',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              TextSpan(
                text: '/$totalCredits ${languageManager.currentStrings.credits}',
                style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? Colors.blue : null,
                ),
              ),
            ],
          ),
        ),
      ],
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
              color: isPassed ? Colors.green : Colors.orange,
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
                    ? Colors.grey 
                    : (isPassed ? Colors.green : Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 