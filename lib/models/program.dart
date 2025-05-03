import 'section.dart';
import 'course.dart';

class Program {
  final String id;
  final String name;
  final List<Section> sections;

  Program({
    required this.id,
    required this.name,
    required this.sections,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'],
      name: json['name'],
      sections: (json['sections'] as List)
          .map((section) => Section.fromJson(section))
          .toList(),
    );
  }
}

class ProgramSection {
  final String id;
  final String name;
  final int requiredCredits;
  final int optionalCredits;
  final List<Course> courses;

  ProgramSection({
    required this.id,
    required this.name,
    required this.requiredCredits,
    required this.optionalCredits,
    required this.courses,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'requiredCredits': requiredCredits,
      'optionalCredits': optionalCredits,
      'courses': courses.map((course) => course.toJson()).toList(),
    };
  }

  factory ProgramSection.fromJson(Map<String, dynamic> json) {
    return ProgramSection(
      id: json['id'],
      name: json['name'],
      requiredCredits: json['requiredCredits'],
      optionalCredits: json['optionalCredits'],
      courses: (json['courses'] as List)
          .map((course) => Course.fromJson(course))
          .toList(),
    );
  }
} 