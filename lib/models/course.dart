enum CourseType {
  required,
  optional
}

enum CourseStatus {
  completed,
  inProgress,
  notStarted
}

class Course {
  final String id;
  final String name;
  final int credits;
  final double? grade;
  final bool isPassed;
  final CourseType type;
  final CourseStatus status;
  final String prerequisiteCourses; // Môn học tiên quyết

  Course({
    required this.id,
    required this.name,
    required this.credits,
    this.grade,
    required this.isPassed,
    required this.type,
    required this.status,
    this.prerequisiteCourses = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'credits': credits,
      'grade': grade,
      'isPassed': isPassed,
      'type': type.toString(),
      'status': status.toString(),
      'prerequisiteCourses': prerequisiteCourses,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      credits: json['credits'],
      grade: json['grade'],
      isPassed: json['isPassed'],
      type: CourseType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => CourseType.required,
      ),
      status: CourseStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => CourseStatus.notStarted,
      ),
      prerequisiteCourses: json['prerequisiteCourses'] ?? '',
    );
  }
} 