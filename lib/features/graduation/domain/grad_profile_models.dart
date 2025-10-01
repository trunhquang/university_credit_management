class LanguageProficiency {
  final String level; // e.g., 'IELTS 6.5', 'B1', 'TOEIC 600'
  final bool metRequirement;

  const LanguageProficiency({this.level = '', this.metRequirement = false});

  LanguageProficiency copyWith({String? level, bool? metRequirement}) =>
      LanguageProficiency(
        level: level ?? this.level,
        metRequirement: metRequirement ?? this.metRequirement,
      );

  Map<String, dynamic> toJson() => {
        'level': level,
        'metRequirement': metRequirement,
      };

  factory LanguageProficiency.fromJson(Map<String, dynamic> json) =>
      LanguageProficiency(
        level: (json['level'] as String?) ?? '',
        metRequirement: (json['metRequirement'] as bool?) ?? false,
      );
}

class CertificateEntry {
  final String id;
  final String title;
  final String? note;

  const CertificateEntry({required this.id, required this.title, this.note});

  CertificateEntry copyWith({String? id, String? title, String? note}) =>
      CertificateEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        note: note ?? this.note,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
      };

  factory CertificateEntry.fromJson(Map<String, dynamic> json) =>
      CertificateEntry(
        id: json['id'] as String,
        title: json['title'] as String,
        note: json['note'] as String?,
      );
}

class TimelineEntry {
  final String id;
  final String dateIso; // yyyy-MM-dd
  final String note;

  const TimelineEntry({required this.id, required this.dateIso, required this.note});

  Map<String, dynamic> toJson() => {
        'id': id,
        'dateIso': dateIso,
        'note': note,
      };

  factory TimelineEntry.fromJson(Map<String, dynamic> json) => TimelineEntry(
        id: json['id'] as String,
        dateIso: json['dateIso'] as String,
        note: json['note'] as String,
      );
}

class GraduationProfile {
  final LanguageProficiency language;
  final List<CertificateEntry> certificates;
  final List<TimelineEntry> timeline;

  const GraduationProfile({
    required this.language,
    required this.certificates,
    required this.timeline,
  });

  GraduationProfile copyWith({
    LanguageProficiency? language,
    List<CertificateEntry>? certificates,
    List<TimelineEntry>? timeline,
  }) =>
      GraduationProfile(
        language: language ?? this.language,
        certificates: certificates ?? this.certificates,
        timeline: timeline ?? this.timeline,
      );

  Map<String, dynamic> toJson() => {
        'language': language.toJson(),
        'certificates': certificates.map((e) => e.toJson()).toList(),
        'timeline': timeline.map((e) => e.toJson()).toList(),
      };

  factory GraduationProfile.fromJson(Map<String, dynamic> json) =>
      GraduationProfile(
        language: LanguageProficiency.fromJson(
            Map<String, dynamic>.from(json['language'] as Map)),
        certificates: (json['certificates'] as List<dynamic>? ?? [])
            .map((e) => CertificateEntry.fromJson(
                Map<String, dynamic>.from(e as Map)))
            .toList(),
        timeline: (json['timeline'] as List<dynamic>? ?? [])
            .map((e) => TimelineEntry.fromJson(
                Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}

GraduationProfile defaultGraduationProfile() => GraduationProfile(
      language: const LanguageProficiency(),
      certificates: const [],
      timeline: const [],
    );


