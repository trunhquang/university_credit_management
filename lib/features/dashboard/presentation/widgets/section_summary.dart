import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/state/curriculum_provider.dart';
import '../../../../core/navigation/app_router.dart';

class SectionSummary extends StatelessWidget {
  const SectionSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CurriculumProvider>(
      builder: (context, provider, child) {
        final sectionProgress = provider.progressModel.getSectionProgress();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Tiến độ khối kiến thức',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => AppNavigation.goToProgress(context),
                    child: const Text('Xem chi tiết'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...sectionProgress.values.map((progress) => 
                _buildSectionProgress(context, progress)
              ).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionProgress(BuildContext context, progress) {
    final progressPercentage = progress.progressPercentage;
    final completedCredits = progress.completedCredits;
    final totalCredits = progress.totalCredits;
    
    // Màu sắc dựa trên tiến độ
    Color progressColor;
    if (progressPercentage >= 100) {
      progressColor = Colors.green;
    } else if (progressPercentage >= 75) {
      progressColor = Colors.blue;
    } else if (progressPercentage >= 50) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  progress.sectionName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '$completedCredits/$totalCredits',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${progressPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: progressColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressPercentage / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 6,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildStatusChip(
                'Đã học',
                progress.completedCredits,
                Colors.green,
              ),
              const SizedBox(width: 8),
              _buildStatusChip(
                'Đang học',
                progress.inProgressCredits,
                Colors.orange,
              ),
              const SizedBox(width: 8),
              _buildStatusChip(
                'Chưa học',
                progress.notStartedCredits,
                Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, int credits, Color color) {
    if (credits == 0) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$credits $label',
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
