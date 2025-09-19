import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/state/curriculum_provider.dart';
import '../../../../core/navigation/app_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.goBack(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Data Management Section
          _buildSectionHeader('Quản lý dữ liệu'),
          _buildSettingsTile(
            icon: Icons.refresh,
            title: 'Làm mới dữ liệu',
            subtitle: 'Tải lại dữ liệu từ template',
            onTap: () => _showRefreshDialog(context),
          ),
          _buildSettingsTile(
            icon: Icons.restore,
            title: 'Reset về mặc định',
            subtitle: 'Xóa tất cả dữ liệu và reset về trạng thái ban đầu',
            onTap: () => _showResetDialog(context),
          ),
          
          const SizedBox(height: 24),
          
          // App Info Section
          _buildSectionHeader('Thông tin ứng dụng'),
          _buildSettingsTile(
            icon: Icons.info,
            title: 'Phiên bản',
            subtitle: '1.0.0 (Giai đoạn 1)',
            onTap: null,
          ),
          _buildSettingsTile(
            icon: Icons.description,
            title: 'Về ứng dụng',
            subtitle: 'Grad Tracker - Theo dõi tiến độ học tập',
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
        onTap: onTap,
      ),
    );
  }

  void _showRefreshDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Làm mới dữ liệu'),
        content: const Text('Bạn có chắc muốn tải lại dữ liệu từ template?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CurriculumProvider>().initializeCurriculum();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã làm mới dữ liệu')),
              );
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset dữ liệu'),
        content: const Text(
          'Bạn có chắc muốn xóa tất cả dữ liệu và reset về trạng thái ban đầu?\n\nHành động này không thể hoàn tác!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CurriculumProvider>().resetToTemplate();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã reset dữ liệu')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Grad Tracker',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.school,
        size: 48,
        color: Colors.blue,
      ),
      children: const [
        Text(
          'Ứng dụng theo dõi tiến độ học tập cho sinh viên đại học.\n\n'
          'Tính năng hiện tại (Giai đoạn 1):\n'
          '• Dashboard tổng quan\n'
          '• Quản lý môn học\n'
          '• Theo dõi tiến độ cơ bản\n'
          '• Tính toán GPA cơ bản\n\n'
          'Sẽ có thêm nhiều tính năng trong các giai đoạn tiếp theo!',
        ),
      ],
    );
  }
}
