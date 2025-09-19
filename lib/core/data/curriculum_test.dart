import 'curriculum_template.dart';

/// Test class để kiểm tra curriculum template
class CurriculumTest {
  static Future<void> testTemplateData() async {
    print('Testing CurriculumTemplate...');
    
    try {
      final sections = await CurriculumTemplate.getTemplateData();
      
      print('✅ Successfully loaded ${sections.length} sections');
      
      // Kiểm tra tổng số tín chỉ
      int totalRequiredCredits = 0;
      int totalOptionalCredits = 0;
      
      for (var section in sections) {
        totalRequiredCredits += section.requiredCredits;
        totalOptionalCredits += section.optionalCredits;
        
        print('📚 ${section.name}: ${section.requiredCredits} BB + ${section.optionalCredits} TC = ${section.totalCredits} tín chỉ');
      }
      
      int totalCredits = totalRequiredCredits + totalOptionalCredits;
      print('\n📊 Tổng kết:');
      print('   - Tổng tín chỉ bắt buộc: $totalRequiredCredits');
      print('   - Tổng tín chỉ tự chọn: $totalOptionalCredits');
      print('   - Tổng cộng: $totalCredits tín chỉ');
      
      if (totalCredits == 138) {
        print('✅ Đúng 138 tín chỉ theo yêu cầu!');
      } else {
        print('❌ Sai! Cần 138 tín chỉ nhưng có $totalCredits tín chỉ');
      }
      
      // Kiểm tra số môn học
      int totalCourses = 0;
      for (var section in sections) {
        for (var group in section.courseGroups) {
          totalCourses += group.courses.length;
        }
      }
      print('📖 Tổng số môn học: $totalCourses');
      
      // Kiểm tra các môn học không có prerequisite
      int coursesWithoutPrerequisites = 0;
      for (var section in sections) {
        for (var group in section.courseGroups) {
          for (var course in group.courses) {
            if (course.prerequisiteCourses.isEmpty) {
              coursesWithoutPrerequisites++;
            }
          }
        }
      }
      print('🔓 Số môn học không yêu cầu tiên quyết: $coursesWithoutPrerequisites');
      
    } catch (e) {
      print('❌ Error: $e');
    }
  }
}
