import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io' show Platform;
import '../models/app_update.dart';
import '../widgets/update_dialog.dart';

class AppUpdateService {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();
  static const String _versionConfigPath = 'app_config/version';

  static Future<void> checkForUpdates(BuildContext context) async {
    try {
      final currentVersion = await PackageInfo.fromPlatform();
      
      // Get version config from Firebase
      final versionSnapshot = await _database.child(_versionConfigPath).get();
      
      if (!versionSnapshot.exists) {
        debugPrint('No version config found in Firebase');
        return;
      }

      final versionData = versionSnapshot.value as Map<dynamic, dynamic>;
      final latestVersion = versionData['version'] as String;
      final isForceUpdate = versionData['isForceUpdate'] as bool;
      final updateContent = versionData['content'] as String;
      
      // Get platform-specific store URL
      final storeUrls = versionData['storeUrls'] as Map<dynamic, dynamic>;
      final storeUrl = Platform.isAndroid 
          ? storeUrls['android'] as String 
          : storeUrls['ios'] as String;

      // Compare versions
      if (_compareVersions(currentVersion.version, latestVersion) < 0) {
        final update = AppUpdate(
          version: latestVersion,
          content: updateContent,
          isForceUpdate: isForceUpdate,
          storeUrl: storeUrl,
        );

        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: !update.isForceUpdate,
            builder: (context) => UpdateDialog(update: update),
          );
        }
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
    }
  }

  // Compare version strings (e.g., "1.0.0" vs "1.0.1")
  static int _compareVersions(String current, String latest) {
    final currentParts = current.split('.').map(int.parse).toList();
    final latestParts = latest.split('.').map(int.parse).toList();

    for (var i = 0; i < 3; i++) {
      if (i >= currentParts.length || i >= latestParts.length) {
        return currentParts.length.compareTo(latestParts.length);
      }
      if (currentParts[i] != latestParts[i]) {
        return currentParts[i].compareTo(latestParts[i]);
      }
    }
    return 0;
  }
} 