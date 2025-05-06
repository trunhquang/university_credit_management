import 'course.dart';

class CourseGroup {
  final String id;
  final String name;
  final String description;
  final int requiredCredits;
  final int optionalCredits;
  final List<Course> courses;

  CourseGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredCredits,
    required this.optionalCredits,
    required this.courses,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'requiredCredits': requiredCredits,
      'optionalCredits': optionalCredits,
      'courses': courses.map((course) => course.toJson()).toList(),
    };
  }

  factory CourseGroup.fromJson(Map<String, dynamic> json) {
    return CourseGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      requiredCredits: json['requiredCredits'],
      optionalCredits: json['optionalCredits'],
      courses: (json['courses'] as List)
          .map((courseJson) => Course.fromJson(courseJson))
          .toList(),
    );
  }
} 