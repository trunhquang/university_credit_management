import 'package:flutter/foundation.dart';
import '../models/category.dart' as models;
import '../repositories/curriculum_repository.dart';

class CurriculumState extends ChangeNotifier {
  final CurriculumRepository _repo = CurriculumRepository();
  late final List<models.Category> categories = _repo.loadCategories();
  final Map<String, bool> _completed = {};

  Future<void> load() async {
    _completed.addAll(await _repo.loadCompletion());
    notifyListeners();
  }

  Future<void> toggleCourse(String code, bool done) async {
    _completed[code] = done;
    await _repo.saveCompletion(code, done);
    notifyListeners();
  }

  bool isDone(String code) => _completed[code] ?? false;

  int earnedCreditsIn(models.Category cat) {
    int sum = 0;
    for (final c in cat.courses) {
      if (isDone(c.code)) sum += c.credits;
    }
    return sum;
  }

  int get totalRequired => categories.fold<int>(0, (a, c) => a + c.requiredCredits);

  int get totalEarned => categories.fold<int>(0, (a, c) => a + earnedCreditsIn(c).clamp(0, c.requiredCredits));

  bool get eligibleToGraduate => categories.every((c) => earnedCreditsIn(c) >= c.requiredCredits);
}


