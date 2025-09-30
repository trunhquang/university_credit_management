import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/course.dart';
import 'models.dart';

class PlanningValidationResult {
  final bool canAdd;
  final bool willExceedLimit;
  final List<String> missingPrerequisites;
  final int currentCredits;
  final int limit;

  PlanningValidationResult({
    required this.canAdd,
    required this.willExceedLimit,
    required this.missingPrerequisites,
    required this.currentCredits,
    required this.limit,
  });
}

class PlanningService {
  static const String _storageKey = 'semester_plans';
  static const int defaultCreditLimit = 20;

  Future<List<SemesterPlan>> loadPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    return decodePlans(raw);
  }

  Future<void> savePlans(List<SemesterPlan> plans) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, encodePlans(plans));
  }

  /// Thêm 1 môn vào kế hoạch nếu chưa có và trả về list mới
  List<SemesterPlan> addCourse(
    List<SemesterPlan> plans,
    String planId,
    Course course,
  ) {
    final idx = plans.indexWhere((p) => p.id == planId);
    if (idx == -1) return plans;
    final plan = plans[idx];

    final exists = plan.plannedCourses.any((c) => c.courseId == course.id);
    if (exists) return plans;

    final updatedPlan = SemesterPlan(
      id: plan.id,
      term: plan.term,
      year: plan.year,
      plannedCourses: [
        ...plan.plannedCourses,
        PlannedCourseRef(courseId: course.id, credits: course.credits),
      ],
    );

    final newPlans = [...plans];
    newPlans[idx] = updatedPlan;
    return newPlans;
  }

  /// Xóa 1 môn khỏi kế hoạch và trả về list mới
  List<SemesterPlan> removeCourse(
    List<SemesterPlan> plans,
    String planId,
    String courseId,
  ) {
    final idx = plans.indexWhere((p) => p.id == planId);
    if (idx == -1) return plans;
    final plan = plans[idx];

    final updatedPlan = SemesterPlan(
      id: plan.id,
      term: plan.term,
      year: plan.year,
      plannedCourses:
          plan.plannedCourses.where((c) => c.courseId != courseId).toList(),
    );

    final newPlans = [...plans];
    newPlans[idx] = updatedPlan;
    return newPlans;
  }

  /// Validate việc thêm 1 môn vào học kỳ theo giới hạn tín chỉ và prerequisite
  PlanningValidationResult validateAddCourse(
    List<SemesterPlan> plans,
    String planId,
    Course course,
    Set<String> completedCourseIds, {
    int creditLimit = defaultCreditLimit,
  }) {
    final idx = plans.indexWhere((p) => p.id == planId);
    if (idx == -1) {
      return PlanningValidationResult(
        canAdd: false,
        willExceedLimit: false,
        missingPrerequisites: const [],
        currentCredits: 0,
        limit: creditLimit,
      );
    }
    final plan = plans[idx];
    final current = plan.totalCredits;

    final willExceed = (current + course.credits) > creditLimit;
    final missing = course.prerequisiteCourses
        .where((id) => !completedCourseIds.contains(id))
        .toList();

    final canAdd = !willExceed;

    return PlanningValidationResult(
      canAdd: canAdd,
      willExceedLimit: willExceed,
      missingPrerequisites: missing,
      currentCredits: current,
      limit: creditLimit,
    );
  }

  /// Gợi ý các môn có thể học kỳ tới: chưa hoàn thành, không thiếu tiên quyết, ưu tiên required
  List<Course> suggestNextCourses(
    List<Course> allCourses,
    Set<String> completedCourseIds, {
    int maxSuggestions = 8,
  }) {
    // only consider courses not started (exclude inProgress/registering/etc.)
    final remaining = allCourses.where((c) => !completedCourseIds.contains(c.id) && c.status == CourseStatus.notStarted).toList();
    final eligible = remaining.where((c) {
      return c.prerequisiteCourses.every((id) => completedCourseIds.contains(id));
    }).toList();

    eligible.sort((a, b) {
      // required trước, sau đó credits giảm dần, rồi theo tên
      final typeCmp = (a.type == CourseType.required && b.type != CourseType.required)
          ? -1
          : (a.type != CourseType.required && b.type == CourseType.required)
              ? 1
              : 0;
      if (typeCmp != 0) return typeCmp;
      final creditCmp = b.credits.compareTo(a.credits);
      if (creditCmp != 0) return creditCmp;
      return a.name.compareTo(b.name);
    });

    return eligible.take(maxSuggestions).toList();
  }

  List<SemesterPlan> updatePlanMeta(
    List<SemesterPlan> plans,
    String planId, {
    String? note,
    String? schedule,
  }) {
    final idx = plans.indexWhere((p) => p.id == planId);
    if (idx == -1) return plans;
    final old = plans[idx];
    final updated = SemesterPlan(
      id: old.id,
      term: old.term,
      year: old.year,
      plannedCourses: old.plannedCourses,
      note: note ?? old.note,
      schedule: schedule ?? old.schedule,
    );
    final newPlans = [...plans];
    newPlans[idx] = updated;
    return newPlans;
  }
}


