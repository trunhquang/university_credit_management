import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_update.dart';

class UpdateDialog extends StatelessWidget {
  final AppUpdate update;

  const UpdateDialog({
    super.key,
    required this.update,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !update.isForceUpdate,
      child: AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.system_update, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              'Cập nhật phiên bản ${update.version}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nội dung cập nhật:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(update.content),
            if (update.isForceUpdate) ...[
              const SizedBox(height: 16),
              const Text(
                'Đây là bản cập nhật bắt buộc. Vui lòng cập nhật để tiếp tục sử dụng ứng dụng.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!update.isForceUpdate)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Để sau'),
            ),
          ElevatedButton(
            onPressed: () async {
              final Uri url = Uri.parse(update.storeUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
              if (!update.isForceUpdate) {
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cập nhật ngay'),
          ),
        ],
      ),
    );
  }
} 