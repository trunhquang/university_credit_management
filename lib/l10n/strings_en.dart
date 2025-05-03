import 'app_strings.dart';

class EnglishStrings implements AppStrings {
  @override
  String get appName => 'Credit Management';

  @override
  String get addMajor => 'Add Major';

  @override
  String get addSection => 'Add Section';

  @override
  String get addSubsection => 'Add Subsection';

  @override
  String get addCourse => 'Add Course';

  @override
  String get majorName => 'Major Name';

  @override
  String get sectionName => 'Section Name';

  @override
  String get subsectionName => 'Subsection Name';

  @override
  String get courseName => 'Course Name';

  @override
  String get credits => 'Credits';

  @override
  String get totalCredits => 'Total Credits';

  @override
  String get requiredCredits => 'Required Credits';

  @override
  String get completedCredits => 'Completed Credits';

  @override
  String get remainingCredits => 'Remaining Credits';

  @override
  String get progressText => 'Progress';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get description => 'Description';

  @override
  String get courses => 'Courses';

  @override
  String get progress => 'Progress';

  @override
  String get settings => 'Settings';

  @override
  String get supportAuthor => 'Support Author';

  @override
  String get thankYouForSupport => 'Thank you for supporting the author! ❤️';

  @override
  String get supportDescription => 'You can support by watching a short ad. '
      'This will help the author to continue developing the app.';

  @override
  String get loadingAd => 'Loading ad...';

  @override
  String get watchAdToSupport => 'Watch ad to support';

  @override
  String get thankYouMessage => '❤️ Thank you for your support! Good luck with your studies!';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Try Again';

  @override
  String get contactEmail => 'Contact us at: trunhquang9@gmail.com';

  @override
  String get thankYouForUsing => 'Thank you for using our app!';

  @override
  String get adLoadFailed => 'Failed to load ad. Please try again later.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get englishRequirements => 'English Requirements';

  @override
  String get certificateType => 'Certificate Type';

  @override
  String get minimumScore => 'Minimum Required Score';

  @override
  String get achievedScore => 'Achieved Score';

  @override
  String get minimumScoreHelper => 'Minimum score required';

  @override
  String get achievedScoreHelper => 'Your achieved score (leave empty if not available)';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get settingsSaved => 'Settings saved successfully';

  @override
  String get settingsError => 'Error saving settings';

  @override
  String get loadingSettingsError => 'Error loading settings';

  @override
  String get pleaseEnterScore => 'Please enter a score';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get scoreMustBeHigher => 'Score must be higher than or equal to required score';

  @override
  String get englishRequirementInfo => 'English Certificate Requirements';

  @override
  String get englishRequirementDescription => 'Students need to achieve one of the following certificates:';

  @override
  String get englishPassed => 'English requirement met';

  @override
  String get englishNotPassed => 'English requirement not met';

  @override
  String get noCertificate => 'No certificate';

  @override
  String get programOverview => 'Program Overview';

  @override
  String get gpa => 'GPA:';

  @override
  String get completionProgress => 'Completion Progress';

  @override
  String get optionalCredits => 'Optional Credits:';

  @override
  String get englishCertificate => 'English Certificate';

  @override
  String get requiredScore => 'Required Score:';
}

class StringsEn {
  // App title
  static const String appTitle = 'Credit Management';

  // Navigation items
  static const String courses = 'Courses';
  static const String progress = 'Progress';
  static const String settings = 'Settings';
  static const String supportAuthor = 'Support Author';

  // Support dialog
  static const String supportDialogTitle = 'Support Author';
  static const String supportDialogThanks = 'Thank you for supporting the author! ❤️';
  static const String supportDialogDescription = 'You can support by watching a short ad. '
      'This will help the author to continue developing the app.';
  static const String loadingAd = 'Loading ad...';
  static const String watchAd = 'Watch ad to support';
  static const String close = 'Close';
  static const String thankYouMessage = '❤️ Thank you for your support! Good luck with your studies!';

  // Error messages
  static const String loadingData = 'Loading data, please wait...';
  static const String adLoadError = 'Failed to load ad. Please try again later.';
  static const String adShowError = 'Failed to show ad. Please try again later.';
  static const String tryAgain = 'Try Again';

  // Footer
  static const String contactEmail = 'Contact us at: trunhquang9@gmail.com';
  static const String thankYou = 'Thank you for using our app!';

  // Settings screen
  static const String settingsTitle = 'Settings';
  static const String englishRequirements = 'English Requirements';
  static const String certificateType = 'Certificate Type';
  static const String minimumScore = 'Minimum Required Score';
  static const String achievedScore = 'Achieved Score';
  static const String minimumScoreHelper = 'Minimum score required';
  static const String achievedScoreHelper = 'Your achieved score (leave empty if not available)';
  static const String saveSettings = 'Save Settings';
  static const String settingsSaved = 'Settings saved successfully';
  static const String settingsError = 'Error saving settings';
  static const String loadingSettingsError = 'Error loading settings';
  static const String pleaseEnterScore = 'Please enter a score';
  static const String pleaseEnterValidNumber = 'Please enter a valid number';
  static const String scoreMustBeHigher = 'Score must be higher than or equal to required score';
  static const String englishRequirementInfo = 'English Certificate Requirements';
  static const String englishRequirementDescription = 'Students need to achieve one of the following certificates:';
  static const String englishPassed = 'English requirement met';
  static const String englishNotPassed = 'English requirement not met';

  // Home Screen
  String get homeTitle => 'Home';
  String get edit => 'Edit';
  String get confirm => 'Confirm';
  String get deleteConfirmation => 'Are you sure you want to delete this?';
}