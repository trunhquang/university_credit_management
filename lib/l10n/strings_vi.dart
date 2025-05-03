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
  String get majorName => 'Tên ngành học';

  @override
  String get sectionName => 'Tên phần';

  @override
  String get subsectionName => 'Tên mục';

  @override
  String get courseName => 'Tên môn học';

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
  String get englishRequirements => 'Điều kiện tiếng Anh';

  @override
  String get certificateType => 'Loại chứng chỉ';

  @override
  String get minimumScore => 'Điểm yêu cầu tối thiểu';

  @override
  String get achievedScore => 'Điểm đạt được';

  @override
  String get minimumScoreHelper => 'Điểm tối thiểu cần đạt được';

  @override
  String get achievedScoreHelper => 'Điểm bạn đã đạt được (để trống nếu chưa có)';

  @override
  String get saveSettings => 'Lưu cài đặt';

  @override
  String get settingsSaved => 'Đã cập nhật cài đặt thành công';

  @override
  String get settingsError => 'Lỗi khi lưu cài đặt';

  @override
  String get loadingSettingsError => 'Lỗi khi tải cài đặt';

  @override
  String get pleaseEnterScore => 'Vui lòng nhập điểm yêu cầu';

  @override
  String get pleaseEnterValidNumber => 'Vui lòng nhập số hợp lệ';

  @override
  String get scoreMustBeHigher => 'Điểm phải lớn hơn hoặc bằng điểm yêu cầu';

  @override
  String get englishRequirementInfo => 'Yêu cầu chứng chỉ tiếng Anh';

  @override
  String get englishRequirementDescription => 'Sinh viên cần đạt một trong các chứng chỉ sau:';

  @override
  String get englishPassed => 'Đã đạt yêu cầu tiếng Anh';

  @override
  String get englishNotPassed => 'Chưa đạt yêu cầu tiếng Anh';

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
  String get gpa => 'Điểm trung bình:';

  @override
  String get completionProgress => 'Tiến độ hoàn thành';

  @override
  String get optionalCredits => 'Tín chỉ tự chọn:';

  @override
  String get englishCertificate => 'Chứng chỉ tiếng Anh';

  @override
  String get requiredScore => 'Điểm yêu cầu:';
} 