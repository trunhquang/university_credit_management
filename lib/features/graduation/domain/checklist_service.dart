import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'checklist_models.dart';

class GraduationChecklistService {
  static const String _storageKey = 'graduation_checklist';

  Future<GraduationChecklist> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return defaultGraduationChecklist();
    }
    return GraduationChecklist.fromJson(json.decode(raw) as Map<String, dynamic>);
  }

  Future<void> save(GraduationChecklist data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, json.encode(data.toJson()));
  }
}


