import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'grad_profile_models.dart';

class GraduationProfileService {
  static const String _key = 'graduation_profile_v1';

  Future<GraduationProfile> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return defaultGraduationProfile();
    return GraduationProfile.fromJson(json.decode(raw) as Map<String, dynamic>);
  }

  Future<void> save(GraduationProfile data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(data.toJson()));
  }
}


