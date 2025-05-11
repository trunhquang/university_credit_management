import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/section.dart';
import '../models/course.dart';
import '../models/course_group.dart';
import '../services/program_service.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';
import '../widgets/register_course_group_card.dart';
import '../widgets/registering_courses_summary.dart';
import '../widgets/selected_courses_summary.dart';

enum CourseFilter {
  all,
  open,
  closed;

  bool? toBool() {
    switch (this) {
      case CourseFilter.all:
        return null;
      case CourseFilter.open:
        return true;
      case CourseFilter.closed:
        return false;
    }
  }

  static CourseFilter fromBool(bool? value) {
    switch (value) {
      case null:
        return CourseFilter.all;
      case true:
        return CourseFilter.open;
      case false:
        return CourseFilter.closed;
    }
  }
}

class RegisteringCourseScreen extends StatefulWidget {
  const RegisteringCourseScreen({super.key});

  @override
  State<RegisteringCourseScreen> createState() =>
      _RegisteringCourseScreenState();
}

class _RegisteringCourseScreenState extends State<RegisteringCourseScreen> {
  final _programService = ProgramService();
  List<Section>? _sections;
  bool _isLoading = false;
  String _errorMessage = '';
  late final LanguageManager _languageManager;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<Course> _allCourses = [];
  List<Course> _selectedCourses = [];
  CourseFilter _filter = CourseFilter.all;
  Set<String> _expandedGroups = {};

  @override
  void initState() {
    super.initState();
    _languageManager = Provider.of<LanguageManager>(context, listen: false);
    _languageManager.addListener(_onLanguageChanged);
    _loadData();
  }

