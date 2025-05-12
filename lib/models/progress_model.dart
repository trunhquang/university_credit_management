class ProgressModel {
  // Tổng quan
  final int totalCredits;
  final int completedCredits;
  final int inProgressCredits;
  final int remainingCredits;
  final double percentage;

  // Tín chỉ bắt buộc
  final int completedRequiredCredits;
  final int inProgressRequiredCredits;
  final int registeringRequiredCredits;
  final int needToRegisterRequiredCredits;
  final int notStartedRequiredCredits;
  final int failedRequiredCredits;
  final int totalRequiredCredits;

  // Tín chỉ tự chọn
  final int completedOptionalCredits;
  final int inProgressOptionalCredits;
  final int registeringOptionalCredits;
  final int needToRegisterOptionalCredits;
  final int notStartedOptionalCredits;
  final int failedOptionalCredits;
  final int totalOptionalCredits;

  // Tổng số tín chỉ theo trạng thái
  final int totalRegisteringCredits;
  final int totalNeedToRegisterCredits;
  final int totalNotStartedCredits;
  final int totalFailedCredits;

  // Số môn học theo trạng thái
  final int completedCourses;
  final int inProgressCourses;
  final int registeringCourses;
  final int needToRegisterCourses;
  final int notStartedCourses;
  final int failedCourses;

  int get totalCourses => completedCourses + inProgressCourses + registeringCourses + needToRegisterCourses + notStartedCourses + failedCourses;

  ProgressModel({
    required this.totalCredits,
    required this.completedCredits,
    required this.inProgressCredits,
    required this.remainingCredits,
    required this.percentage,
    required this.completedRequiredCredits,
    required this.inProgressRequiredCredits,
    required this.registeringRequiredCredits,
    required this.needToRegisterRequiredCredits,
    required this.notStartedRequiredCredits,
    required this.failedRequiredCredits,
    required this.totalRequiredCredits,
    required this.completedOptionalCredits,
    required this.inProgressOptionalCredits,
    required this.registeringOptionalCredits,
    required this.needToRegisterOptionalCredits,
    required this.notStartedOptionalCredits,
    required this.failedOptionalCredits,
    required this.totalOptionalCredits,
    required this.totalRegisteringCredits,
    required this.totalNeedToRegisterCredits,
    required this.totalNotStartedCredits,
    required this.totalFailedCredits,
    required this.completedCourses,
    required this.inProgressCourses,
    required this.registeringCourses,
    required this.needToRegisterCourses,
    required this.notStartedCourses,
    required this.failedCourses,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      totalCredits: json['totalCredits'] as int? ?? 0,
      completedCredits: json['completedCredits'] as int? ?? 0,
      inProgressCredits: json['inProgressCredits'] as int? ?? 0,
      remainingCredits: json['remainingCredits'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      completedRequiredCredits: json['completedRequiredCredits'] as int? ?? 0,
      inProgressRequiredCredits: json['inProgressRequiredCredits'] as int? ?? 0,
      registeringRequiredCredits: json['registeringRequiredCredits'] as int? ?? 0,
      needToRegisterRequiredCredits: json['needToRegisterRequiredCredits'] as int? ?? 0,
      notStartedRequiredCredits: json['notStartedRequiredCredits'] as int? ?? 0,
      failedRequiredCredits: json['failedRequiredCredits'] as int? ?? 0,
      totalRequiredCredits: json['totalRequiredCredits'] as int? ?? 0,
      completedOptionalCredits: json['completedOptionalCredits'] as int? ?? 0,
      inProgressOptionalCredits: json['inProgressOptionalCredits'] as int? ?? 0,
      registeringOptionalCredits: json['registeringOptionalCredits'] as int? ?? 0,
      needToRegisterOptionalCredits: json['needToRegisterOptionalCredits'] as int? ?? 0,
      notStartedOptionalCredits: json['notStartedOptionalCredits'] as int? ?? 0,
      failedOptionalCredits: json['failedOptionalCredits'] as int? ?? 0,
      totalOptionalCredits: json['totalOptionalCredits'] as int? ?? 0,
      totalRegisteringCredits: json['totalRegisteringCredits'] as int? ?? 0,
      totalNeedToRegisterCredits: json['totalNeedToRegisterCredits'] as int? ?? 0,
      totalNotStartedCredits: json['totalNotStartedCredits'] as int? ?? 0,
      totalFailedCredits: json['totalFailedCredits'] as int? ?? 0,
      completedCourses: json['completedCourses'] as int? ?? 0,
      inProgressCourses: json['inProgressCourses'] as int? ?? 0,
      registeringCourses: json['registeringCourses'] as int? ?? 0,
      needToRegisterCourses: json['needToRegisterCourses'] as int? ?? 0,
      notStartedCourses: json['notStartedCourses'] as int? ?? 0,
      failedCourses: json['failedCourses'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCredits': totalCredits,
      'completedCredits': completedCredits,
      'inProgressCredits': inProgressCredits,
      'remainingCredits': remainingCredits,
      'percentage': percentage,
      'completedRequiredCredits': completedRequiredCredits,
      'inProgressRequiredCredits': inProgressRequiredCredits,
      'registeringRequiredCredits': registeringRequiredCredits,
      'needToRegisterRequiredCredits': needToRegisterRequiredCredits,
      'notStartedRequiredCredits': notStartedRequiredCredits,
      'failedRequiredCredits': failedRequiredCredits,
      'totalRequiredCredits': totalRequiredCredits,
      'completedOptionalCredits': completedOptionalCredits,
      'inProgressOptionalCredits': inProgressOptionalCredits,
      'registeringOptionalCredits': registeringOptionalCredits,
      'needToRegisterOptionalCredits': needToRegisterOptionalCredits,
      'notStartedOptionalCredits': notStartedOptionalCredits,
      'failedOptionalCredits': failedOptionalCredits,
      'totalOptionalCredits': totalOptionalCredits,
      'totalRegisteringCredits': totalRegisteringCredits,
      'totalNeedToRegisterCredits': totalNeedToRegisterCredits,
      'totalNotStartedCredits': totalNotStartedCredits,
      'totalFailedCredits': totalFailedCredits,
      'completedCourses': completedCourses,
      'inProgressCourses': inProgressCourses,
      'registeringCourses': registeringCourses,
      'needToRegisterCourses': needToRegisterCourses,
      'notStartedCourses': notStartedCourses,
      'failedCourses': failedCourses,
    };
  }
} 