import 'dart:convert';

class PlannedCourseRef {
  final String courseId;
  final int credits;

  PlannedCourseRef({required this.courseId, required this.credits});

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'credits': credits,
      };

  factory PlannedCourseRef.fromJson(Map<String, dynamic> json) =>
      PlannedCourseRef(
        courseId: json['courseId'] as String,
        credits: (json['credits'] as num).toInt(),
      );
}

class SemesterPlan {
  final String id;
  final String term; // e.g. 'HK1', 'HK2', 'HK Hè'
  final int year; // e.g. 2025
  final List<PlannedCourseRef> plannedCourses;
  final String? note;
  final String? schedule; // simple text schedule placeholder
  final int creditLimit; // Giới hạn tín chỉ cho học kỳ này

  SemesterPlan({
    required this.id,
    required this.term,
    required this.year,
    List<PlannedCourseRef>? plannedCourses,
    this.note,
    this.schedule,
    this.creditLimit = 20, // Default 20 tín chỉ
  }) : plannedCourses = plannedCourses ?? [];

  int get totalCredits =>
      plannedCourses.fold(0, (sum, c) => sum + c.credits);

  Map<String, dynamic> toJson() => {
        'id': id,
        'term': term,
        'year': year,
        'plannedCourses': plannedCourses.map((e) => e.toJson()).toList(),
        'note': note,
        'schedule': schedule,
        'creditLimit': creditLimit,
      };

  factory SemesterPlan.fromJson(Map<String, dynamic> json) => SemesterPlan(
        id: json['id'] as String,
        term: json['term'] as String,
        year: (json['year'] as num).toInt(),
        plannedCourses: (json['plannedCourses'] as List<dynamic>? ?? [])
            .map((e) => PlannedCourseRef.fromJson(e as Map<String, dynamic>))
            .toList(),
        note: json['note'] as String?,
        schedule: json['schedule'] as String?,
        creditLimit: (json['creditLimit'] as num?)?.toInt() ?? 20,
      );
}

String encodePlans(List<SemesterPlan> plans) => json.encode(
      plans.map((p) => p.toJson()).toList(),
    );

List<SemesterPlan> decodePlans(String jsonStr) {
  final list = json.decode(jsonStr) as List<dynamic>;
  return list
      .map((e) => SemesterPlan.fromJson(e as Map<String, dynamic>))
      .toList();
}


