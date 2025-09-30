import '../../../core/models/course.dart';
import '../../../core/models/gpa_model.dart';

/// GPAService cung cấp các hàm tiện ích để làm việc với GPA
class GPAService {
  /// Lấy danh sách môn học còn lại (chưa hoàn thành)
  static List<Course> getRemainingCourses(List<Course> allCourses) {
    return allCourses.where((c) => !c.isCompleted).toList();
  }

  /// Dự đoán điểm (thang 10) cần đạt cho từng môn còn lại để đạt target GPA
  static Map<String, double> predictForTarget(
    GPAModel gpaModel,
    double targetGPA,
    List<Course> remainingCourses,
  ) {
    return gpaModel.predictRequiredGrades(targetGPA, remainingCourses);
  }

  /// Gợi ý điểm theo xếp loại mong muốn
  static Map<String, double> suggestForRank(
    GPAModel gpaModel,
    String targetRank,
    List<Course> remainingCourses,
  ) {
    return gpaModel.getGradeSuggestions(targetRank, remainingCourses);
  }
}


