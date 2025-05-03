import 'course.dart';

class Section {
  final String id;
  final String name;
  final int requiredCredits;
  final int optionalCredits;
  final List<Course> courses;
  final String description;

  Section({
    required this.id,
    required this.name,
    required this.requiredCredits,
    required this.optionalCredits,
    required this.courses,
    this.description = '',
  });

  int get completedCredits => courses
      .where((course) => course.isPassed)
      .fold(0, (sum, course) => sum + course.credits);

  int get remainingCredits => requiredCredits + optionalCredits - completedCredits;

  double get progress => (completedCredits / (requiredCredits + optionalCredits)) * 100;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'requiredCredits': requiredCredits,
      'optionalCredits': optionalCredits,
      'courses': courses.map((course) => course.toJson()).toList(),
      'description': description,
    };
  }

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      requiredCredits: json['requiredCredits'],
      optionalCredits: json['optionalCredits'],
      description: json['description'] ?? '',
      courses: (json['courses'] as List)
          .map((courseJson) => Course.fromJson(courseJson))
          .toList(),
    );
  }
} 