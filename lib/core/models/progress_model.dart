import 'package:flutter/foundation.dart';
import 'section.dart';
import 'course.dart';

/// Model để theo dõi tiến độ học tập
class ProgressModel with ChangeNotifier {
  List<Section> _sections = [];
  int _totalCredits = 138;
  int _completedCredits = 0;
  int _inProgressCredits = 0;
  int _notStartedCredits = 0;

  List<Section> get sections => _sections;
  int get totalCredits => _totalCredits;
  int get completedCredits => _completedCredits;
  int get inProgressCredits => _inProgressCredits;
  int get notStartedCredits => _notStartedCredits;

  double get overallProgress => _totalCredits > 0 ? _completedCredits / _totalCredits : 0.0;
  double get overallProgressPercentage => overallProgress * 100;

  /// Cập nhật tiến độ từ danh sách sections
  void updateProgress(List<Section> sections) {
    _sections = sections;
    _calculateProgress();
    notifyListeners();
  }

  /// Tính toán tiến độ tổng thể
  void _calculateProgress() {
    _completedCredits = 0;
    _inProgressCredits = 0;
    _notStartedCredits = 0;

    for (var section in _sections) {
      for (var group in section.courseGroups) {
        for (var course in group.courses) {
          switch (course.status) {
            case CourseStatus.completed:
              _completedCredits += course.credits;
              break;
            case CourseStatus.inProgress:
              _inProgressCredits += course.credits;
              break;
            case CourseStatus.notStarted:
            case CourseStatus.failed:
            case CourseStatus.registering:
            case CourseStatus.needToRegister:
              _notStartedCredits += course.credits;
              break;
          }
        }
      }
    }
  }

  /// Lấy tiến độ theo khối kiến thức
  Map<String, SectionProgress> getSectionProgress() {
    Map<String, SectionProgress> sectionProgress = {};
    
    for (var section in _sections) {
      int completed = 0;
      int inProgress = 0;
      int notStarted = 0;
      int total = section.totalCredits;

      for (var group in section.courseGroups) {
        for (var course in group.courses) {
          switch (course.status) {
            case CourseStatus.completed:
              completed += course.credits;
              break;
            case CourseStatus.inProgress:
              inProgress += course.credits;
              break;
            default:
              notStarted += course.credits;
              break;
          }
        }
      }

      sectionProgress[section.id] = SectionProgress(
        sectionName: section.name,
        totalCredits: total,
        completedCredits: completed,
        inProgressCredits: inProgress,
        notStartedCredits: notStarted,
        progressPercentage: total > 0 ? (completed / total) * 100 : 0.0,
      );
    }

    return sectionProgress;
  }

  /// Lấy thống kê môn học
  Map<String, int> getCourseStatistics() {
    int totalCourses = 0;
    int completedCourses = 0;
    int inProgressCourses = 0;
    int notStartedCourses = 0;

    for (var section in _sections) {
      for (var group in section.courseGroups) {
        for (var course in group.courses) {
          totalCourses++;
          switch (course.status) {
            case CourseStatus.completed:
              completedCourses++;
              break;
            case CourseStatus.inProgress:
              inProgressCourses++;
              break;
            default:
              notStartedCourses++;
              break;
          }
        }
      }
    }

    return {
      'total': totalCourses,
      'completed': completedCourses,
      'inProgress': inProgressCourses,
      'notStarted': notStartedCourses,
    };
  }

  /// Lấy danh sách môn học theo trạng thái
  List<Course> getCoursesByStatus(CourseStatus status) {
    List<Course> courses = [];
    
    for (var section in _sections) {
      for (var group in section.courseGroups) {
        for (var course in group.courses) {
          if (course.status == status) {
            courses.add(course);
          }
        }
      }
    }
    
    return courses;
  }

  /// Lấy danh sách môn học sắp tới (chưa bắt đầu)
  List<Course> getUpcomingCourses({int limit = 5}) {
    List<Course> upcomingCourses = getCoursesByStatus(CourseStatus.notStarted);
    
    // Sắp xếp theo thứ tự ưu tiên (có thể dựa trên prerequisite)
    upcomingCourses.sort((a, b) => a.name.compareTo(b.name));
    
    return upcomingCourses.take(limit).toList();
  }

  /// Kiểm tra xem có thể tốt nghiệp không
  bool canGraduate() {
    return _completedCredits >= _totalCredits;
  }

  /// Ước tính thời gian còn lại để tốt nghiệp (dựa trên trung bình 20 tín chỉ/học kỳ)
  int getEstimatedSemestersRemaining() {
    int remainingCredits = _totalCredits - _completedCredits;
    if (remainingCredits <= 0) return 0;
    
    // Giả sử trung bình 20 tín chỉ mỗi học kỳ
    int semesters = (remainingCredits / 20).ceil();
    return semesters;
  }

  /// Lấy tiến độ theo loại môn (bắt buộc/tự chọn)
  Map<String, int> getProgressByType() {
    int requiredCompleted = 0;
    int requiredTotal = 0;
    int optionalCompleted = 0;
    int optionalTotal = 0;

    for (var section in _sections) {
      for (var group in section.courseGroups) {
        for (var course in group.courses) {
          if (course.type == CourseType.required) {
            requiredTotal += course.credits;
            if (course.status == CourseStatus.completed) {
              requiredCompleted += course.credits;
            }
          } else {
            optionalTotal += course.credits;
            if (course.status == CourseStatus.completed) {
              optionalCompleted += course.credits;
            }
          }
        }
      }
    }

    return {
      'requiredCompleted': requiredCompleted,
      'requiredTotal': requiredTotal,
      'optionalCompleted': optionalCompleted,
      'optionalTotal': optionalTotal,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCredits': _totalCredits,
      'completedCredits': _completedCredits,
      'inProgressCredits': _inProgressCredits,
      'notStartedCredits': _notStartedCredits,
    };
  }

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    final model = ProgressModel();
    model._totalCredits = json['totalCredits'] ?? 138;
    model._completedCredits = json['completedCredits'] ?? 0;
    model._inProgressCredits = json['inProgressCredits'] ?? 0;
    model._notStartedCredits = json['notStartedCredits'] ?? 0;
    return model;
  }

  ProgressModel();
}

/// Class để lưu trữ tiến độ của một khối kiến thức
class SectionProgress {
  final String sectionName;
  final int totalCredits;
  final int completedCredits;
  final int inProgressCredits;
  final int notStartedCredits;
  final double progressPercentage;

  SectionProgress({
    required this.sectionName,
    required this.totalCredits,
    required this.completedCredits,
    required this.inProgressCredits,
    required this.notStartedCredits,
    required this.progressPercentage,
  });

  int get remainingCredits => totalCredits - completedCredits;
  double get completionRate => totalCredits > 0 ? completedCredits / totalCredits : 0.0;
}