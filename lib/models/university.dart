import 'package:flutter/foundation.dart';
import 'major.dart';

class University with ChangeNotifier {
  final List<Major> majors = [];

  University();

  int get totalCredits => majors.fold(0, (sum, major) => sum + major.totalCredits);
  int get requiredCredits => majors.fold(0, (sum, major) => sum + major.requiredCredits);
  int get completedCredits => majors.fold(0, (sum, major) => sum + major.completedCredits);
  int get remainingCredits => requiredCredits - completedCredits;
  double get progress => requiredCredits > 0 ? completedCredits / requiredCredits : 0;

  void addMajor(String name, {String? description}) {
    majors.add(Major(name, description: description));
    notifyListeners();
  }

  void removeMajor(Major major) {
    majors.remove(major);
    notifyListeners();
  }

  void addSection(String name) {
    if (majors.isNotEmpty) {
      majors.last.addSection(name);
    }
  }

  void addSubsection(String name) {
    if (majors.isNotEmpty) {
      majors.last.addSubsection(name);
    }
  }

  void addCourse(String name, int credits) {
    if (majors.isNotEmpty) {
      majors.last.addCourse(name, credits);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'majors': majors.map((major) => major.toJson()).toList(),
    };
  }

  factory University.fromJson(Map<String, dynamic> json) {
    final university = University();
    if (json['majors'] != null) {
      for (var majorJson in json['majors']) {
        university.majors.add(Major.fromJson(majorJson));
      }
    }
    return university;
  }

  // Helper methods
  Major? getMajorById(String majorId) {
    try {
      return majors.firstWhere((major) => major.id == majorId);
    } catch (e) {
      return null;
    }
  }

  List<Major> getMajorsByKeyword(String keyword) {
    return majors
        .where((major) =>
            major.name.toLowerCase().contains(keyword.toLowerCase()) ||
            major.description.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
} 