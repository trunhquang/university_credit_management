import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/course.dart';
import '../services/program_service.dart';

class CourseService {
  static const String _coursesKey = 'courses';
  late SharedPreferences _prefs;
  final ProgramService _programService = ProgramService();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Course>> getCourses() async {
    final sections = await _programService.getSections();
    return sections
        .expand((section) => section.courseGroups)
        .expand((group) => group.courses)
        .toList();
  }

  Future<void> addCourse(Course course) async {
    final sections = await _programService.getSections();
    if (sections.isNotEmpty) {
      sections[0].courseGroups[0].courses.add(course);
      await _programService.saveSections(sections);
    }
  }

  Future<void> updateCourse(Course course) async {
    final sections = await _programService.getSections();
    for (var section in sections) {
      for (var group in section.courseGroups) {
        final index = group.courses.indexWhere((c) => c.id == course.id);
        if (index != -1) {
          group.courses[index] = course;
          await _programService.saveSections(sections);
          return;
        }
      }
    }
  }

  Future<void> deleteCourse(String courseId) async {
    final sections = await _programService.getSections();
    for (var section in sections) {
      for (var group in section.courseGroups) {
        group.courses.removeWhere((course) => course.id == courseId);
      }
    }
    await _programService.saveSections(sections);
  }

  Future<double> calculateGPA() async {
    final courses = await getCourses();
    if (courses.isEmpty) return 0.0;

    double totalGradePoints = 0;
    int totalCredits = 0;

    for (var course in courses) {
      if (course.score != null) {
        totalGradePoints += course.score! * course.credits;
        totalCredits += course.credits;
      }
    }

    return totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;
  }

  Future<int> getTotalCredits() async {
    final sections = await _programService.getSections();
    return sections
        .expand((section) => section.courseGroups)
        .expand((group) => group.courses)
        .fold<int>(0, (sum, course) => sum + course.credits);
  }

  Future<int> getCompletedCredits() async {
    final sections = await _programService.getSections();
    return sections
        .expand((section) => section.courseGroups)
        .expand((group) => group.courses)
        .where((course) => course.isPassed)
        .fold<int>(0, (sum, course) => sum + course.credits);
  }

  Future<void> _saveCourses(List<Course> courses) async {
    final coursesJson = courses.map((course) => jsonEncode(course.toJson())).toList();
    await _prefs.setStringList(_coursesKey, coursesJson);
  }

  Future<double> calculateOverallGPA() async {
    final sections = await _programService.getSections();
    final courses = sections
        .expand((section) => section.courseGroups)
        .expand((group) => group.courses)
        .toList();
    if (courses.isEmpty) return 0.0;

    double totalPoints = 0;
    int totalCredits = 0;

    for (var course in courses) {
      if (course.score != null) {
        totalPoints += course.score! * course.credits;
        totalCredits += course.credits;
      }
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }
} 