import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/language_manager.dart';
import '../../../l10n/app_strings.dart';
import '../../../theme/app_colors.dart';

class GPACard extends StatelessWidget {
  final double gpa;

  const GPACard({
    super.key,
    required this.gpa,
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
        child: Row(
          children: [
            const Icon(Icons.school, size: 48, color: AppColors.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.gpa,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  gpa.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
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