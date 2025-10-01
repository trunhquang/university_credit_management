import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/state/curriculum_provider.dart';
import '../../../../core/navigation/app_router.dart';

class NotificationsBanner extends StatelessWidget {
  const NotificationsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CurriculumProvider>(
      builder: (context, provider, child) {
        final stats = provider.getOverallStatistics();
        final remaining = (stats['totalCredits'] as int) - (stats['completedCredits'] as int);
        final semesters = stats['estimatedSemestersRemaining'] as int;
        final canGraduate = stats['canGraduate'] as bool;

        final List<_BannerMessage> messages = [];

        if (!canGraduate && remaining > 0) {
          messages.add(_BannerMessage(
            icon: Icons.flag,
            color: Colors.orange,
            text: 'Còn $remaining tín chỉ, ước tính còn $semesters học kỳ để tốt nghiệp.',
            actionText: 'Lập kế hoạch',
            onTap: () => AppNavigation.goToPlanning(context),
          ));
        }

        final requiredRemaining = (stats['requiredTotal'] as int) - (stats['requiredCompleted'] as int);
        if (requiredRemaining > 0) {
          messages.add(_BannerMessage(
            icon: Icons.list_alt,
            color: Colors.red,
            text: 'Còn thiếu $requiredRemaining tín chỉ bắt buộc.',
            actionText: 'Xem khối kiến thức',
            onTap: () => AppNavigation.goToProgress(context),
          ));
        }

        if (messages.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            for (final m in messages)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: m.color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: m.color.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(m.icon, color: m.color, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        m.text,
                        style: TextStyle(color: m.color.shade700),
                      ),
                    ),
                    TextButton(
                      onPressed: m.onTap,
                      child: Text(m.actionText),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BannerMessage {
  final IconData icon;
  final MaterialColor color;
  final String text;
  final String actionText;
  final VoidCallback onTap;

  _BannerMessage({
    required this.icon,
    required this.color,
    required this.text,
    required this.actionText,
    required this.onTap,
  });
}


