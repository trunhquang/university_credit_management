import 'package:flutter/foundation.dart';
import 'subsection.dart';

class Section with ChangeNotifier {
  final String name;
  final String id;
  final List<Subsection> subsections = [];

  Section(this.name, {String? id}) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  int get totalCredits => subsections.fold(0, (sum, subsection) => sum + subsection.totalCredits);
  int get requiredCredits => subsections.fold(0, (sum, subsection) => sum + subsection.requiredCredits);
  int get optionalCredits => subsections.fold(0, (sum, subsection) => sum + subsection.optionalCredits);
  int get completedCredits => subsections.fold(0, (sum, subsection) => sum + subsection.completedCredits);
  int get remainingCredits => requiredCredits - completedCredits;
  double get progress => requiredCredits > 0 ? completedCredits / requiredCredits : 0;

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
      'subsections': subsections.map((subsection) => subsection.toJson()).toList(),
    };
  }

  factory Section.fromJson(Map<String, dynamic> json) {
    final section = Section(json['name'], id: json['id']);
    if (json['subsections'] != null) {
      for (var subsectionJson in json['subsections']) {
        section.subsections.add(Subsection.fromJson(subsectionJson));
      }
    }
    return section;
  }
} 