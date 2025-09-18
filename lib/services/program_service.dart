import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../models/progress_model.dart';
import '../models/section.dart';
import '../models/settings.dart';
import '../models/course_group.dart';

class ProgramService {
  static final ProgramService _instance = ProgramService._internal();

  factory ProgramService() => _instance;

  ProgramService._internal();

  late SharedPreferences _prefs;
  bool _initialized = false;

  static const String _programKey = 'program';
  static const String _settingsKey = 'settings';
  static const String _isFirstInstallKey = 'is_first_install';

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;

      // Kiểm tra xem đây có phải là lần đầu cài đặt app không
      final isFirstInstall = _prefs.getBool(_isFirstInstallKey) ?? true;
      if (isFirstInstall) {
        await _initDefaultData();
        await _prefs.setBool(_isFirstInstallKey, false);
      }
    }
  }

  // Helper method to ensure prefs is initialized and return non-null instance
  Future<SharedPreferences> get prefs async {
    await init();
    return _prefs;
  }

  Future<void> _initDefaultData() async {
    final sections = [
      Section(
        name: 'Kiến thức giáo dục đại cương',
        requiredCredits: 34 + 8,
        optionalCredits: 22,
        description: 'Các môn học cơ bản, rèn luyện tư duy và kỹ năng',
        id: '1',
        courseGroups: [
          CourseGroup(
            id: '1.1',
            name: 'Lý luận chính trị - Pháp luật',
            description: 'Các môn học về lý luận chính trị',
            requiredCredits: 14,
            optionalCredits: 0,
            courses: [
              Course(
                name: 'Triết học Mác - Lênin',
                credits: 3,
                id: 'BAA00101',
                type: CourseType.required,
                status: CourseStatus.completed,
                score: 5.6,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Kinh tế chính trị Mác - Lênin',
                credits: 2,
                id: 'BAA00102',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Chủ nghĩa xã hội khoa học',
                credits: 2,
                id: 'BAA00103',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Lịch sử Đảng Cộng sản Việt Nam',
                credits: 2,
                id: 'BAA00104',
                type: CourseType.required,
                status: CourseStatus.inProgress,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Tư tưởng Hồ Chí Minh',
                credits: 2,
                id: 'BAA00003',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Pháp luật đại cương',
                credits: 3,
                id: 'BAA00004',
                type: CourseType.required,
                status: CourseStatus.inProgress,
                prerequisiteCourses: [],
              ),
            ],
          ),
          CourseGroup(
            id: '1.2',
            name: 'Khoa học xã hội - Kinh tế - Kỹ năng',
            description: 'Các môn học về khoa học xã hội và kinh tế',
            requiredCredits: 0,
            optionalCredits: 2,
            courses: [
              Course(
                name: 'Kinh tế đại cương',
                credits: 2,
                id: 'BAA00005',
                type: CourseType.optional,
                status: CourseStatus.completed,
                score: 6.7,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Tâm lý đại cương',
                credits: 2,
                id: 'BAA00006',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Phương pháp luận sáng tạo',
                credits: 2,
                id: 'BAA00007',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
            ],
          ),
          CourseGroup(
            id: '1.3',
            name: 'Toán - Khoa học tự nhiên',
            description: 'Các môn học về toán và khoa học tự nhiên',
            requiredCredits: 20,
            optionalCredits: 0,
            courses: [
              Course(
                name: 'Vi tích phân 1B',
                credits: 3,
                id: 'MTH00003',
                type: CourseType.required,
                status: CourseStatus.completed,
                score: 6.5,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thực hành Vi tích phân 1B',
                credits: 1,
                id: 'MTH00081',
                type: CourseType.required,
                status: CourseStatus.completed,
                score: 6.5,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Vi tích phân 2B',
                credits: 3,
                id: 'MTH00004',
                type: CourseType.required,
                status: CourseStatus.inProgress,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thực hành Vi tích phân 2B',
                credits: 1,
                id: 'MTH00082',
                type: CourseType.required,
                status: CourseStatus.inProgress,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Đại số tuyến tính',
                credits: 3,
                id: 'MTH00030',
                type: CourseType.required,
                status: CourseStatus.inProgress,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thực hành Đại số tuyến tính',
                credits: 1,
                id: 'MTH00083',
                type: CourseType.required,
                status: CourseStatus.inProgress,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Xác suất thống kê',
                credits: 3,
                id: 'MTH00040',
                type: CourseType.required,
                status: CourseStatus.completed,
                score: 8.0,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thực hành Xác suất thống kê',
                credits: 1,
                id: 'MTH00085',
                type: CourseType.required,
                status: CourseStatus.completed,
                score: 8.0,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Toán rời rạc',
                credits: 3,
                id: 'MTH00041',
                type: CourseType.required,
                status: CourseStatus.completed,
                score: 10,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thực hành Toán rời rạc',
                credits: 1,
                id: 'MTH00086',
                type: CourseType.required,
                status: CourseStatus.completed,
                score: 10,
                prerequisiteCourses: [],
              ),
            ],
          ),
          CourseGroup(
            id: '1.4',
            name: 'Toán tự chọn',
            description: 'Các môn học toán tự chọn',
            requiredCredits: 0,
            optionalCredits: 4,
            courses: [
              Course(
                name: 'Toán học tổ hợp',
                credits: 4,
                id: 'MTH00050',
                type: CourseType.optional,
                status: CourseStatus.inProgress,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Lý thuyết đồ thị',
                credits: 4,
                id: 'CSC00008',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
            ],
          ),
          CourseGroup(
            id: '1.5',
            name: 'Toán tự chọn nâng cao',
            description: 'Các môn học toán tự chọn nâng cao',
            requiredCredits: 0,
            optionalCredits: 4,
            courses: [
              Course(
                name: 'Toán ứng dụng và thống kê',
                credits: 4,
                id: 'MTH00051',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Phương pháp tính',
                credits: 4,
                id: 'MTH00052',
                type: CourseType.optional,
                status: CourseStatus.inProgress,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Lý thuyết số',
                credits: 4,
                id: 'MTH00053',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              // Course(
              //   name: 'Phép tính vị từ',
              //   credits: 4,
              //   id: 'MTH00054',
              //   type: CourseType.optional,
              //   status: CourseStatus.notStarted,
              //   prerequisiteCourses: [],
              // ),
            ],
          ),
          CourseGroup(
            id: '1.6',
            name: 'Khoa học tự nhiên tự chọn',
            description: 'Các môn học khoa học tự nhiên tự chọn',
            requiredCredits: 0,
            optionalCredits: 6,
            courses: [
              Course(
                name: 'Hoá đại cương 1',
                credits: 3,
                id: 'CHE00001',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Hoá đại cương 2',
                credits: 3,
                id: 'CHE00002',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thực hành Hoá đại cương 1',
                credits: 2,
                id: 'CHE00081',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thực hành Hoá đại cương 2',
                credits: 2,
                id: 'CHE00082',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Sinh đại cương 1',
                credits: 3,
                id: 'BIO00001',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Sinh đại cương 2',
                credits: 3,
                id: 'BIO00002',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thực hành Sinh đại cương 1',
                credits: 1,
                id: 'BIO00081',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thực hành Sinh đại cương 2',
                credits: 1,
                id: 'BIO00082',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Vật lý đại cương 1 (Cơ - nhiệt)',
                credits: 3,
                id: 'PHY00001',
                type: CourseType.optional,
                status: CourseStatus.completed,
                score: 9.5,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Vật lý đại cương 2 (Điện tử - Quang)',
                credits: 3,
                id: 'PHY00002',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thực hành Vật lý đại cương',
                credits: 2,
                id: 'PHY00081',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
            ],
          ),
          CourseGroup(
            id: '1.7',
            name: 'Môi trường tự chọn',
            description: 'Các môn học về môi trường tự chọn',
            requiredCredits: 0,
            optionalCredits: 2,
            courses: [
              Course(
                name: 'Khoa học trái đất',
                credits: 2,
                id: 'GEO00002',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Môi trường đại cương',
                credits: 2,
                id: 'ENV00001',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Con người và môi trường',
                credits: 2,
                id: 'ENV00003',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
            ],
          ),
          CourseGroup(
            id: '1.8',
            name: 'Tin học tự chọn',
            description: 'Các môn học tin học tự chọn',
            requiredCredits: 0,
            optionalCredits: 4,
            courses: [
              Course(
                name: 'Tin học cơ sở',
                credits: 4,
                id: 'CSC00006',
                type: CourseType.optional,
                status: CourseStatus.completed,
                score: 7.5,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Nhập môn công nghệ thông tin',
                credits: 4,
                id: 'CSC00004',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
            ],
          ),
          CourseGroup(
            id: '1.9',
            name: 'Giáo dục thể chất - Quốc phòng',
            description: 'Giáo dục thể chất - Quốc phòng',
            requiredCredits: 8,
            optionalCredits: 0,
            courses: [
              Course(
                name: 'Giáo dục thể chất 1',
                credits: 2,
                id: 'BAA00021',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                score: 7.5,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Giáo dục thể chất 2',
                credits: 2,
                id: 'BAA00022',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Giáo dục quốc phòng - An ninh',
                credits: 4,
                id: 'BAA00030',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              )
            ],
          ),
        ],
      ),
      Section(
        name: 'Kiến thức cơ sở ngành',
        requiredCredits: 38,
        optionalCredits: 0,
        description: 'Nền tảng cho chuyên ngành',
        id: '2',
        courseGroups: [
          CourseGroup(
            id: '2.1',
            name: 'Kiến thức cơ sở ngành',
            description: 'Các môn học cơ sở ngành bắt buộc',
            requiredCredits: 38,
            optionalCredits: 0,
            courses: [
              Course(
                name: 'Nhập môn lập trình',
                credits: 4,
                id: 'CSC10001',
                type: CourseType.required,
                status: CourseStatus.completed,
                score: 8.5,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Kỹ thuật lập trình',
                credits: 4,
                id: 'CSC10002',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Phương pháp lập trình hướng đối tượng',
                credits: 4,
                id: 'CSC10003',
                type: CourseType.required,
                status: CourseStatus.inProgress,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Cấu trúc dữ liệu và giải thuật',
                credits: 4,
                id: 'CSC10004',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Cơ sở dữ liệu',
                credits: 4,
                id: 'CSC10006',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Hệ điều hành',
                credits: 4,
                id: 'CSC10007',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Mạng máy tính',
                credits: 4,
                id: 'CSC10008',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Hệ thống máy tính',
                credits: 2,
                id: 'CSC10009',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Nhập môn công nghệ phần mềm',
                credits: 4,
                id: 'CSC13002',
                type: CourseType.required,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Cơ sở trí tuệ nhân tạo',
                credits: 4,
                id: 'CSC14003',
                type: CourseType.required,
                status: CourseStatus.completed,
                score: 6.5,
                prerequisiteCourses: [],
              ),
            ],
          ),
        ],
      ),
      Section(
        name: 'Kiến thức chuyên ngành',
        requiredCredits: 0,
        optionalCredits: 34,
        description: 'Kiến thức chuyên sâu về ngành học',
        id: '3',
        courseGroups: [
          CourseGroup(
            id: '3.1',
            name: 'Kiến thức chuyên ngành',
            description: 'Các môn học chuyên ngành tự chọn',
            requiredCredits: 0,
            optionalCredits: 34,
            courses: [
              Course(
                name: 'Hệ thống viễn thông',
                credits: 4,
                id: 'CSC11002',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Ứng dụng dịch vụ điện toán đám mây cho doanh nghiệp',
                credits: 4,
                id: 'CSC11114',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'An toàn và bảo mật dữ liệu trong hệ thống thông tin',
                credits: 4,
                id: 'CSC12001',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Cơ sở dữ liệu nâng cao',
                credits: 4,
                id: 'CSC12002',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Hệ quản trị cơ sở dữ liệu',
                credits: 4,
                id: 'CSC12003',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Phân tích thiết kế hệ thống thông tin',
                credits: 4,
                id: 'CSC12004',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thương mại điện tử',
                credits: 4,
                id: 'CSC12005',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Môi trường và công cụ tiếp thị số',
                credits: 4,
                id: 'CSC12112',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Nhập môn quản trị mối quan hệ khách hàng - sản phẩm',
                credits: 4,
                id: 'CSC12113',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Kiểm thử phần mềm',
                credits: 4,
                id: 'CSC13003',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Quản lý dự án phần mềm',
                credits: 4,
                id: 'CSC13006',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Phát triển ứng dụng web',
                credits: 4,
                id: 'CSC13008',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Phát triển phần mềm cho thiết bị di động',
                credits: 4,
                id: 'CSC13009',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thiết kế phần mềm',
                credits: 4,
                id: 'CSC13010',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Lập trình web 1',
                credits: 4,
                id: 'CSC13119',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Lập trình web 2',
                credits: 4,
                id: 'CSC13120',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Lập trình quản lý ứng dụng 1',
                credits: 4,
                id: 'CSC13121',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Lập trình quản lý ứng dụng 2',
                credits: 4,
                id: 'CSC13122',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Học thống kê',
                credits: 4,
                id: 'CSC15004',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thống kê máy tính và ứng dụng',
                credits: 4,
                id: 'CSC15007',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
            ],
          ),
        ],
      ),
      Section(
        name: 'Kiến thức tốt nghiệp',
        requiredCredits: 0,
        optionalCredits: 10,
        description: 'Kiến thức tổng hợp tốt nghiệp',
        id: '4',
        courseGroups: [
          CourseGroup(
            id: '4.1',
            name: 'Kiến thức tốt nghiệp',
            description: 'Các môn học tốt nghiệp tự chọn',
            requiredCredits: 0,
            optionalCredits: 10,
            courses: [
              Course(
                name: 'Chuyên đề Tổ chức dữ liệu',
                credits: 6,
                id: 'CSC10202',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Chuyên đề thiết kế phần mềm nâng cao',
                credits: 6,
                id: 'CSC10203',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Hệ thống thông tin phục vụ trí tuệ kinh doanh',
                credits: 4,
                id: 'CSC12107',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Công nghệ mới trong phát triển phần mềm',
                credits: 4,
                id: 'CSC13115',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Phát triển ứng dụng cho thiết bị di động nâng cao',
                credits: 4,
                id: 'CSC13118',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Đồ án Phần mềm',
                credits: 6,
                id: 'CSC13123',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Khóa luận tốt nghiệp',
                credits: 10,
                id: 'CSC10251',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
              Course(
                name: 'Thực tập tốt nghiệp',
                credits: 10,
                id: 'CSC102512',
                type: CourseType.optional,
                status: CourseStatus.notStarted,
                prerequisiteCourses: [],
              ),
            ],
          ),
        ],
      ),
    ];

    await saveSections(sections);
  }

  Future<List<Section>> getSections() async {
    final sectionsJson = _prefs.getStringList(_programKey) ?? [];
    return sectionsJson
        .map((json) => Section.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveSections(List<Section> sections) async {
    final preferences = await prefs;
    final sectionsJson =
        sections.map((section) => jsonEncode(section.toJson())).toList();
    await preferences.setStringList(_programKey, sectionsJson);
  }

  Future<void> addCourse(String sectionId, String groupId, Course course) async {
    final sections = await getSections();
    final section = sections.firstWhere((s) => s.id == sectionId);
    final group = section.courseGroups.firstWhere((g) => g.id == groupId);
    group.courses.add(course);
    await saveSections(sections);
  }

  Future<void> updateCourse(String sectionId, String groupId, Course course) async {
    final sections = await getSections();
    final section = sections.firstWhere((s) => s.id == sectionId);
    final group = section.courseGroups.firstWhere((g) => g.id == groupId);
    final index = group.courses.indexWhere((c) => c.id == course.id);
    if (index != -1) {
      group.courses[index] = course;
      await saveSections(sections);
    }
  }

  Future<void> deleteCourse(String sectionId, String groupId, String courseId) async {
    final sections = await getSections();
    final section = sections.firstWhere((s) => s.id == sectionId);
    final group = section.courseGroups.firstWhere((g) => g.id == groupId);
    group.courses.removeWhere((c) => c.id == courseId);
    await saveSections(sections);
  }

  Future<void> addCourseToSection(String sectionId, Course course) async {
    final sections = await getSections();
    final sectionIndex = sections.indexWhere((s) => s.id == sectionId);
    if (sectionIndex != -1) {
      sections[sectionIndex].courseGroups[0].courses.add(course);
      await saveSections(sections);
    }
  }

  Future<double> calculateSectionProgress(Section section, int totalCredits) async {
    if (section.courseGroups.isEmpty) return 0;
    final completedCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.score != null && course.score! >= 5.0)
        .fold(0, (sum, course) => sum + course.credits);
    return (completedCredits / totalCredits) * 100;
  }

  Future<ProgressModel> getProgress(int totalCredits) async {
    final sections = await getSections();

    // Tính toán tín chỉ bắt buộc
    final completedRequiredCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.completed && c.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressRequiredCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.inProgress &&
            c.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final registeringRequiredCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.registering &&
            c.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final needToRegisterRequiredCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.needToRegister &&
            c.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final notStartedRequiredCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.notStarted &&
            c.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final failedRequiredCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.failed &&
            c.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    // Tính toán tín chỉ tự chọn
    final completedOptionalCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.completed && c.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressOptionalCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.inProgress &&
            c.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final registeringOptionalCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.registering &&
            c.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final needToRegisterOptionalCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.needToRegister &&
            c.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final notStartedOptionalCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.notStarted &&
            c.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final failedOptionalCredits = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) =>
            c.status == CourseStatus.failed &&
            c.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    // Tính tổng số tín chỉ yêu cầu cho mỗi loại
    final totalRequiredCredits =
        sections.fold(0, (sum, section) => sum + section.requiredCredits);

    final totalOptionalCredits =
        sections.fold(0, (sum, section) => sum + section.optionalCredits);

    // Tính tổng số tín chỉ theo trạng thái
    final totalCompletedCredits = completedRequiredCredits + completedOptionalCredits;
    final totalInProgressCredits = inProgressRequiredCredits + inProgressOptionalCredits;
    final totalRegisteringCredits = registeringRequiredCredits + registeringOptionalCredits;
    final totalNeedToRegisterCredits = needToRegisterRequiredCredits + needToRegisterOptionalCredits;
    final totalNotStartedCredits = notStartedRequiredCredits + notStartedOptionalCredits;
    final totalFailedCredits = failedRequiredCredits + failedOptionalCredits;

    // Đếm số môn học theo trạng thái
    final completedCourses = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) => c.status == CourseStatus.completed)
        .length;

    final inProgressCourses = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) => c.status == CourseStatus.inProgress)
        .length;

    final registeringCourses = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) => c.status == CourseStatus.registering)
        .length;

    final needToRegisterCourses = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) => c.status == CourseStatus.needToRegister)
        .length;

    final notStartedCourses = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) => c.status == CourseStatus.notStarted)
        .length;

    final failedCourses = sections
        .expand((s) => s.courseGroups)
        .expand((g) => g.courses)
        .where((c) => c.status == CourseStatus.failed)
        .length;

    return ProgressModel(
      totalCredits: totalCredits,
      completedCredits: totalCompletedCredits,
      inProgressCredits: totalInProgressCredits,
      remainingCredits: totalCredits - totalCompletedCredits,
      percentage: (totalCompletedCredits / totalCredits * 100).clamp(0, 100),
      // Tín chỉ bắt buộc
      completedRequiredCredits: completedRequiredCredits,
      inProgressRequiredCredits: inProgressRequiredCredits,
      registeringRequiredCredits: registeringRequiredCredits,
      needToRegisterRequiredCredits: needToRegisterRequiredCredits,
      notStartedRequiredCredits: notStartedRequiredCredits,
      failedRequiredCredits: failedRequiredCredits,
      totalRequiredCredits: totalRequiredCredits,
      // Tín chỉ tự chọn
      completedOptionalCredits: completedOptionalCredits,
      inProgressOptionalCredits: inProgressOptionalCredits,
      registeringOptionalCredits: registeringOptionalCredits,
      needToRegisterOptionalCredits: needToRegisterOptionalCredits,
      notStartedOptionalCredits: notStartedOptionalCredits,
      failedOptionalCredits: failedOptionalCredits,
      totalOptionalCredits: totalOptionalCredits,
      // Tổng số tín chỉ theo trạng thái
      totalRegisteringCredits: totalRegisteringCredits,
      totalNeedToRegisterCredits: totalNeedToRegisterCredits,
      totalNotStartedCredits: totalNotStartedCredits,
      totalFailedCredits: totalFailedCredits,
      // Số môn học theo trạng thái
      completedCourses: completedCourses,
      inProgressCourses: inProgressCourses,
      registeringCourses: registeringCourses,
      needToRegisterCourses: needToRegisterCourses,
      notStartedCourses: notStartedCourses,
      failedCourses: failedCourses,
    );
  }

  Future<Map<String, dynamic>> getMissingRequiredCredits() async {
    final sections = await getSections();
    bool hasMissingCredits = false;
    final sectionData = sections.map((section) {
      // Calculate completed credits
      final completedRequired = section.courseGroups
          .expand((group) => group.courses)
          .where((c) => c.status == CourseStatus.completed && c.type == CourseType.required)
          .fold(0, (sum, course) => sum + course.credits);

      final completedOptional = section.courseGroups
          .expand((group) => group.courses)
          .where((c) => c.status == CourseStatus.completed && c.type == CourseType.optional)
          .fold(0, (sum, course) => sum + course.credits);

      // Calculate in-progress credits
      final inProgressRequired = section.courseGroups
          .expand((group) => group.courses)
          .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.required)
          .fold(0, (sum, course) => sum + course.credits);

      final inProgressOptional = section.courseGroups
          .expand((group) => group.courses)
          .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.optional)
          .fold(0, (sum, course) => sum + course.credits);

      // Calculate missing credits
      final missingRequired = section.requiredCredits - completedRequired - inProgressRequired;
      final missingOptional = section.optionalCredits - completedOptional - inProgressOptional;

      if (missingRequired > 0 || missingOptional > 0) {
        hasMissingCredits = true;
      }

      return {
        'name': section.name,
        'requiredCredits': section.requiredCredits,
        'optionalCredits': section.optionalCredits,
        'completedRequired': completedRequired,
        'completedOptional': completedOptional,
        'inProgressRequired': inProgressRequired,
        'inProgressOptional': inProgressOptional,
        'missingRequired': missingRequired > 0 ? missingRequired : 0,
        'missingOptional': missingOptional > 0 ? missingOptional : 0,
      };
    }).toList();

    return {
      'hasMissingCredits': hasMissingCredits,
      'sections': sectionData,
    };
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

  Future<void> addCourseGroup(String sectionId, CourseGroup group) async {
    final sections = await getSections();
    final section = sections.firstWhere((s) => s.id == sectionId);
    section.courseGroups.add(group);
    await saveSections(sections);
  }

  Future<void> updateCourseGroup(String sectionId, CourseGroup updatedGroup) async {
    final sections = await getSections();
    final section = sections.firstWhere((s) => s.id == sectionId);
    final index = section.courseGroups.indexWhere((g) => g.id == updatedGroup.id);
    if (index != -1) {
      section.courseGroups[index] = updatedGroup;
      await saveSections(sections);
    }
  }

  Future<void> deleteCourseGroup(String sectionId, String groupId) async {
    final sections = await getSections();
    final section = sections.firstWhere((s) => s.id == sectionId);
    section.courseGroups.removeWhere((g) => g.id == groupId);
    await saveSections(sections);
  }

  Future<Section?> getSection(String sectionId) async {
    final sections = await getSections();
    try {
      return sections.firstWhere((section) => section.id == sectionId);
    } catch (e) {
      return null;
    }
  }
}
