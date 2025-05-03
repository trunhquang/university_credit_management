import 'package:flutter/foundation.dart';
import 'section.dart';

class Major with ChangeNotifier {
  final String name;
  final String id;
  final String description;
  final List<Section> sections = [];

  Major(this.name, {String? id, String? description})
      : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        description = description ?? '';

  int get totalCredits => sections.fold(0, (sum, section) => sum + section.totalCredits);
  int get requiredCredits => sections.fold(0, (sum, section) => sum + section.requiredCredits);
  int get optionalCredits => sections.fold(0, (sum, section) => sum + section.optionalCredits);
  int get completedCredits => sections.fold(0, (sum, section) => sum + section.completedCredits);
  int get remainingCredits => requiredCredits - completedCredits;
  double get progress => requiredCredits > 0 ? completedCredits / requiredCredits : 0;

  void addSection(String name) {
    sections.add(Section(name));
    notifyListeners();
  }

  void removeSection(Section section) {
    sections.remove(section);
    notifyListeners();
  }

  void addSubsection(String name) {
    if (sections.isNotEmpty) {
      sections.last.addSubsection(name);
    }
  }

  void addCourse(String name, int credits) {
    if (sections.isNotEmpty) {
      sections.last.addCourse(name, credits);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'description': description,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }

  factory Major.fromJson(Map<String, dynamic> json) {
    final major = Major(
      json['name'],
      id: json['id'],
      description: json['description'],
    );
    if (json['sections'] != null) {
      for (var sectionJson in json['sections']) {
        major.sections.add(Section.fromJson(sectionJson));
      }
    }
    return major;
  }
} 