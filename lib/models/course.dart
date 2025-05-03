import 'package:flutter/foundation.dart';

enum CourseType {
  required,
  optional,
}

enum CourseStatus {
  notStarted,
  inProgress,
  completed,
  failed,
}

class Course with ChangeNotifier {
  final String name;
  final String id;
  final int credits;
  final CourseType type;
  final CourseStatus status;
  bool _isCompleted = false;
  double? _grade;
  final List<String> prerequisiteCourses;

  Course({
    required this.name,
    required this.credits,
    String? id,
    this.type = CourseType.required,
    this.status = CourseStatus.notStarted,
    double? grade,
    List<String>? prerequisiteCourses,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       _grade = grade,
       prerequisiteCourses = prerequisiteCourses ?? [];

  bool get isCompleted => _isCompleted;
  double? get grade => _grade;
  bool get isPassed => _grade != null && _grade! >= 5.0;

  void toggleCompleted() {
    _isCompleted = !_isCompleted;
    notifyListeners();
  }

  void setGrade(double grade) {
    _grade = grade;
    notifyListeners();
  }

  void addPrerequisite(String courseId) {
    if (!prerequisiteCourses.contains(courseId)) {
      prerequisiteCourses.add(courseId);
      notifyListeners();
    }
  }

  void removePrerequisite(String courseId) {
    prerequisiteCourses.remove(courseId);
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'credits': credits,
      'type': type.toString(),
      'status': status.toString(),
      'isCompleted': _isCompleted,
      'grade': _grade,
      'prerequisiteCourses': prerequisiteCourses,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'],
      id: json['id'],
      credits: json['credits'],
      type: CourseType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => CourseType.required,
      ),
      status: CourseStatus.values.firstWhere(
        (status) => status.toString() == json['status'],
        orElse: () => CourseStatus.notStarted,
      ),
      grade: json['grade'],
      prerequisiteCourses: (json['prerequisiteCourses'] as List<dynamic>?)?.cast<String>() ?? [],
    ).._isCompleted = json['isCompleted'] ?? false;
  }
} 