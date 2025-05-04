import 'package:flutter/foundation.dart';
import 'course.dart';

//Nhiều môn học chọn 1
class Subsection with ChangeNotifier {
  final String name;
  final String id;
  final List<Course> courses = [];

  Subsection(this.name, {String? id}) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  int get totalCredits => courses.fold(0, (sum, course) => sum + course.credits);
  int get requiredCredits => courses.fold(0, (sum, course) => sum + (course.type == CourseType.required ? course.credits : 0));
  int get optionalCredits => courses.fold(0, (sum, course) => sum + (course.type == CourseType.optional ? course.credits : 0));
  int get completedCredits => courses.fold(0, (sum, course) => sum + (course.isCompleted ? course.credits : 0));
  int get remainingCredits => requiredCredits - completedCredits;
  double get progress => requiredCredits > 0 ? completedCredits / requiredCredits : 0;

  void addCourse(String name, int credits) {
    courses.add(Course(
      name: name,
      credits: credits,
    ));
    notifyListeners();
  }

  void removeCourse(Course course) {
    courses.remove(course);
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'courses': courses.map((course) => course.toJson()).toList(),
    };
  }

  factory Subsection.fromJson(Map<String, dynamic> json) {
    final subsection = Subsection(json['name'], id: json['id']);
    if (json['courses'] != null) {
      for (var courseJson in json['courses']) {
        subsection.courses.add(Course.fromJson(courseJson));
      }
    }
    return subsection;
  }
} 