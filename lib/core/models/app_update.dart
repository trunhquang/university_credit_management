class AppUpdate {
  final String version;
  final String content;
  final bool isForceUpdate;
  final String storeUrl;

  AppUpdate({
    required this.version,
    required this.content,
    required this.isForceUpdate,
    required this.storeUrl,
  });

  factory AppUpdate.fromJson(Map<String, dynamic> json) {
    return AppUpdate(
      version: json['version'] as String,
      content: json['content'] as String,
      isForceUpdate: json['isForceUpdate'] as bool,
      storeUrl: json['storeUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'content': content,
      'isForceUpdate': isForceUpdate,
      'storeUrl': storeUrl,
    };
  }
} 