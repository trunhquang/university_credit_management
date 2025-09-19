import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/state/curriculum_provider.dart';
import '../../../../core/models/course.dart';
import '../../../../core/navigation/app_router.dart';
import '../widgets/course_card.dart';
import '../widgets/course_filter.dart';

class CoursesListPage extends StatefulWidget {
  const CoursesListPage({super.key});

  @override
  State<CoursesListPage> createState() => _CoursesListPageState();
}

class _CoursesListPageState extends State<CoursesListPage> {
  final TextEditingController _searchController = TextEditingController();
  CourseStatus? _selectedStatus;
  CourseType? _selectedType;
  String? _selectedSection;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Môn học',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.goBack(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Consumer<CurriculumProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.initializeCurriculum(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final filteredCourses = _getFilteredCourses(provider);
          final sections = provider.sections;

          return Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[50],
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm môn học...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),

              // Filter Chips
              if (_hasActiveFilters())
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (_selectedStatus != null)
                          _buildFilterChip(
                            _getStatusText(_selectedStatus!),
                            () => setState(() => _selectedStatus = null),
                          ),
                        if (_selectedType != null)
                          _buildFilterChip(
                            _selectedType == CourseType.required ? 'Bắt buộc' : 'Tự chọn',
                            () => setState(() => _selectedType = null),
                          ),
                        if (_selectedSection != null)
                          _buildFilterChip(
                            _getSectionName(_selectedSection!, sections),
                            () => setState(() => _selectedSection = null),
                          ),
                      ],
                    ),
                  ),
                ),

              // Courses List
              Expanded(
                child: filteredCourses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Không tìm thấy môn học nào',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = filteredCourses[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CourseCard(
                              course: course,
                              onTap: () => AppNavigation.goToCourseDetail(
                                context,
                                course.id,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Course> _getFilteredCourses(CurriculumProvider provider) {
    List<Course> courses = [];

    // Lấy tất cả courses
    for (var section in provider.sections) {
      for (var group in section.courseGroups) {
        courses.addAll(group.courses);
      }
    }

    // Lọc theo tìm kiếm
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      courses = courses.where((course) =>
          course.name.toLowerCase().contains(query) ||
          course.id.toLowerCase().contains(query)).toList();
    }

    // Lọc theo trạng thái
    if (_selectedStatus != null) {
      courses = courses.where((course) => course.status == _selectedStatus).toList();
    }

    // Lọc theo loại
    if (_selectedType != null) {
      courses = courses.where((course) => course.type == _selectedType).toList();
    }

    // Lọc theo khối kiến thức
    if (_selectedSection != null) {
      courses = courses.where((course) {
        for (var section in provider.sections) {
          if (section.id == _selectedSection) {
            for (var group in section.courseGroups) {
              if (group.courses.contains(course)) {
                return true;
              }
            }
          }
        }
        return false;
      }).toList();
    }

    return courses;
  }

  bool _hasActiveFilters() {
    return _selectedStatus != null || _selectedType != null || _selectedSection != null;
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onRemove,
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        deleteIconColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getStatusText(CourseStatus status) {
    switch (status) {
      case CourseStatus.completed:
        return 'Đã hoàn thành';
      case CourseStatus.inProgress:
        return 'Đang học';
      case CourseStatus.notStarted:
        return 'Chưa học';
      case CourseStatus.failed:
        return 'Thi lại';
      case CourseStatus.registering:
        return 'Đang đăng ký';
      case CourseStatus.needToRegister:
        return 'Cần đăng ký';
    }
  }

  String _getSectionName(String sectionId, sections) {
    for (var section in sections) {
      if (section.id == sectionId) {
        return section.name;
      }
    }
    return sectionId;
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CourseFilter(
        selectedStatus: _selectedStatus,
        selectedType: _selectedType,
        selectedSection: _selectedSection,
        sections: context.read<CurriculumProvider>().sections,
        onApply: (status, type, section) {
          setState(() {
            _selectedStatus = status;
            _selectedType = type;
            _selectedSection = section;
          });
        },
      ),
    );
  }
}
