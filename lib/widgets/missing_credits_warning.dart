import 'package:flutter/material.dart';

class MissingCreditsWarning extends StatelessWidget {
  final Map<String, dynamic> missingCredits;

  const MissingCreditsWarning({
    super.key,
    required this.missingCredits,
  });

  @override
  Widget build(BuildContext context) {
    if (!missingCredits['hasMissingCredits']) {
      return const SizedBox.shrink();
    }

    final sections = List<Map<String, dynamic>>.from(
      (missingCredits['sections'] as List<dynamic>).map((section) {
        // Đảm bảo mỗi section là Map<String, dynamic>
        return Map<String, dynamic>.from(section);
      }),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Cảnh báo thiếu tín chỉ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...sections.map((section) => _buildSectionWarning(section)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionWarning(Map<String, dynamic> section) {
    // Đảm bảo các giá trị số được chuyển đổi sang int
    final requiredCredits = (section['requiredCredits'] as num?)?.toInt() ?? 0;
    final optionalCredits = (section['optionalCredits'] as num?)?.toInt() ?? 0;
    final completedRequired = (section['completedRequired'] as num?)?.toInt() ?? 0;
    final completedOptional = (section['completedOptional'] as num?)?.toInt() ?? 0;
    final inProgressRequired = (section['inProgressRequired'] as num?)?.toInt() ?? 0;
    final inProgressOptional = (section['inProgressOptional'] as num?)?.toInt() ?? 0;
    final missingRequired = (section['missingRequired'] as num?)?.toInt() ?? 0;
    final missingOptional = (section['missingOptional'] as num?)?.toInt() ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section['name']?.toString() ?? 'Không có tên',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          if (requiredCredits > 0)
            _buildCreditInfo(
              'Tín chỉ bắt buộc',
              requiredCredits,
              completedRequired,
              inProgressRequired,
              missingRequired,
            ),
          if (optionalCredits > 0) ...[
            const SizedBox(height: 4),
            _buildCreditInfo(
              'Tín chỉ tự chọn',
              optionalCredits,
              completedOptional,
              inProgressOptional,
              missingOptional,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCreditInfo(
    String label,
    int total,
    int completed,
    int inProgress,
    int missing,
  ) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: '$completed',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (inProgress > 0)
            TextSpan(
              text: ' (+$inProgress)',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          TextSpan(text: '/$total'),
          if (missing > 0)
            TextSpan(
              text: ' (còn thiếu $missing)',
              style: const TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
} 