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
    return IconButton(
      icon: Text(
        getLanguageFlag(currentLanguageCode),
        style: const TextStyle(fontSize: 20),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Chọn ngôn ngữ'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Text(
                    getLanguageFlag('vi'),
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: const Text('Tiếng Việt'),
                  onTap: () {
                    onLanguageChanged('vi');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Text(
                    getLanguageFlag('en'),
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: const Text('English'),
                  onTap: () {
                    onLanguageChanged('en');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
      color: Colors.white,
    );
  }
} 