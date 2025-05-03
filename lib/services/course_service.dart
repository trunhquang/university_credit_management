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
    final coursesJson = _prefs.getStringList(_coursesKey) ?? [];
    return coursesJson.map((json) => Course.fromJson(jsonDecode(json))).toList();
  }

  Future<void> addCourse(Course course) async {
    final courses = await getCourses();
    courses.add(course);
    await _saveCourses(courses);
  }

  Future<void> updateCourse(Course course) async {
    final courses = await getCourses();
    final index = courses.indexWhere((c) => c.id == course.id);
    if (index != -1) {
      courses[index] = course;
      await _saveCourses(courses);
    }
  }

  Future<void> deleteCourse(String courseId) async {
    final courses = await getCourses();
    courses.removeWhere((course) => course.id == courseId);
    await _saveCourses(courses);
  }

  Future<double> calculateGPA() async {
    final courses = await getCourses();
    if (courses.isEmpty) return 0.0;

    double totalGradePoints = 0;
    int totalCredits = 0;

    for (var course in courses) {
      if (course.grade != null) {
        totalGradePoints += course.grade! * course.credits;
        totalCredits += course.credits;
      }
    }

    return totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;
  }


  Future<int> getTotalCredits() async {
    final courses = await getCourses();
    return courses.fold<int>(0, (sum, course) => sum + course.credits);
  }


  Future<int> getPassedCredits() async {
    final courses = await getCourses();
    return courses.where((course) => course.isPassed).fold<int>(0, (sum, course) => sum + course.credits);
  }




  Future<void> _saveCourses(List<Course> courses) async {
    final coursesJson = courses.map((course) => jsonEncode(course.toJson())).toList();
    await _prefs.setStringList(_coursesKey, coursesJson);
  }

  Future<double> calculateOverallGPA() async {
    // try {
    //   final sections = await _programService.getSections();
    //
    //   double totalGradePoints = 0;
    //   int totalCredits = 0;
    //
    //   // Tính tổng điểm và tổng tín chỉ cho các môn đã hoàn thành
    //   for (var section in sections) {
    //     for (var course in section.courses) {
    //       if (course.grade != null && course.isPassed) {
    //         totalGradePoints += (course.grade! * course.credits);
    //         totalCredits += course.credits;
    //       }
    //     }
    //   }
    //
    //   // Tránh chia cho 0
    //   if (totalCredits == 0) {
    //     return 0.0;
    //   }
    //
    //   // Làm tròn đến 2 chữ số thập phân
    //   return double.parse((totalGradePoints / totalCredits).toStringAsFixed(2));
    // } catch (e) {
    //   print('Error calculating GPA: $e');
    //   return 0.0;
    // }
    return 0;
  }
} 