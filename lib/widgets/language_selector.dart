import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_language.dart';
import '../providers/language_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage;

    return DropdownButton<AppLanguage>(
      value: currentLanguage,
      onChanged: (AppLanguage? newLanguage) {
        if (newLanguage != null) {
          languageProvider.setLanguage(newLanguage);
        }
      },
      items: AppLanguage.values.map((AppLanguage language) {
        return DropdownMenuItem<AppLanguage>(
          value: language,
          child: Text(
            language == AppLanguage.vietnamese ? 'Tiếng Việt' : 'English',
          ),
        );
      }).toList(),
    );
  }
} 