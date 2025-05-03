import 'package:flutter/material.dart';

class ProgramOverview extends StatelessWidget {
  final Map<String, dynamic> progress;
  final double gpa;
  final Map<String, dynamic> englishCert;

  const ProgramOverview({
    super.key,
    required this.progress,
    required this.gpa,
    required this.englishCert,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress['percentage'] as num).toDouble();
    final totalCredits = progress['totalCredits'] as int;
    final completedCredits = progress['completedCredits'] as int;
    final remainingCredits = progress['remainingCredits'] as int;

    final inProgressCredits = (progress['inProgressCredits'] as int?) ?? 0;
    final completedRequiredCredits = (progress['completedRequiredCredits'] as int?) ?? 0;
    final completedOptionalCredits = (progress['completedOptionalCredits'] as int?) ?? 0;
    final inProgressRequiredCredits = (progress['inProgressRequiredCredits'] as int?) ?? 0;
    final inProgressOptionalCredits = (progress['inProgressOptionalCredits'] as int?) ?? 0;
    final totalRequiredCredits = (progress['totalRequiredCredits'] as int?) ?? 0;
    final totalOptionalCredits = (progress['totalOptionalCredits'] as int?) ?? 0;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tổng quan chương trình',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Điểm trung bình:'),
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
              'Tiến độ hoàn thành: ${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: percentage >= 100 ? Colors.green : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Tín chỉ'),
            const SizedBox(height: 8),
            if (totalRequiredCredits > 0) ...[
              _buildDetailedCreditInfo(
                'Tín chỉ bắt buộc:',
                totalRequiredCredits,
                completedRequiredCredits,
                inProgressRequiredCredits,
              ),
              const SizedBox(height: 8),
            ],
            if (totalOptionalCredits > 0) ...[
              _buildDetailedCreditInfo(
                'Tín chỉ tự chọn:',
                totalOptionalCredits,
                completedOptionalCredits,
                inProgressOptionalCredits,
              ),
              const SizedBox(height: 8),
            ],
            _buildDetailedCreditInfo(
              'Tổng số tín chỉ:',
              totalCredits,
              completedCredits,
              inProgressCredits,
              isTotal: true,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Chứng chỉ tiếng Anh'),
            const SizedBox(height: 8),
            _buildEnglishCertInfo(),
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
    String label,
    int totalCredits,
    int completedCredits,
    int inProgressCredits, {
    bool isTotal = false,
  }) {
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
                text: '/$totalCredits tín chỉ',
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

  Widget _buildEnglishCertInfo() {
    final certType = englishCert['type'] as String;
    final currentScore = englishCert['score'] as int?;
    final requiredScore = englishCert['required'] as int;
    final bool isPassed = currentScore != null && currentScore >= requiredScore;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Loại chứng chỉ: $certType'),
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
            const Text('Điểm yêu cầu:'),
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
            const Text('Điểm đạt được:'),
            Text(
              currentScore?.toString() ?? 'Chưa có',
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