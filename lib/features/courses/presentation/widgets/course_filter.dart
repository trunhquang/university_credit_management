import 'package:flutter/material.dart';

import '../../../../core/models/course.dart';
import '../../../../core/models/section.dart';

class CourseFilter extends StatefulWidget {
  final CourseStatus? selectedStatus;
  final CourseType? selectedType;
  final String? selectedSection;
  final List<Section> sections;
  final Function(CourseStatus?, CourseType?, String?) onApply;

  const CourseFilter({
    super.key,
    this.selectedStatus,
    this.selectedType,
    this.selectedSection,
    required this.sections,
    required this.onApply,
  });

  @override
  State<CourseFilter> createState() => _CourseFilterState();
}

class _CourseFilterState extends State<CourseFilter> {
  CourseStatus? _selectedStatus;
  CourseType? _selectedType;
  String? _selectedSection;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.selectedStatus;
    _selectedType = widget.selectedType;
    _selectedSection = widget.selectedSection;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                'Bộ lọc',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedStatus = null;
                    _selectedType = null;
                    _selectedSection = null;
                  });
                },
                child: const Text('Xóa tất cả'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Status Filter
          const Text(
            'Trạng thái',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildStatusChip('Tất cả', null),
              _buildStatusChip('Đã hoàn thành', CourseStatus.completed),
              _buildStatusChip('Đang học', CourseStatus.inProgress),
              _buildStatusChip('Chưa học', CourseStatus.notStarted),
              _buildStatusChip('Thi lại', CourseStatus.failed),
            ],
          ),
          const SizedBox(height: 20),

          // Type Filter
          const Text(
            'Loại môn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildTypeChip('Tất cả', null),
              _buildTypeChip('Bắt buộc', CourseType.required),
              _buildTypeChip('Tự chọn', CourseType.optional),
            ],
          ),
          const SizedBox(height: 20),

          // Section Filter
          const Text(
            'Khối kiến thức',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildSectionChip('Tất cả', null),
              ...widget.sections.map((section) =>
                  _buildSectionChip(section.name, section.id)),
            ],
          ),
          const SizedBox(height: 30),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_selectedStatus, _selectedType, _selectedSection);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Áp dụng bộ lọc',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, CourseStatus? status) {
    final isSelected = _selectedStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? status : null;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildTypeChip(String label, CourseType? type) {
    final isSelected = _selectedType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = selected ? type : null;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildSectionChip(String label, String? sectionId) {
    final isSelected = _selectedSection == sectionId;
    return FilterChip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedSection = selected ? sectionId : null;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}
