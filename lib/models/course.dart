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
  registering,    // Đang đăng ký
  needToRegister, // Cần đăng ký
}

//Môn học
class Course with ChangeNotifier {
  final String name;
  final String id;
  final int credits;
  final CourseType type;
  final CourseStatus status;
  bool _isCompleted = false;
  double? _score;
  final List<String> prerequisiteCourses;

  Course({
    required this.name,
    required this.credits,
    required String? id,
    this.type = CourseType.required,
    this.status = CourseStatus.notStarted,
    double? score,
    List<String>? prerequisiteCourses,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        _score = score,
        prerequisiteCourses = prerequisiteCourses ?? [];

  bool get isCompleted => status == CourseStatus.completed;

  double? get score => _score;

  bool get isPassed => _score != null && _score! >= 5.0;

  void setScore(double score) {
    _score = score;
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

  Course copyWith({
    String? name,
    String? id,
    int? credits,
    CourseType? type,
    CourseStatus? status,
    double? score,
    List<String>? prerequisiteCourses,
  }) {
    return Course(
      name: name ?? this.name,
      id: id ?? this.id,
      credits: credits ?? this.credits,
      type: type ?? this.type,
      status: status ?? this.status,
      score: score ?? _score,
      prerequisiteCourses: prerequisiteCourses ?? this.prerequisiteCourses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'credits': credits,
      'type': type.toString(),
      'status': status.toString(),
      'isCompleted': _isCompleted,
      'score': _score,
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
      score: json['score'],
      prerequisiteCourses:
          (json['prerequisiteCourses'] as List<dynamic>?)?.cast<String>() ?? [],
    ).._isCompleted = json['isCompleted'] ?? false;
  }
}
