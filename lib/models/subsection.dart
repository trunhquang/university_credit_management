import 'package:flutter/foundation.dart';
import 'course.dart';

//Nhiều môn học chọn 1
class Subsection with ChangeNotifier {
  final String name;
  final String id;
  final int requiredCredits;

  final List<Course> courses = [];

  Course? get selectedCourse {
    try {
      return courses.firstWhere(
        (course) => (course.status == CourseStatus.inProgress ||
            course.status == CourseStatus.completed),
      );
    } catch (e) {
      return null;
    }
  }

  Subsection(this.name, this.requiredCredits, {String? id})
      : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  int get completedCredits => courses.fold(
      0, (sum, course) => sum + (course.isCompleted ? course.credits : 0));

  int get remainingCredits => requiredCredits - completedCredits;

  double get progress =>
      requiredCredits > 0 ? completedCredits / requiredCredits : 0;

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
      'requiredCredits': requiredCredits,
      'courses': courses.map((course) => course.toJson()).toList(),
    };
  }

  factory Subsection.fromJson(Map<String, dynamic> json) {
    final subsection =
        Subsection(json['name'], json['requiredCredits'], id: json['id']);
    if (json['courses'] != null) {
      for (var courseJson in json['courses']) {
        subsection.courses.add(Course.fromJson(courseJson));
      }
    }
    return subsection;
  }
}
