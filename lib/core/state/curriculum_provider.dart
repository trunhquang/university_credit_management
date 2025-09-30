import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/section.dart';
import '../models/course.dart';
import '../models/gpa_model.dart';
import '../models/progress_model.dart';
import '../data/curriculum_template.dart';
import '../data/gpa_history_service.dart';

/// Provider để quản lý state của curriculum
class CurriculumProvider with ChangeNotifier {
  List<Section> _sections = [];
  GPAModel _gpaModel = GPAModel();
  ProgressModel _progressModel = ProgressModel();
  final GPAHistoryService _gpaHistory = GPAHistoryService();
  bool _isLoading = false;
  String? _error;

  List<Section> get sections => _sections;
  GPAModel get gpaModel => _gpaModel;
  ProgressModel get progressModel => _progressModel;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Khởi tạo dữ liệu curriculum
  Future<void> initializeCurriculum() async {
    _setLoading(true);
    try {
      // Thử load dữ liệu từ local storage trước
      await _loadFromStorage();
      
      // Nếu không có dữ liệu, load từ template
      if (_sections.isEmpty) {
        await _loadFromTemplate();
        await _saveToStorage();
      }
      
      _updateProgressAndGPA();
      _error = null;
    } catch (e) {
      _error = 'Lỗi khi khởi tạo dữ liệu: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  /// Load dữ liệu từ template
  Future<void> _loadFromTemplate() async {
    _sections = await CurriculumTemplate.getTemplateData();
  }

  /// Load dữ liệu từ local storage
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sectionsJson = prefs.getString('curriculum_sections');
      
      if (sectionsJson != null) {
        final List<dynamic> sectionsList = json.decode(sectionsJson);
        _sections = sectionsList.map((json) => Section.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Lỗi khi load từ storage: $e');
    }
  }

  /// Lưu dữ liệu vào local storage
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sectionsJson = json.encode(_sections.map((s) => s.toJson()).toList());
      await prefs.setString('curriculum_sections', sectionsJson);
    } catch (e) {
      debugPrint('Lỗi khi lưu vào storage: $e');
    }
  }

  /// Cập nhật trạng thái loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Cập nhật tiến độ và GPA
  void _updateProgressAndGPA() {
    _progressModel.updateProgress(_sections);
    
    // Lấy tất cả courses để tính GPA
    List<Course> allCourses = [];
    for (var section in _sections) {
      for (var group in section.courseGroups) {
        allCourses.addAll(group.courses);
      }
    }
    
    _gpaModel.calculateGPA(allCourses);

    // Lưu lịch sử GPA
    _gpaHistory.append(GPAHistoryEntry(
      timestamp: DateTime.now(),
      gpa: _gpaModel.currentGPA,
      completedCredits: _gpaModel.completedCredits,
    ));
  }

  /// Cập nhật trạng thái môn học
  Future<void> updateCourseStatus(String courseId, CourseStatus newStatus) async {
    try {
      for (var section in _sections) {
        for (var group in section.courseGroups) {
          for (var course in group.courses) {
            if (course.id == courseId) {
              // Tạo course mới với status mới
              final updatedCourse = course.copyWith(status: newStatus);
              
              // Tìm và thay thế course trong danh sách
              final courseIndex = group.courses.indexOf(course);
              if (courseIndex != -1) {
                group.courses[courseIndex] = updatedCourse;
              }
              
              _updateProgressAndGPA();
              await _saveToStorage();
              notifyListeners();
              return;
            }
          }
        }
      }
    } catch (e) {
      _error = 'Lỗi khi cập nhật trạng thái môn học: $e';
      debugPrint(_error);
    }
  }

  /// Cập nhật điểm số môn học
  Future<void> updateCourseScore(String courseId, double score) async {
    try {
      for (var section in _sections) {
        for (var group in section.courseGroups) {
          for (var course in group.courses) {
            if (course.id == courseId) {
              // Tạo course mới với điểm số mới
              final updatedCourse = course.copyWith(score: score);
              
              // Tìm và thay thế course trong danh sách
              final courseIndex = group.courses.indexOf(course);
              if (courseIndex != -1) {
                group.courses[courseIndex] = updatedCourse;
              }
              
              _updateProgressAndGPA();
              await _saveToStorage();
              notifyListeners();
              return;
            }
          }
        }
      }
    } catch (e) {
      _error = 'Lỗi khi cập nhật điểm số: $e';
      debugPrint(_error);
    }
  }

  /// Lấy môn học theo ID
  Course? getCourseById(String courseId) {
    for (var section in _sections) {
      for (var group in section.courseGroups) {
        for (var course in group.courses) {
          if (course.id == courseId) {
            return course;
          }
        }
      }
    }
    return null;
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

  /// Lấy danh sách môn học theo khối kiến thức
  List<Course> getCoursesBySection(String sectionId) {
    List<Course> courses = [];
    for (var section in _sections) {
      if (section.id == sectionId) {
        for (var group in section.courseGroups) {
          courses.addAll(group.courses);
        }
        break;
      }
    }
    return courses;
  }

  /// Tìm kiếm môn học
  List<Course> searchCourses(String query) {
    if (query.isEmpty) return [];
    
    List<Course> results = [];
    final lowerQuery = query.toLowerCase();
    
    for (var section in _sections) {
      for (var group in section.courseGroups) {
        for (var course in group.courses) {
          if (course.name.toLowerCase().contains(lowerQuery) ||
              course.id.toLowerCase().contains(lowerQuery)) {
            results.add(course);
          }
        }
      }
    }
    
    return results;
  }

  /// Lọc môn học theo loại
  List<Course> filterCoursesByType(CourseType type) {
    List<Course> courses = [];
    for (var section in _sections) {
      for (var group in section.courseGroups) {
        for (var course in group.courses) {
          if (course.type == type) {
            courses.add(course);
          }
        }
      }
    }
    return courses;
  }

  /// Reset dữ liệu về trạng thái ban đầu
  Future<void> resetToTemplate() async {
    _setLoading(true);
    try {
      await _loadFromTemplate();
      _updateProgressAndGPA();
      await _saveToStorage();
      _error = null;
    } catch (e) {
      _error = 'Lỗi khi reset dữ liệu: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  /// Xóa lỗi
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Lấy thống kê tổng quan
  Map<String, dynamic> getOverallStatistics() {
    final courseStats = _progressModel.getCourseStatistics();
    final progressByType = _progressModel.getProgressByType();
    
    return {
      'totalCredits': _progressModel.totalCredits,
      'completedCredits': _progressModel.completedCredits,
      'inProgressCredits': _progressModel.inProgressCredits,
      'notStartedCredits': _progressModel.notStartedCredits,
      'overallProgress': _progressModel.overallProgressPercentage,
      'totalCourses': courseStats['total'],
      'completedCourses': courseStats['completed'],
      'inProgressCourses': courseStats['inProgress'],
      'notStartedCourses': courseStats['notStarted'],
      'requiredCompleted': progressByType['requiredCompleted'],
      'requiredTotal': progressByType['requiredTotal'],
      'optionalCompleted': progressByType['optionalCompleted'],
      'optionalTotal': progressByType['optionalTotal'],
      'currentGPA': _gpaModel.currentGPA,
      'academicRank': _gpaModel.getAcademicRank(),
      'canGraduate': _progressModel.canGraduate(),
      'estimatedSemestersRemaining': _progressModel.getEstimatedSemestersRemaining(),
    };
  }
}
