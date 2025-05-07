import 'app_strings.dart';

class VietnameseStrings implements AppStrings {
  @override
  String get appName => 'Quản lý tín chỉ';

  @override
  String get addMajor => 'Thêm ngành học';

  @override
  String get addSection => 'Thêm phần';

  @override
  String get addSubsection => 'Thêm mục';

  @override
  String get addCourse => 'Thêm môn học';

  @override
  String get editCourse => 'Sửa môn học';

  @override
  String get courseId => 'Mã môn học';

  @override
  String get courseName => 'Tên môn học';

  @override
  String get courseType => 'Loại môn học';

  @override
  String get status => 'Trạng thái';

  @override
  String get courseRemoved => 'Môn học sẽ bị xóa';

  @override
  String get majorName => 'Tên ngành học';

  @override
  String get sectionName => 'Tên phần';

  @override
  String get subsectionName => 'Tên mục';

  @override
  String get credits => 'Số tín chỉ';

  @override
  String get totalCredits => 'Tổng số tín chỉ';

  @override
  String get requiredCredits => 'Số tín chỉ bắt buộc';

  @override
  String get completedCredits => 'Số tín chỉ đã hoàn thành';

  @override
  String get remainingCredits => 'Số tín chỉ còn lại';

  @override
  String get progressText => 'Tiến độ';

  @override
  String get save => 'Lưu';

  @override
  String get cancel => 'Hủy';

  @override
  String get description => 'Mô tả';

  @override
  String get courses => 'Môn học';

  @override
  String get progress => 'Tiến độ';

  @override
  String get settings => 'Cài đặt';

  @override
  String get supportAuthor => 'Ủng hộ tác giả';

  @override
  String get thankYouForSupport => 'Cảm ơn bạn đã quan tâm đến việc ủng hộ tác giả! ❤️';

  @override
  String get supportDescription => 'Bạn có thể ủng hộ bằng cách xem một quảng cáo ngắn. '
      'Điều này sẽ giúp tác giả có thêm động lực phát triển ứng dụng tốt hơn.';

  @override
  String get loadingAd => 'Đang tải quảng cáo...';

  @override
  String get watchAdToSupport => 'Xem quảng cáo để ủng hộ';

  @override
  String get thankYouMessage => '❤️ Cảm ơn bạn đã ủng hộ! Chúc bạn học tập tốt!';

  @override
  String get close => 'Đóng';

  @override
  String get retry => 'Thử lại';

  @override
  String get contactEmail => 'Mọi đóng góp xin gửi về: trunhquang9@gmail.com';

  @override
  String get thankYouForUsing => 'Xin chân thành cảm ơn bạn đã sử dụng ứng dụng!';

  @override
  String get adLoadFailed => 'Không thể tải quảng cáo. Vui lòng thử lại sau.';

  @override
  String get functionDeveloping => 'Chức năng này đang được phát triển. Vui lòng quay lại sau.';

  // App title
  static const String appTitle = 'Quản lý tín chỉ';

  // Navigation items
  static const String supportDialogTitle = 'Ủng hộ tác giả';
  static const String loadingData = 'Đang tải dữ liệu, vui lòng đợi...';
  static const String adShowError = 'Không thể hiển thị quảng cáo. Vui lòng thử lại sau.';
  static const String tryAgain = 'Thử lại';

  // Footer
  static const String thankYou = 'Xin chân thành cảm ơn bạn đã sử dụng ứng dụng!';

  // Settings screen
  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get englishRequirements => 'Yêu cầu tiếng Anh';

  @override
  String get certificateType => 'Loại chứng chỉ';

  @override
  String get minimumScore => 'Điểm tối thiểu';

  @override
  String get achievedScore => 'Điểm đạt được';

  @override
  String get minimumScoreHelper => 'Nhập điểm tối thiểu yêu cầu';

  @override
  String get achievedScoreHelper => 'Nhập điểm bạn đã đạt được';

  @override
  String get saveSettings => 'Lưu cài đặt';

  @override
  String get settingsSaved => 'Đã lưu cài đặt';

  @override
  String get settingsError => 'Lỗi khi lưu cài đặt';

  @override
  String get loadingSettingsError => 'Lỗi khi tải cài đặt';

  @override
  String get pleaseEnterScore => 'Vui lòng nhập điểm';

  @override
  String get pleaseEnterValidNumber => 'Vui lòng nhập số hợp lệ';

  @override
  String get scoreMustBeHigher => 'Điểm phải lớn hơn hoặc bằng điểm tối thiểu';

