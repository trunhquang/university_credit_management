class GraduationChecklistItem {
  final String id;
  final String title;
  final String? note;
  final bool completed;

  const GraduationChecklistItem({
    required this.id,
    required this.title,
    this.note,
    this.completed = false,
  });

  GraduationChecklistItem copyWith({
    String? id,
    String? title,
    String? note,
    bool? completed,
  }) {
    return GraduationChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'completed': completed,
      };

  factory GraduationChecklistItem.fromJson(Map<String, dynamic> json) {
    return GraduationChecklistItem(
      id: json['id'] as String,
      title: json['title'] as String,
      note: json['note'] as String?,
      completed: (json['completed'] as bool?) ?? false,
    );
  }
}

class GraduationChecklist {
  final List<GraduationChecklistItem> items;
  const GraduationChecklist({required this.items});

  GraduationChecklist copyWith({List<GraduationChecklistItem>? items}) =>
      GraduationChecklist(items: items ?? this.items);

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory GraduationChecklist.fromJson(Map<String, dynamic> json) =>
      GraduationChecklist(
        items: (json['items'] as List<dynamic>)
            .map((e) => GraduationChecklistItem.fromJson(
                Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}

GraduationChecklist defaultGraduationChecklist() {
  final now = DateTime.now().millisecondsSinceEpoch;
  return GraduationChecklist(items: [
    GraduationChecklistItem(id: 'credits-$now', title: 'Hoàn thành 138 tín chỉ'),
    const GraduationChecklistItem(id: 'english', title: 'Đạt chuẩn ngoại ngữ'),
    const GraduationChecklistItem(id: 'papers', title: 'Hoàn thiện giấy tờ tốt nghiệp'),
    const GraduationChecklistItem(id: 'thesis', title: 'Bảo vệ/đồ án (nếu có)'),
    const GraduationChecklistItem(id: 'fees', title: 'Hoàn tất học phí'),
  ]);
}


