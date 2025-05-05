import 'package:flutter/foundation.dart';
import 'course.dart';

//Khối kiến thức
class Section with ChangeNotifier {
  final String name;
  final String id;
  final int requiredCredits;
  final int optionalCredits;
  final String description;

  final List<Course> courses;

  Section(
      {required this.name,
      required this.requiredCredits,
      required this.optionalCredits,
      required this.description,
      this.courses = const [],
      String? id})
      : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  int get totalCredits => requiredCredits + optionalCredits;

  int get completedCredits => courses.fold(
      0, (sum, course) => sum + (course.isCompleted ? course.credits : 0));

  int get remainingCredits => totalCredits - completedCredits;

  double get progress =>
      requiredCredits > 0 ? completedCredits / requiredCredits : 0;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'requiredCredits': requiredCredits,
      'optionalCredits': optionalCredits,
      'description': description,
      'courses': courses.map((course) => course.toJson()).toList(),
    };
  }

  factory Section.fromJson(Map<String, dynamic> json) {
    List<Course> courses = [];
    if (json['courses'] != null) {
      for (var courseJson in json['courses']) {
        courses.add(Course.fromJson(courseJson));
      }
    }
    final section = Section(
      name: json['name'],
      requiredCredits: json['requiredCredits'],
      optionalCredits: json['optionalCredits'],
      description: json['description'],
      id: json['id'],
      courses: courses,
    );

    return section;
  }
}
