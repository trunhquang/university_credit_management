abstract class AppStrings {
  String get appName;
  String get addMajor;
  String get addSection;
  String get addSubsection;
  String get addCourse;
  String get majorName;
  String get sectionName;
  String get subsectionName;
  String get courseName;
  String get credits;
  String get totalCredits;
  String get requiredCredits;
  String get completedCredits;
  String get remainingCredits;
  String get progressText;
  String get save;
  String get cancel;
  String get description;
  String get courses;
  String get progress;
  String get settings;
  String get supportAuthor;
  String get thankYouForSupport;
  String get supportDescription;
  String get loadingAd;
  String get watchAdToSupport;
  String get thankYouMessage;
  String get close;
  String get retry;
  String get contactEmail;
  String get thankYouForUsing;
  String get adLoadFailed;
  String get settingsTitle;
  String get englishRequirements;
  String get certificateType;
  String get minimumScore;
  String get achievedScore;
  String get minimumScoreHelper;
  String get achievedScoreHelper;
  String get saveSettings;
  String get settingsSaved;
  String get settingsError;
  String get loadingSettingsError;
  String get pleaseEnterScore;
  String get pleaseEnterValidNumber;
  String get scoreMustBeHigher;
  String get englishRequirementInfo;
  String get englishRequirementDescription;
  String get englishPassed;
  String get englishNotPassed;
  String get noCertificate;
  String get programOverview;
  String get gpa;
  String get completionProgress;
  String get optionalCredits;
  String get englishCertificate;
  String get requiredScore;
  String get edit;
  String get delete;
  String get confirmDelete;
  String get sections;
  String get noSections;
  String get sectionAdded;
  String get sectionUpdated;
  String get sectionDeleted;
  String deleteSectionConfirmation(String sectionName);
  String get required;
  String get optional;

  // Course Detail Screen
  String get completedCourses;
  String get inProgressCourses;
  String get notStartedCourses;
  String get courseType;
  String get grade;
  String get prerequisiteCourses;
  String courseDeleteConfirmation(String courseName);

  // Course Group Management
  String get courseGroups => 'Nhóm môn học';
  String get createGroup => 'Tạo nhóm mới';
  String get group => 'Nhóm';
  String get selectCourses => 'Chọn môn học';
  String get create => 'Tạo';
  String get groupCreated => 'Đã tạo nhóm';
  String get courseRemovedFromGroup => 'Đã xóa môn học khỏi nhóm';
  String get groupRemoved => 'Đã xóa nhóm';

  // Course Selection
  String get selected => 'đã chọn';
  String get clearSelection => 'Xóa chọn';

  // Group Management
  String get groupMinTwoCourses => 'Mỗi nhóm cần ít nhất 2 môn học';
  String get removeFromGroup => 'Xóa khỏi nhóm';
}