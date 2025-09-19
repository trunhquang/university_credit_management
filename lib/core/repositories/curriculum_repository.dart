import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../data/seed.dart';

class CurriculumRepository {
  List<Category> loadCategories() => seedCategories();

  Future<Map<String, bool>> loadCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    final result = <String, bool>{};
    for (final k in prefs.getKeys()) {
      final v = prefs.getBool(k);
      if (v != null) result[k] = v;
    }
    return result;
  }

  Future<void> saveCompletion(String code, bool done) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(code, done);
  }
}