  @override
  void dispose() {
    _languageManager.removeListener(_onLanguageChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  Future<void> _loadData() async {
    if (!mounted || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final sections = await _programService.getSections();
      _sections = sections;
      _updateCourses();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateCourses() {
    if (_sections == null) return;

    // Lấy tất cả các môn học từ các section
    var courses = _sections!
        .expand((section) => section.courseGroups)
        .expand((group) => group.courses)
        .toList();

    // Lọc theo trạng thái isOpen
    if (_filter != CourseFilter.all) {
      courses = courses.where((course) => course.isOpen == _filter.toBool()).toList();
    }

    // Lọc theo từ khóa tìm kiếm
    if (_searchQuery.isNotEmpty) {
      courses = courses.where((course) {
        final query = _searchQuery.toLowerCase();
        return course.id.toLowerCase().contains(query) ||
            course.name.toLowerCase().contains(query);
      }).toList();
    }

    // Cập nhật danh sách môn học và mở rộng tất cả các group
    setState(() {
      _allCourses = courses;
      // Lấy tất cả các group ID và thêm vào _expandedGroups
      _expandedGroups = _sections!
          .expand((section) => section.courseGroups)
          .map((group) => group.id)
          .toSet();
    });
  }

  Map<CourseGroup, List<Course>> _groupCoursesByGroup() {
    final Map<CourseGroup, List<Course>> groupedCourses = {};

    for (final course in _allCourses) {
      final group = _findCourseGroup(course);
      if (group != null) {
        if (!groupedCourses.containsKey(group)) {
          groupedCourses[group] = [];
        }
        groupedCourses[group]!.add(course);
      }
    }

    return groupedCourses;
  }

  CourseGroup? _findCourseGroup(Course course) {
    for (final section in _sections!) {
      for (final group in section.courseGroups) {
        if (group.courses.contains(course)) {
          return group;
        }
      }
    }
    return null;
  }

  void _toggleCourseSelection(Course course) {
    setState(() {
      if (_selectedCourses.contains(course)) {
        _selectedCourses.remove(course);
      } else {
        _selectedCourses.add(course);
      }
    });
  }

  Future<void> _registerSelectedCourses() async {
    if (_selectedCourses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_languageManager.currentStrings.pleaseSelectCourses)),
      );
      return;
    }

    try {
      // Cập nhật trạng thái các môn học thành registering
      for (final course in _selectedCourses) {
        final updatedCourse = course.copyWith(status: CourseStatus.registering);

        // Tìm section và group chứa môn học
        if (_sections != null) {
          for (final section in _sections!) {
            for (final group in section.courseGroups) {
              final index = group.courses.indexWhere((c) => c.id == course.id);
              if (index != -1) {
                // Cập nhật trong danh sách sections
                group.courses[index] = updatedCourse;

                // Cập nhật vào database
                await _programService.updateCourse(
                    section.id, group.id, updatedCourse);
                break;
              }
            }
          }
        }
      }

      // Cập nhật UI
      setState(() {
        _updateCourses();
        _selectedCourses.clear();
      });

      // Hiển thị thông báo thành công
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_languageManager.currentStrings.coursesRegistered),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _toggleCourseOpenStatus(Course course) async {
    try {
      // Tạo bản sao mới của môn học với trạng thái isOpen ngược lại
      final updatedCourse = course.copyWith(isOpen: !course.isOpen);

      // Tìm section và group chứa môn học
      if (_sections != null) {
        for (final section in _sections!) {
          for (final group in section.courseGroups) {
            final index = group.courses.indexWhere((c) => c.id == course.id);
            if (index != -1) {
              // Cập nhật trong danh sách sections
              group.courses[index] = updatedCourse;

              // Cập nhật vào database
              await _programService.updateCourse(
                  section.id, group.id, updatedCourse);

              // Cập nhật UI
              setState(() {
                _updateCourses();
              });

              // Hiển thị thông báo
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(updatedCourse.isOpen
                        ? 'Đã mở môn học ${course.name}'
                        : 'Đã đóng môn học ${course.name}'),
                    backgroundColor:
                        updatedCourse.isOpen ? Colors.green : Colors.red,
                  ),
                );
              }
              return;
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleGroupExpansion(String groupId) {
    setState(() {
      if (_expandedGroups.contains(groupId)) {
        _expandedGroups.remove(groupId);
      } else {
        _expandedGroups.add(groupId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedCourses = _groupCoursesByGroup();

    return Scaffold(
      appBar: AppBar(
        title: Text(_languageManager.currentStrings.registering),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<CourseFilter>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Lọc môn học',
            onSelected: (CourseFilter value) {
              setState(() {
                _filter = value;
                _updateCourses();
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<CourseFilter>(
                value: CourseFilter.all,
                child: Row(
                  children: [
                    Icon(
                      Icons.all_inclusive,
                      color: _filter == CourseFilter.all ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tất cả',
                      style: TextStyle(
                        color: _filter == CourseFilter.all ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<CourseFilter>(
                value: CourseFilter.open,
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_open,
                      color: _filter == CourseFilter.open ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Đang mở',
                      style: TextStyle(
                        color: _filter == CourseFilter.open ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<CourseFilter>(
                value: CourseFilter.closed,
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: _filter == CourseFilter.closed ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Đã đóng',
                      style: TextStyle(
                        color: _filter == CourseFilter.closed ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: Text(_languageManager.currentStrings.retry),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText:
                                  _languageManager.currentStrings.searchCourse,
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                          _searchQuery = '';
                                          _updateCourses();
                                        });
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                                _updateCourses();
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          RegisteringCoursesSummary(
                            courses: _allCourses,
                            languageManager: _languageManager,
                          ),
                          const SizedBox(height: 8),
                          SelectedCoursesSummary(
                            selectedCourses: _selectedCourses,
                            languageManager: _languageManager,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: groupedCourses.length,
                        itemBuilder: (context, index) {
                          final group = groupedCourses.keys.elementAt(index);
                          final courses = groupedCourses[group]!;
                          final isExpanded = _expandedGroups.contains(group.id);

                          return RegisterCourseGroupCard(
                            group: group,
                            toggleGroupExpansion: _toggleGroupExpansion,
                            isExpanded: isExpanded,
                            courses: courses,
                            languageManager: _languageManager,
                            onToggleSelection: _toggleCourseSelection,
                            onToggleOpenStatus: _toggleCourseOpenStatus,
                            selectedCourses: _selectedCourses,
                          );
                        },
                      ),
                    ),
                    if (_selectedCourses.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: _registerSelectedCourses,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: Text(
                            '${_languageManager.currentStrings.register} (${_selectedCourses.length})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}
