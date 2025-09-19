import 'package:flutter/foundation.dart';
import 'course.dart';

/// Model để tính toán và quản lý GPA
class GPAModel with ChangeNotifier {
  double _currentGPA = 0.0;
  int _totalCredits = 0;
  int _completedCredits = 0;
  Map<String, double> _gradePredictions = {};

  double get currentGPA => _currentGPA;
  int get totalCredits => _totalCredits;
  int get completedCredits => _completedCredits;
  Map<String, double> get gradePredictions => _gradePredictions;

  /// Tính GPA hiện tại từ danh sách môn học
  void calculateGPA(List<Course> courses) {
    double totalPoints = 0.0;
    int totalCredits = 0;
    int completedCredits = 0;

    for (var course in courses) {
      if (course.isCompleted && course.score != null) {
        double gradePoints = _convertToGradePoints(course.score!);
        totalPoints += gradePoints * course.credits;
        totalCredits += course.credits;
        completedCredits += course.credits;
      }
    }

    _currentGPA = totalCredits > 0 ? totalPoints / totalCredits : 0.0;
    _totalCredits = totalCredits;
    _completedCredits = completedCredits;
    
    notifyListeners();
  }

  /// Chuyển đổi điểm số (thang 10) sang grade points (thang 4)
  double _convertToGradePoints(double score) {
    if (score >= 9.0) return 4.0;
    if (score >= 8.5) return 3.7;
    if (score >= 8.0) return 3.3;
    if (score >= 7.5) return 3.0;
    if (score >= 7.0) return 2.7;
    if (score >= 6.5) return 2.3;
    if (score >= 6.0) return 2.0;
    if (score >= 5.5) return 1.7;
    if (score >= 5.0) return 1.3;
    if (score >= 4.0) return 1.0;
    return 0.0;
  }

  /// Dự đoán điểm cần đạt để đạt GPA mong muốn
  Map<String, double> predictRequiredGrades(
    double targetGPA, 
    List<Course> remainingCourses
  ) {
    _gradePredictions.clear();
    
    if (remainingCourses.isEmpty) return _gradePredictions;

    int remainingCredits = remainingCourses.fold(
      0, (sum, course) => sum + course.credits);
    
    if (remainingCredits == 0) return _gradePredictions;

    // Tính tổng điểm cần có để đạt target GPA
    double totalTargetPoints = targetGPA * (_totalCredits + remainingCredits);
    double currentPoints = _currentGPA * _totalCredits;
    double requiredPoints = totalTargetPoints - currentPoints;
    
    // Điểm trung bình cần đạt cho các môn còn lại
    double requiredAverageGrade = requiredPoints / remainingCredits;
    
    // Chuyển đổi grade points về thang điểm 10
    double requiredScore = _convertGradePointsToScore(requiredAverageGrade);
    
    for (var course in remainingCourses) {
      _gradePredictions[course.id] = requiredScore;
    }
    
    notifyListeners();
    return _gradePredictions;
  }

  /// Chuyển đổi grade points về thang điểm 10
  double _convertGradePointsToScore(double gradePoints) {
    if (gradePoints >= 4.0) return 9.0;
    if (gradePoints >= 3.7) return 8.5;
    if (gradePoints >= 3.3) return 8.0;
    if (gradePoints >= 3.0) return 7.5;
    if (gradePoints >= 2.7) return 7.0;
    if (gradePoints >= 2.3) return 6.5;
    if (gradePoints >= 2.0) return 6.0;
    if (gradePoints >= 1.7) return 5.5;
    if (gradePoints >= 1.3) return 5.0;
    if (gradePoints >= 1.0) return 4.0;
    return 0.0;
  }

  /// Lấy xếp loại học lực
  String getAcademicRank() {
    if (_currentGPA >= 3.7) return 'Xuất sắc';
    if (_currentGPA >= 3.5) return 'Giỏi';
    if (_currentGPA >= 3.0) return 'Khá';
    if (_currentGPA >= 2.5) return 'Trung bình';
    if (_currentGPA >= 2.0) return 'Trung bình yếu';
    return 'Yếu';
  }

  /// Lấy màu sắc cho GPA
  int getGPAColor() {
    if (_currentGPA >= 3.7) return 0xFF4CAF50; // Green
    if (_currentGPA >= 3.5) return 0xFF8BC34A; // Light Green
    if (_currentGPA >= 3.0) return 0xFFFFC107; // Amber
    if (_currentGPA >= 2.5) return 0xFFFF9800; // Orange
    return 0xFFF44336; // Red
  }

  /// Gợi ý điểm cho các môn còn lại để đạt xếp loại mong muốn
  Map<String, double> getGradeSuggestions(
    String targetRank, 
    List<Course> remainingCourses
  ) {
    double targetGPA;
    switch (targetRank) {
      case 'Xuất sắc':
        targetGPA = 3.7;
        break;
      case 'Giỏi':
        targetGPA = 3.5;
        break;
      case 'Khá':
        targetGPA = 3.0;
        break;
      default:
        targetGPA = 2.5;
    }
    
    return predictRequiredGrades(targetGPA, remainingCourses);
  }

  Map<String, dynamic> toJson() {
    return {
      'currentGPA': _currentGPA,
      'totalCredits': _totalCredits,
      'completedCredits': _completedCredits,
      'gradePredictions': _gradePredictions,
    };
  }

  factory GPAModel.fromJson(Map<String, dynamic> json) {
    final model = GPAModel();
    model._currentGPA = json['currentGPA'] ?? 0.0;
    model._totalCredits = json['totalCredits'] ?? 0;
    model._completedCredits = json['completedCredits'] ?? 0;
    model._gradePredictions = Map<String, double>.from(
      json['gradePredictions'] ?? {});
    return model;
  }

  GPAModel();
}
