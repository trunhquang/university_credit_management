import 'package:flutter/foundation.dart';
import 'subsection.dart';

//Khối kiến thức
class Section with ChangeNotifier {
  final String name;
  final String id;
  final int requiredCredits;
  final int optionalCredits;
  final String description;

  final List<Subsection> subsections = [];

  Section(
      this.name, this.requiredCredits, this.optionalCredits, this.description,
      {String? id})
      : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  int get totalCredits => requiredCredits + optionalCredits;

  int get completedCredits => subsections.fold(
      0, (sum, subsection) => sum + subsection.completedCredits);

  int get remainingCredits => totalCredits - completedCredits;

  double get progress =>
      requiredCredits > 0 ? completedCredits / requiredCredits : 0;

  void addSubsection(String name) {
    subsections.add(Subsection(name));
    notifyListeners();
  }

  void removeSubsection(Subsection subsection) {
    subsections.remove(subsection);
    notifyListeners();
  }

  void addCourse(String name, int credits) {
    if (subsections.isNotEmpty) {
      subsections.last.addCourse(name, credits);
    }
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
      json['name'],
      json['requiredCredits'],
      json['optionalCredits'],
      json['description'],
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
