import 'package:flutter/material.dart';
import '../models/course.dart';

/// Service để quản lý tất cả các dialog trong ứng dụng
class DialogService {
  /// Hiển thị dialog chọn môn học với filter phức tạp
  static Future<Course?> showAdvancedCourseSelectionDialog({
    required BuildContext context,
    required String title,
    required List<Course> courses,
    required Function(List<Course>) filterFunction,
    String? searchHint,
  }) {
    final TextEditingController searchCtrl = TextEditingController();
    String query = '';
    
    return showDialog<Course>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final filtered = filterFunction(courses);

          return SimpleDialog(
            title: Text(title),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchCtrl,
                  decoration: InputDecoration(
                    hintText: searchHint ?? 'Tìm kiếm theo tên hoặc mã môn',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => query = v),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 360,
                height: 480,
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, idx) {
                    final c = filtered[idx];
                    return ListTile(
                      leading: Icon(c.type == CourseType.required ? Icons.checklist_rtl : Icons.list_alt_outlined),
                      title: Text('${c.name} (${c.credits} TC)'),
                      subtitle: Text('${c.id} • ${c.type == CourseType.required ? 'BB' : 'TC'}'),
                      trailing: Text(c.type == CourseType.required ? 'BB' : 'TC'),
                      onTap: () => Navigator.pop(context, c),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  /// Hiển thị dialog chọn môn học đơn giản
  static Future<Course?> showCourseSelectionDialog({
    required BuildContext context,
    required String title,
    required List<Course> courses,
    String? searchHint,
    Function(String)? onSearchChanged,
    String? searchQuery,
  }) {
    final TextEditingController searchCtrl = TextEditingController(text: searchQuery ?? '');
    
    return showDialog<Course>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final filtered = courses.where((course) {
            final query = searchCtrl.text.trim().toLowerCase();
            if (query.isEmpty) return true;
            return course.name.toLowerCase().contains(query) || 
                   course.id.toLowerCase().contains(query);
          }).toList();

          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  if (searchHint != null) ...[
                    TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        hintText: searchHint,
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        setState(() {});
                        onSearchChanged?.call(value);
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final course = filtered[index];
                        return ListTile(
                          title: Text(course.name),
                          subtitle: Text('${course.id} • ${course.credits} TC'),
                          trailing: Text(
                            course.type == CourseType.required ? 'BB' : 'TC',
                            style: TextStyle(
                              color: course.type == CourseType.required 
                                  ? Colors.blue[700] 
                                  : Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () => Navigator.of(context).pop(course),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Hiển thị dialog danh sách môn đang học
  static void showInProgressCoursesDialog({
    required BuildContext context,
    required List<Course> courses,
    required String groupName,
  }) {
    if (courses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không có môn nào đang học trong nhóm $groupName')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.school, color: Colors.orange[700]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Môn đang học - $groupName',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    child: Icon(
                      Icons.book,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                  ),
                  title: Text(
                    course.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mã môn: ${course.id}'),
                      Text('${course.credits} tín chỉ • ${course.type == CourseType.required ? 'Bắt buộc' : 'Tự chọn'}'),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${course.credits} TC',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  /// Hiển thị dialog chỉnh sửa thông tin
  static Future<Map<String, String>?> showEditInfoDialog({
    required BuildContext context,
    required String title,
    String? initialNote,
    String? initialSchedule,
    String? noteHint,
    String? scheduleHint,
  }) {
    final noteCtrl = TextEditingController(text: initialNote ?? '');
    final scheduleCtrl = TextEditingController(text: initialSchedule ?? '');

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteCtrl,
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  hintText: noteHint ?? 'Nhập ghi chú...',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: scheduleCtrl,
                decoration: InputDecoration(
                  labelText: 'Lịch học',
                  hintText: scheduleHint ?? 'Nhập lịch học...',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'note': noteCtrl.text,
              'schedule': scheduleCtrl.text,
            }),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  /// Hiển thị dialog xác nhận
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: confirmColor != null 
                ? ElevatedButton.styleFrom(backgroundColor: confirmColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    ).then((result) => result ?? false);
  }

  /// Hiển thị dialog thông báo
  static void showInfoDialog({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = 'Đóng',
    IconData? icon,
    Color? iconColor,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Hiển thị dialog loading
  static void showLoadingDialog({
    required BuildContext context,
    String message = 'Đang xử lý...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  /// Đóng dialog loading
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Hiển thị dialog lỗi
  static void showErrorDialog({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = 'Đóng',
  }) {
    showInfoDialog(
      context: context,
      title: title,
      content: content,
      buttonText: buttonText,
      icon: Icons.error_outline,
      iconColor: Colors.red,
    );
  }

  /// Hiển thị dialog thành công
  static void showSuccessDialog({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = 'Đóng',
  }) {
    showInfoDialog(
      context: context,
      title: title,
      content: content,
      buttonText: buttonText,
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
    );
  }

  /// Hiển thị dialog tạo học kỳ mới
  static Future<Map<String, dynamic>?> showCreateSemesterDialog({
    required BuildContext context,
    required String title,
    int? initialYear,
  }) {
    String selected = 'HK1';
    int year = initialYear ?? DateTime.now().year;
    int creditLimit = 20;
    
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selected,
                  decoration: const InputDecoration(labelText: 'Học kỳ'),
                  items: const [
                    DropdownMenuItem(value: 'HK1', child: Text('HK1')),
                    DropdownMenuItem(value: 'HK2', child: Text('HK2')),
                    DropdownMenuItem(value: 'Hè', child: Text('Hè')),
                  ],
                  onChanged: (v) => setState(() => selected = v ?? 'HK1'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: year.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Năm'),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) setState(() => year = n);
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: creditLimit.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Giới hạn tín chỉ',
                    hintText: 'Ví dụ: 20',
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null && n > 0) setState(() => creditLimit = n);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop({
                  'term': selected,
                  'year': year,
                  'creditLimit': creditLimit,
                }),
                child: const Text('Tạo'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Hiển thị dialog cấu hình giới hạn tín chỉ
  static Future<int?> showCreditLimitDialog({
    required BuildContext context,
    required String title,
    required int currentLimit,
  }) {
    int creditLimit = currentLimit;
    
    return showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: creditLimit.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Giới hạn tín chỉ',
                    hintText: 'Nhập số tín chỉ tối đa cho học kỳ này',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null && n > 0) setState(() => creditLimit = n);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Gợi ý: HK1/HK2: 18-22 TC, Hè: 8-12 TC',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(creditLimit),
                child: const Text('Lưu'),
              ),
            ],
          );
        },
      ),
    );
  }
}
