import 'package:shared_preferences/shared_preferences.dart';

class GPAHistoryEntry {
  final DateTime timestamp;
  final double gpa;
  final int completedCredits;

  GPAHistoryEntry({required this.timestamp, required this.gpa, required this.completedCredits});

  Map<String, dynamic> toJson() => {
        'ts': timestamp.millisecondsSinceEpoch,
        'gpa': gpa,
        'cc': completedCredits,
      };

  factory GPAHistoryEntry.fromJson(Map<String, dynamic> json) => GPAHistoryEntry(
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['ts'] as int),
        gpa: (json['gpa'] as num).toDouble(),
        completedCredits: (json['cc'] as num).toInt(),
      );
}

class GPAHistoryService {
  static const String _key = 'gpa_history_entries';

  Future<List<GPAHistoryEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => GPAHistoryEntry.fromJson(
            Map<String, dynamic>.from(Uri.splitQueryString(s))))
        .toList();
  }

  Future<void> append(GPAHistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.add(_encode(entry));
    await prefs.setStringList(_key, list);
  }

  String _encode(GPAHistoryEntry e) {
    // Lightweight encode as query string to avoid adding json deps on web
    return 'ts=${e.timestamp.millisecondsSinceEpoch}&gpa=${e.gpa}&cc=${e.completedCredits}';
  }
}


