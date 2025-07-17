import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../models/section.dart';
import '../services/program_service.dart';
import '../theme/app_colors.dart';
import '../l10n/language_manager.dart';
import '../widgets/course_card.dart';

class AllCoursesScreen extends StatefulWidget {
  const AllCoursesScreen(
      {super.key, this.courseStatus, this.selectedSectionId});

  final CourseStatus? courseStatus;
  final String? selectedSectionId;

  @override
  State<AllCoursesScreen> createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  final _programService = ProgramService();
  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  List<Section> _sections = [];
  bool _isLoading = false;
  String _errorMessage = '';
  late final LanguageManager _languageManager;

  // Search and filter controllers
  final TextEditingController _searchController = TextEditingController();
  String _selectedSectionId = 'all';
  String _searchQuery = '';
  CourseStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _languageManager = Provider.of<LanguageManager>(context, listen: false);
    _languageManager.addListener(_onLanguageChanged);
    _selectedStatus = widget.courseStatus;
    _selectedSectionId = widget.selectedSectionId ?? 'all';
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _languageManager.removeListener(_onLanguageChanged);
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
      _sections = await _programService.getSections();
      _courses = _sections.expand((section) => section.allCourses).toList();
      _applyFilters();
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

  void _applyFilters() {
    setState(() {
      _filteredCourses = _courses.where((course) {
        // Filter by section
        if (_selectedSectionId != 'all') {
          final section =
              _sections.firstWhere((s) => s.id == _selectedSectionId);
          if (!section.allCourses.contains(course)) {
            return false;
          }
        }

        // Filter by status
        if (_selectedStatus != null && course.status != _selectedStatus) {
          return false;
        }

        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          return course.id.toLowerCase().contains(query) ||
              course.name.toLowerCase().contains(query);
        }

        return true;
      }).toList();

      // Sort by course ID
      _filteredCourses.sort((a, b) => a.id.compareTo(b.id));
    });
  }

  Future<void> _saveCourse(Course course,
      {CourseStatus? status, double? score}) async {
    try {
      // Find the section and course group containing this course
      for (final section in _sections) {
        for (final group in section.courseGroups) {
          final courseIndex =
              group.courses.indexWhere((c) => c.id == course.id);
          if (courseIndex != -1) {
            var updatedCourse = course;
            if (status != null) {
              updatedCourse = updatedCourse.copyWith(status: status);
            }
            if (score != null) {
              updatedCourse = updatedCourse.copyWith(score: score);
            }
            await _programService.updateCourse(
                section.id, group.id, updatedCourse);
            await _loadData(); // Reload data to ensure consistency
            return;
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_languageManager.currentStrings.allCourses),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _languageManager.currentStrings.searchCourses,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _applyFilters();
                    });
                  },
                ),
                // Section filter dropdown
                if (widget.selectedSectionId == null)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedSectionId,
                        decoration: InputDecoration(
                          labelText:
                              _languageManager.currentStrings.filterBySection,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'all',
                            child:
                                Text(_languageManager.currentStrings.allSections),
                          ),
                          ..._sections.map((section) => DropdownMenuItem(
                                value: section.id,
                                child: Text(section.name),
                              )),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedSectionId = value;
                              _applyFilters();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                // Status filter dropdown
                DropdownButtonFormField<CourseStatus?>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: _languageManager.currentStrings.filterByStatus,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(_languageManager.currentStrings.allStatuses),
                    ),
                    ...CourseStatus.values.map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(_getStatusText(status)),
                        )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                      _applyFilters();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildCourseList(),
          ),
        ],
      ),
    );
  }

  String _getStatusText(CourseStatus status) {
    switch (status) {
      case CourseStatus.notStarted:
        return _languageManager.currentStrings.notStarted;
      case CourseStatus.inProgress:
        return _languageManager.currentStrings.inProgress;
      case CourseStatus.completed:
        return _languageManager.currentStrings.completed;
      case CourseStatus.failed:
        return _languageManager.currentStrings.failed;
      case CourseStatus.registering:
        return _languageManager.currentStrings.registering;
      case CourseStatus.needToRegister:
        return _languageManager.currentStrings.needToRegister;
    }
  }

  Widget _buildCourseList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
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
      );
    }

    if (_filteredCourses.isEmpty) {
      return Center(
        child: Text(_languageManager.currentStrings.noCoursesFound),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredCourses.length,
      itemBuilder: (context, index) {
        final course = _filteredCourses[index];
        return CourseCard(
          course: course,
          languageManager: _languageManager,
          onChangeCourseStatus: (status) {
            _saveCourse(course, status: status);
          },
          onScoreChanged: (score) {
            _saveCourse(course, score: score);
          }, isAcceptedChangeStatus: true,
        );
      },
    );
  }
}
