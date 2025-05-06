import 'package:flutter/foundation.dart';
import 'course.dart';
import 'course_group.dart';

//Khối kiến thức
class Section with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final int requiredCredits;
  final int optionalCredits;
  final List<CourseGroup> courseGroups;

  Section({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredCredits,
    required this.optionalCredits,
    required this.courseGroups,
  });

  List<Course> get allCourses => courseGroups.expand((group) => group.courses).toList();

  int get totalCredits => requiredCredits + optionalCredits;

  int get completedCredits => allCourses.fold(
      0, (sum, course) => sum + (course.isCompleted ? course.credits : 0));

  int get remainingCredits => totalCredits - completedCredits;

  double get progress =>
      requiredCredits > 0 ? completedCredits / requiredCredits : 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'requiredCredits': requiredCredits,
      'optionalCredits': optionalCredits,
      'courseGroups': courseGroups.map((group) => group.toJson()).toList(),
    };
  }

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      requiredCredits: json['requiredCredits'],
      optionalCredits: json['optionalCredits'],
      courseGroups: (json['courseGroups'] as List)
          .map((groupJson) => CourseGroup.fromJson(groupJson))
          .toList(),
    );
  }
}
