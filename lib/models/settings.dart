enum EnglishCertType {
  IELTS(minScore: 7),
  TOEFL(minScore: 550),
  TOEIC(minScore: 450),
  NONE(minScore: 0);

  final int minScore;
  const EnglishCertType({required this.minScore});

  String get displayName {
    switch (this) {
      case EnglishCertType.IELTS:
        return 'IELTS';
      case EnglishCertType.TOEFL:
        return 'TOEFL';
      case EnglishCertType.TOEIC:
        return 'TOEIC';
      case EnglishCertType.NONE:
        return 'Chưa có';
    }
  }

  int get defaultMinScore {
    switch (this) {
      case EnglishCertType.TOEIC:
        return 600;
      case EnglishCertType.IELTS:
        return 7;
      case EnglishCertType.TOEFL:
        return 550;
      case EnglishCertType.NONE:
        return 0;
    }
  }
}

class Settings {
  final EnglishCertType englishCertType;
  final int? englishScore;
  final int englishRequiredScore;
  final int? totalCredits;

  Settings({
    required this.englishCertType,
    this.englishScore,
    required this.englishRequiredScore,
    this.totalCredits,
  });

  Map<String, dynamic> toJson() {
    return {
      'englishCertType': englishCertType.name,
      'englishScore': englishScore,
      'englishRequiredScore': englishRequiredScore,
      'totalCredits': totalCredits,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      englishCertType: EnglishCertType.values.firstWhere(
        (e) => e.name == (json['englishCertType'] as String?),
        orElse: () => EnglishCertType.NONE,
      ),
      englishScore: json['englishScore'] as int?,
      englishRequiredScore: (json['englishRequiredScore'] as int?) ?? 0,
      totalCredits: json['totalCredits'] as int?,
    );
  }

  factory Settings.defaultSettings() {
    return Settings(
      englishCertType: EnglishCertType.TOEIC,
      englishScore: 0,
      englishRequiredScore: 450,
      totalCredits: 0,
    );
  }

  Settings copyWith({
    int? totalCredits,
    EnglishCertType? englishCertType,
    int? englishScore,
    int? englishRequiredScore,
  }) {
    return Settings(
      totalCredits: totalCredits ?? this.totalCredits,
      englishCertType: englishCertType ?? this.englishCertType,
      englishScore: englishScore ?? this.englishScore,
      englishRequiredScore: englishRequiredScore ?? this.englishRequiredScore,
    );
  }

  // Helper method to check if English requirement is met
  bool get isEnglishRequirementMet {
    return englishScore != null && englishScore! >= englishRequiredScore;
  }
} 