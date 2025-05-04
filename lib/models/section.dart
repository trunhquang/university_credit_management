import 'package:flutter/foundation.dart';
import 'course.dart';
import 'subsection.dart';

//Khối kiến thức
class Section with ChangeNotifier {
  final String name;
  final String id;
  final int requiredCredits;
  final int optionalCredits;
  final String description;

  final List<Subsection> subsections = [];

  List<Course> get courses =>
      subsections.expand((subsection) => subsection.courses).toList();

  Section(
      {required this.name,
      required this.requiredCredits,
      required this.optionalCredits,
      required this.description,
      String? id})
      : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  int get totalCredits => requiredCredits + optionalCredits;

  int get completedCredits => subsections.fold(
      0, (sum, subsection) => sum + subsection.completedCredits);

  int get remainingCredits => totalCredits - completedCredits;

  double get progress =>
      requiredCredits > 0 ? completedCredits / requiredCredits : 0;

  void removeSubsection(Subsection subsection) {
    subsections.remove(subsection);
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'requiredCredits': requiredCredits,
      'optionalCredits': optionalCredits,
      'description': description,
      'subsections':
          subsections.map((subsection) => subsection.toJson()).toList(),
    };
  }

  factory Section.fromJson(Map<String, dynamic> json) {
    final section = Section(
      name: json['name'],
      requiredCredits: json['requiredCredits'],
      optionalCredits : json['optionalCredits'],
      description: json['description'],
      id: json['id'],
    );
    if (json['subsections'] != null) {
      for (var subsectionJson in json['subsections']) {
        section.subsections.add(Subsection.fromJson(subsectionJson));
      }
    }
    return section;
  }
}
