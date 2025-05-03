import 'course.dart';

class CourseGroup {
  final String id;
  final String name;
  final List<Course> courses;
  final String description;
  Course? selectedCourse;

  CourseGroup({
    required this.id,
    required this.name,
    required this.courses,
    this.description = '',
    this.selectedCourse,
  });

  bool get isCompleted => selectedCourse != null && selectedCourse!.isPassed;

  int get credits => selectedCourse?.credits ?? 0;

  void selectCourse(Course course) {
    if (!courses.contains(course)) {
      throw Exception('Course not found in this group');
    }
    selectedCourse = course;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'courses': courses.map((course) => course.toJson()).toList(),
      'description': description,
      'selectedCourse': selectedCourse?.toJson(),
    };
  }

  factory CourseGroup.fromJson(Map<String, dynamic> json) {
    return CourseGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      courses: (json['courses'] as List)
          .map((courseJson) => Course.fromJson(courseJson))
          .toList(),
      selectedCourse: json['selectedCourse'] != null
          ? Course.fromJson(json['selectedCourse'])
          : null,
    );
  }
} 