  @override
  String get englishRequirementInfo => 'Thông tin yêu cầu tiếng Anh';

  @override
  String get englishRequirementDescription => 'Bạn cần đạt một trong các chứng chỉ tiếng Anh sau:';

  @override
  String get englishPassed => 'Đã đạt yêu cầu';

  @override
  String get englishNotPassed => 'Chưa đạt yêu cầu';

  @override
  String get noCertificate => 'Chưa có chứng chỉ';

  // Home Screen
  String get homeTitle => 'Trang chủ';
  String get delete => 'Xóa';
  String get edit => 'Sửa';
  String get deleteConfirmation => 'Bạn có chắc chắn muốn xóa?';

  @override
  String get englishRequirementMet => 'Đã đạt yêu cầu tiếng Anh';

  @override
  String get englishRequirementNotMet => 'Chưa đạt yêu cầu tiếng Anh';

  @override
  String get settingsUpdated => 'Đã cập nhật cài đặt thành công';

  @override
  String errorLoadingSettings(String error) => 'Lỗi khi tải cài đặt: $error';

  @override
  String errorSavingSettings(String error) => 'Lỗi khi lưu cài đặt: $error';

  // Program Overview
  @override
  String get programOverview => 'Tổng quan chương trình';

  @override
  String get gpa => 'Điểm trung bình';

  @override
  String get completionProgress => 'Tiến độ hoàn thành';

  @override
  String get optionalCredits => 'Tín chỉ tự chọn';

  @override
  String get englishCertificate => 'Chứng chỉ tiếng Anh';

  @override
  String get requiredScore => 'Điểm yêu cầu';

  @override
  String get confirmDelete => 'Xác nhận xóa';

  @override
  String get sections => 'Khối kiến thức';

  @override
  String get noSections => 'Chưa có khối kiến thức nào';

  @override
  String get sectionAdded => 'Đã thêm khối kiến thức';

  @override
  String get sectionUpdated => 'Đã cập nhật khối kiến thức';

  @override
  String get sectionDeleted => 'Đã xóa khối kiến thức';

  @override
  String deleteSectionConfirmation(String sectionName) => 
      'Bạn có chắc muốn xóa khối kiến thức "$sectionName"?\n'
      'Tất cả môn học trong khối này cũng sẽ bị xóa.';

  @override
  String get required => 'Bắt buộc';

  @override
  String get optional => 'Tự chọn';

  @override
  String get completedCourses => 'Đã hoàn thành';

  @override
  String get inProgressCourses => 'Đang học';

  @override
  String get notStartedCourses => 'Chưa học';

  @override
  String get grade => 'Điểm';

  @override
  String get prerequisiteCourses => 'Môn học tiên quyết';

  @override
  String courseDeleteConfirmation(String courseName) => 
      'Bạn có chắc muốn xóa môn "$courseName"?';

  @override
  String get courseGroups => 'Nhóm môn học';

  @override
  String get createGroup => 'Tạo nhóm mới';

  @override
  String get group => 'Nhóm';

  @override
  String get selectCourses => 'Chọn môn học';

  @override
  String get create => 'Tạo';

  @override
  String get groupCreated => 'Đã tạo nhóm';

  @override
  String get courseRemovedFromGroup => 'Đã xóa môn học khỏi nhóm';

  @override
  String get groupRemoved => 'Đã xóa nhóm';

  @override
  String get selected => 'đã chọn';

  @override
  String get clearSelection => 'Xóa chọn';

  @override
  String get groupMinTwoCourses => 'Mỗi nhóm cần ít nhất 2 môn học';

  @override
  String get removeFromGroup => 'Xóa khỏi nhóm';

  @override
  String get completed => 'Hoàn thành';

  @override
  String get inProgress => 'Đang học';

  @override
  String get notStarted => 'Chưa học';

  @override
  String get failed => 'Không đạt';

  @override
  String get editSection => 'Sửa khối kiến thức';

  @override
  String get sectionNameRequired => 'Vui lòng nhập tên khối kiến thức';

  @override
  String get requiredCreditsRequired => 'Vui lòng nhập số tín chỉ bắt buộc';

  @override
  String get optionalCreditsRequired => 'Vui lòng nhập số tín chỉ tự chọn';

  @override
  String get creditsMustBePositive => 'Số tín chỉ phải là số nguyên không âm';

  @override
  String get add => 'Thêm';

  @override
  String get update => 'Cập nhật';

  @override
  String get total => 'Tổng';

  @override
  String get enterScore => 'Nhập Điểm';

  @override
  String get score => 'Điểm';
} 