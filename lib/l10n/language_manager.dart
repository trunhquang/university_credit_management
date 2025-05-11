import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_strings.dart';
import 'strings_en.dart';
import 'strings_vi.dart';

class LanguageManager extends ChangeNotifier {
  static final LanguageManager _instance = LanguageManager._internal();
  factory LanguageManager() => _instance;
  LanguageManager._internal();

  static const String _languageKey = 'selected_language';

  AppStrings _currentStrings = EnglishStrings();
  String _currentLanguage = 'English';
  String _currentLanguageCode = 'vi';

  AppStrings get currentStrings => _currentStrings;
  String get currentLanguage => _currentLanguage;
  String get currentLanguageCode => _currentLanguageCode;

  final Map<String, Map<String, String>> _languages = {
    'en': {
      'name': 'English',
      'flag': '🇺🇸',
    },
    'vi': {
      'name': 'Tiếng Việt',
      'flag': '🇻🇳',
    },
  };

  List<Map<String, String>> get languageOptions => _languages.values.toList();

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    if (savedLanguage != null) {
      await changeLanguage(savedLanguage);
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    switch (languageCode) {
      case 'en':
        _currentStrings = EnglishStrings();
        _currentLanguage = _languages['en']!['name']!;
        _currentLanguageCode = 'en';
        break;
      case 'vi':
        _currentStrings = VietnameseStrings();
        _currentLanguage = _languages['vi']!['name']!;
        _currentLanguageCode = 'vi';
        break;
    }

    // Save the selected language
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);

    notifyListeners();
  }

  String getLanguageFlag(String languageCode) {
    return _languages[languageCode]?['flag'] ?? '🌐';
  }
} 