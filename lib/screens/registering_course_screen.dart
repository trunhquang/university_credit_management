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
import '../screens/all_courses_screen.dart';

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

    // Lưu lại các group ID hiện tại đang mở
    final currentExpandedGroups = Set<String>.from(_expandedGroups);

    // Cập nhật danh sách môn học
    setState(() {
      _allCourses = courses;
      
      // Lấy danh sách các group ID mới
      final newGroupIds = _sections!
          .expand((section) => section.courseGroups)
          .map((group) => group.id)
          .toSet();

      // Giữ lại trạng thái mở của các group cũ nếu group đó vẫn còn tồn tại
      _expandedGroups = currentExpandedGroups
          .where((groupId) => newGroupIds.contains(groupId))
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

  Future<void> _toggleCourseRegistration(Course course) async {
    try {
      // Tạo bản sao mới của môn học với trạng thái mới
      final updatedCourse = course.copyWith(
        status: course.status == CourseStatus.registering
            ? CourseStatus.notStarted
            : CourseStatus.registering,
      );

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
                    content: Text(updatedCourse.status == CourseStatus.registering
                        ? 'Đã đăng ký môn học ${course.name}'
                        : 'Đã hủy đăng ký môn học ${course.name}'),
                    backgroundColor: updatedCourse.status == CourseStatus.registering
                        ? AppColors.success
                        : AppColors.error,
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
            backgroundColor: AppColors.error,
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

  void _navigateToRegisteringCourses() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AllCoursesScreen(
          courseStatus: CourseStatus.registering,
        ),
      ),
    );
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
                          GestureDetector(
                            onTap: _navigateToRegisteringCourses,
                            child: RegisteringCoursesSummary(
                              courses: _allCourses,
                              languageManager: _languageManager,
                            ),
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
                            onToggleOpenStatus: _toggleCourseOpenStatus,
                            onToggleRegistration: _toggleCourseRegistration,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
