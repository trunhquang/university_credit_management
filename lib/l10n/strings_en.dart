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
  String get functionDeveloping => 'This function is under development.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get englishRequirements => 'English Requirements';

  @override
  String get certificateType => 'Certificate Type';

  @override
  String get minimumScore => 'Minimum Score';

  @override
  String get achievedScore => 'Achieved Score';

  @override
  String get minimumScoreHelper => 'Enter the minimum required score';

  @override
  String get achievedScoreHelper => 'Enter your achieved score';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get settingsError => 'Error saving settings';

  @override
  String get loadingSettingsError => 'Error loading settings';

  @override
  String get pleaseEnterScore => 'Please enter a score';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get scoreMustBeHigher => 'Score must be higher than or equal to minimum score';

  @override
  String get englishRequirementInfo => 'English Requirement Information';

  @override
  String get englishRequirementDescription => 'You need to achieve one of the following English certificates:';

  @override
  String get englishPassed => 'Requirements met';

  @override
  String get englishNotPassed => 'Requirements not met';

  @override
  String get noCertificate => 'No certificate';

  @override
  String get programOverview => 'Program Overview';

  @override
  String get gpa => 'GPA';

  @override
  String get completionProgress => 'Completion Progress';

  @override
  String get optionalCredits => 'Optional Credits';

  @override
  String get englishCertificate => 'English Certificate';

  @override
  String get requiredScore => 'Required Score';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get sections => 'Knowledge Blocks';

  @override
  String get noSections => 'No knowledge blocks yet';

  @override
  String get sectionAdded => 'Knowledge block added';

  @override
  String get sectionUpdated => 'Knowledge block updated';

  @override
  String get sectionDeleted => 'Knowledge block deleted';

  @override
  String deleteSectionConfirmation(String sectionName) => 
      'Are you sure you want to delete the knowledge block "$sectionName"?\n'
      'All courses in this block will also be deleted.';

  @override
  String get required => 'Required';

  @override
  String get optional => 'Optional';

  @override
  String get completedCourses => 'Completed';

  @override
  String get inProgressCourses => 'In Progress';

  @override
  String get notStartedCourses => 'Not Started';

  @override
  String get courseType => 'Course Type';

  @override
  String get grade => 'Grade';

  @override
  String get prerequisiteCourses => 'Prerequisite Courses';

  @override
  String courseDeleteConfirmation(String courseName) => 
      'Are you sure you want to delete the course "$courseName"?';

  @override
  String get courseGroups => 'Course Groups';

  @override
  String get createGroup => 'Create New Group';

  @override
  String get group => 'Group';

  @override
  String get selectCourses => 'Select Courses';

  @override
  String get create => 'Create';

  @override
  String get groupCreated => 'Group created';

  @override
  String get courseRemovedFromGroup => 'Course removed from group';

  @override
  String get groupRemoved => 'Group removed';

  @override
  String get selected => 'selected';

  @override
  String get clearSelection => 'Clear selection';

  @override
  String get groupMinTwoCourses => 'Each group must have at least 2 courses';

  @override
  String get removeFromGroup => 'Remove from group';

  @override
  String get completed => 'Completed';

  @override
  String get inProgress => 'In Progress';

  @override
  String get notStarted => 'Not Started';

  @override
  String get failed => 'Failed';

  @override
  String get editSection => 'Edit Section';

  @override
  String get sectionNameRequired => 'Please enter section name';

  @override
  String get requiredCreditsRequired => 'Please enter required credits';

  @override
  String get optionalCreditsRequired => 'Please enter optional credits';

  @override
  String get creditsMustBePositive => 'Credits must be a positive number';

  @override
  String get add => 'Add';

  @override
  String get update => 'Update';

  @override
  String get editCourse => 'Edit Course';

  @override
  String get courseId => 'Course ID';

  @override
  String get status => 'Status';

  @override
  String get courseRemoved => 'Course will be removed';

  @override
  String get total => 'Total';
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

  // Home Screen
  String get homeTitle => 'Home';
  String get edit => 'Edit';
  String get confirm => 'Confirm';
  String get deleteConfirmation => 'Are you sure you want to delete this?';
}