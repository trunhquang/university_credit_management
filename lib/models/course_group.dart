import 'course.dart';

class CourseGroup {
  final String id;
  final String name;
  final String description;
  final int requiredCredits;
  final int optionalCredits;
  final List<Course> courses;
  final bool isCompleted;

  CourseGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredCredits,
    required this.optionalCredits,
    required this.courses,
    this.isCompleted = false,
  });

  CourseGroup copyWith({
    String? id,
    String? name,
    String? description,
    int? requiredCredits,
    int? optionalCredits,
    List<Course>? courses,
    bool? isCompleted,
  }) {
    return CourseGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      requiredCredits: requiredCredits ?? this.requiredCredits,
      optionalCredits: optionalCredits ?? this.optionalCredits,
      courses: courses ?? this.courses,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'requiredCredits': requiredCredits,
      'optionalCredits': optionalCredits,
      'courses': courses.map((course) => course.toJson()).toList(),
      'isCompleted': isCompleted,
    };
  }

  factory CourseGroup.fromJson(Map<String, dynamic> json) {
    return CourseGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      requiredCredits: json['requiredCredits'] as int,
      optionalCredits: json['optionalCredits'] as int,
      courses: (json['courses'] as List)
          .map((course) => Course.fromJson(course as Map<String, dynamic>))
          .toList(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
} 