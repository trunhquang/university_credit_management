import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/program.dart';
import '../models/course.dart';
import '../models/section.dart';
import '../models/settings.dart';

class ProgramService {
  static final ProgramService _instance = ProgramService._internal();
  factory ProgramService() => _instance;
  ProgramService._internal();

  late SharedPreferences _prefs;
  bool _initialized = false;

  static const String _programKey = 'program';
  static const String _settingsKey = 'settings';

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
      // Chỉ khởi tạo dữ liệu mặc định nếu không có dữ liệu và đang ở chế độ dữ liệu thật
      if (!_prefs.containsKey(_programKey)) {
        await _initDefaultData();
      }
    }
  }

  // Helper method to ensure prefs is initialized and return non-null instance
  Future<SharedPreferences> get prefs async {
    await init();
    return _prefs;
  }

  Future<void> _initDefaultData() async {
    // final sections = [
    //   Section(
    //     id: '1',
    //     name: 'Kiến thức giáo dục đại cương',
    //     requiredCredits: 34,
    //     optionalCredits: 22,
    //     description: 'Các môn học cơ bản, rèn luyện tư duy và kỹ năng',
    //     courses: [
    //       Course(
    //         id: 'ВAA00101',
    //         name: 'Triết học Mác-Lênin',
    //         credits: 3,
    //         grade: 0,
    //         isPassed: false,
    //         type: CourseType.required,
    //         status: CourseStatus.notStarted,
    //       )
    //     ], // Bắt đầu với danh sách rỗng
    //   ),
    //   Section(
    //     id: '2',
    //     name: 'Kiến thức cơ sở ngành',
    //     requiredCredits: 38,
    //     optionalCredits: 0,
    //     description: 'Nền tảng cho chuyên ngành',
    //     courses: [], // Bắt đầu với danh sách rỗng
    //   ),
    //   Section(
    //     id: '3',
    //     name: 'Kiến thức chuyên ngành',
    //     requiredCredits: 0,
    //     optionalCredits:34,
    //     description: 'Kiến thức chuyên sâu về ngành học',
    //     courses: [], // Bắt đầu với danh sách rỗng
    //   ),
    //   Section(
    //     id: '3',
    //     name: 'Kiến thức Tốt nghiệp',
    //     requiredCredits: 0,
    //     optionalCredits:10,
    //     description: 'Kiến thức tổng hợp tốt nghiệp',
    //     courses: [], // Bắt đầu với danh sách rỗng
    //   )
    // ];
    
    // await saveSections(sections);
  }




  Future<List<Section>> getSections() async {
    final sectionsJson = _prefs.getStringList(_programKey) ?? [];
    if (sectionsJson.isEmpty) {
      // await _initDefaultData();
      // return getSections();
      return [];
    }
    
    return sectionsJson.map((json) => Section.fromJson(jsonDecode(json))).toList();
  }

  Future<void> saveSections(List<Section> sections) async {
    final preferences = await prefs;
    final sectionsJson = sections.map((section) => jsonEncode(section.toJson())).toList();
    await preferences.setStringList(_programKey, sectionsJson);
  }

  Future<void> addCourse(String sectionId, Course course) async {
    // final sections = await getSections();
    // final sectionIndex = sections.indexWhere((s) => s.id == sectionId);
    // if (sectionIndex != -1) {
    //   sections[sectionIndex].courses.add(course);
    //   await saveSections(sections);
    // }
  }

  Future<void> updateCourse(String sectionId, Course course) async {
    // final sections = await getSections();
    // final sectionIndex = sections.indexWhere((s) => s.id == sectionId);
    // if (sectionIndex != -1) {
    //   final courseIndex = sections[sectionIndex].courses.indexWhere((c) => c.id == course.id);
    //   if (courseIndex != -1) {
    //     sections[sectionIndex].courses[courseIndex] = course;
    //     await saveSections(sections);
    //   }
    // }
  }

  Future<void> deleteCourse(String sectionId, String courseId) async {
    // final sections = await getSections();
    // final sectionIndex = sections.indexWhere((s) => s.id == sectionId);
    // if (sectionIndex != -1) {
    //   sections[sectionIndex].courses.removeWhere((c) => c.id == courseId);
    //   await saveSections(sections);
    // }
  }

  Future<void> addCourseToSection(String sectionId, Course course) async {
    // final sections = await getSections();
    // final sectionIndex = sections.indexWhere((s) => s.id == sectionId);
    // if (sectionIndex != -1) {
    //   sections[sectionIndex].courses.add(course);
    //   await saveSections(sections);
    // }
  }

  Future<double> calculateSectionProgress(Section section, int totalCredits) async {
    // if (section.courses.isEmpty) return 0;
    // final completedCredits = section.courses
    //     .where((course) => course.grade != null && course.grade! >= 5.0)
    //     .fold(0, (sum, course) => sum + course.credits);
    // return (completedCredits / totalCredits) * 100;
    return 100;
  }


  Future<Map<String, dynamic>> getProgress(int totalCredits) async {
    final sections = await getSections();
    
    // Tính toán tín chỉ bắt buộc
    // final completedRequiredCredits = sections
    //     .expand((s) => s.courses)
    //     .where((c) => c.status == CourseStatus.completed && c.type == CourseType.required)
    //     .fold(0, (sum, course) => sum + course.credits);
    //
    // final inProgressRequiredCredits = sections
    //     .expand((s) => s.courses)
    //     .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.required)
    //     .fold(0, (sum, course) => sum + course.credits);
    //
    // // Tính toán tín chỉ tự chọn
    // final completedOptionalCredits = sections
    //     .expand((s) => s.courses)
    //     .where((c) => c.status == CourseStatus.completed && c.type == CourseType.optional)
    //     .fold(0, (sum, course) => sum + course.credits);
    //
    // final inProgressOptionalCredits = sections
    //     .expand((s) => s.courses)
    //     .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.optional)
    //     .fold(0, (sum, course) => sum + course.credits);
    //
    // // Tính tổng số tín chỉ yêu cầu cho mỗi loại
    // final totalRequiredCredits = sections
    //     .fold(0, (sum, section) => sum + section.requiredCredits);
    //
    // final totalOptionalCredits = sections
    //     .fold(0, (sum, section) => sum + section.optionalCredits);
    //
    // final completedCredits = completedRequiredCredits + completedOptionalCredits;
    // final inProgressCredits = inProgressRequiredCredits + inProgressOptionalCredits;
    //
    // return {
    //   'totalCredits': totalCredits,
    //   'completedCredits': completedCredits,
    //   'inProgressCredits': inProgressCredits,
    //   'remainingCredits': totalCredits - completedCredits,
    //   'percentage': (completedCredits / totalCredits * 100).clamp(0, 100),
    //
    //   // Thêm các trường mới
    //   'completedRequiredCredits': completedRequiredCredits,
    //   'completedOptionalCredits': completedOptionalCredits,
    //   'inProgressRequiredCredits': inProgressRequiredCredits,
    //   'inProgressOptionalCredits': inProgressOptionalCredits,
    //   'totalRequiredCredits': totalRequiredCredits,
    //   'totalOptionalCredits': totalOptionalCredits,
    // };
    return {};
  }

  Future<Map<String, dynamic>> getMissingRequiredCredits() async {
    final sections = await getSections();
    bool hasMissingCredits = false;
    // final sectionData = sections.map((section) {
    //   // Tính toán tín chỉ đã hoàn thành
    //   final completedRequired = section.courses
    //       .where((c) => c.status == CourseStatus.completed && c.type == CourseType.required)
    //       .fold(0, (sum, course) => sum + course.credits);
    //
    //   final completedOptional = section.courses
    //       .where((c) => c.status == CourseStatus.completed && c.type == CourseType.optional)
    //       .fold(0, (sum, course) => sum + course.credits);
    //
    //   // Tính toán tín chỉ đang học
    //   final inProgressRequired = section.courses
    //       .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.required)
    //       .fold(0, (sum, course) => sum + course.credits);
    //
    //   final inProgressOptional = section.courses
    //       .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.optional)
    //       .fold(0, (sum, course) => sum + course.credits);
    //
    //   // Tính toán tín chỉ còn thiếu
    //   final missingRequired = section.requiredCredits - completedRequired - inProgressRequired;
    //   final missingOptional = section.optionalCredits - completedOptional - inProgressOptional;
    //
    //   if (missingRequired > 0 || missingOptional > 0) {
    //     hasMissingCredits = true;
    //   }
    //
    //   return {
    //     'name': section.name,
    //     'requiredCredits': section.requiredCredits,
    //     'optionalCredits': section.optionalCredits,
    //     'completedRequired': completedRequired,
    //     'completedOptional': completedOptional,
    //     'inProgressRequired': inProgressRequired,
    //     'inProgressOptional': inProgressOptional,
    //     'missingRequired': missingRequired > 0 ? missingRequired : 0,
    //     'missingOptional': missingOptional > 0 ? missingOptional : 0,
    //   };
    // }).toList();

    return {
      // 'hasMissingCredits': hasMissingCredits,
      // 'sections': sectionData,
    };
  }

  Future<Program> getProgram() async {
    final sections = await getSections();
    return Program(
      id: 'default',
      name: 'Chương trình đào tạo',
      sections: sections,
    );
  }

  Future<Settings> getSettings() async {
    await init();
    final settingsStr = _prefs.getString(_settingsKey);
    
    // If no settings exist, return default settings
    if (settingsStr == null) {
      final defaultSettings = Settings.defaultSettings();
      await saveSettings(defaultSettings);
      return defaultSettings;
    }
    
    final Map<String, dynamic> settingsMap = jsonDecode(settingsStr);
    return Settings.fromJson(settingsMap);
  }

  Future<void> saveSettings(Settings settings) async {
    await init();
    final settingsJson = jsonEncode(settings.toJson());
    await _prefs.setString(_settingsKey, settingsJson);
  }


  Future<void> addSection(Section section) async {
    final sections = await getSections();
    sections.add(section);
    await saveSections(sections);
  }

  Future<void> updateSection(Section updatedSection) async {
    final sections = await getSections();
    final index = sections.indexWhere((s) => s.id == updatedSection.id);
    if (index != -1) {
      sections[index] = updatedSection;
      await saveSections(sections);
    }
  }

  Future<void> deleteSection(String sectionId) async {
    final sections = await getSections();
    sections.removeWhere((s) => s.id == sectionId);
    await saveSections(sections);
  }
} 