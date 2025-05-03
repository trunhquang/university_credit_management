import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LanguageDropdown extends StatelessWidget {
  final String currentLanguageCode;
  final String currentLanguage;
  final String Function(String) getLanguageFlag;
  final void Function(String) onLanguageChanged;

  const LanguageDropdown({
    super.key,
    required this.currentLanguageCode,
    required this.currentLanguage,
    required this.getLanguageFlag,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Row(
        children: [
          Text(
            getLanguageFlag(currentLanguageCode),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 4),
          Text(
            currentLanguage,
            style: TextStyle(
              color: AppColors.onPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
      onSelected: onLanguageChanged,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              Text(
                getLanguageFlag('en'),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              const Text('English'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'vi',
          child: Row(
            children: [
              Text(
                getLanguageFlag('vi'),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              const Text('Tiếng Việt'),
            ],
          ),
        ),
      ],
    );
  }
} 