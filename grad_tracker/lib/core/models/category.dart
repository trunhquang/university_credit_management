import 'course.dart';

class Category {
  final String id;
  final String title;
  final int requiredCredits;
  final List<Course> courses;
  final int? minChoiceCredits;

  const Category({
    required this.id,
    required this.title,
    required this.requiredCredits,
    required this.courses,
    this.minChoiceCredits,
  });
}


