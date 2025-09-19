import 'course.dart';

class Semester {
  final String id;
  final String name;
  final List<Course> registeredCourses;

  Semester({
    required this.id,
    required this.name,
    this.registeredCourses = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'registeredCourses': registeredCourses.map((course) => course.toJson()).toList(),
    };
  }

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['id'] as String,
      name: json['name'] as String,
      registeredCourses: (json['registeredCourses'] as List)
          .map((courseJson) => Course.fromJson(courseJson))
          .toList(),
    );
  }
} 