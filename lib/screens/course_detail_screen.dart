import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../models/section.dart';
import '../widgets/course_form_dialog.dart';
import '../services/program_service.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';

class CourseDetailScreen extends StatefulWidget {
  final Section section;

  const CourseDetailScreen({
    super.key,
    required this.section,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Section _section;
  late final LanguageManager _languageManager;
  final _programService = ProgramService();
  bool _isGroupMode = false;
  final Set<Course> _selectedCourses = {};
  final Map<int, Color> _groupColors = {};

  @override
  void initState() {
    super.initState();
    _section = widget.section;
    _languageManager = Provider.of<LanguageManager>(context, listen: false);
    _languageManager.addListener(_onLanguageChanged);
    _initializeGroupColors();
  }

  void _initializeGroupColors() {
    final groups = _section.courses
        .where((course) => course.idGroup != null)
        .map((course) => course.idGroup!)
        .toSet();

    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
    ];

    for (var i = 0; i < groups.length; i++) {
      _groupColors[groups.elementAt(i)] = colors[i % colors.length];
    }
  }

  Color _getGroupColor(int? groupId) {
    if (groupId == null) return Colors.grey;
    return _groupColors[groupId] ?? Colors.grey;
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _languageManager.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _toggleGroupMode() {
    setState(() {
      _isGroupMode = !_isGroupMode;
      if (!_isGroupMode) {
        _selectedCourses.clear();
      } else {
        // Auto-select courses in the same group
        final selectedGroupId =
            _selectedCourses.isNotEmpty ? _selectedCourses.first.idGroup : null;
        if (selectedGroupId != null) {
          _selectedCourses.clear();
          _selectedCourses.addAll(_section.courses
              .where((course) => course.idGroup == selectedGroupId));
        }
      }
    });
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

  updateLatestData() async {
    // Refresh the section to get the latest data
    final updatedSections = await _programService.getSections();
    _section = updatedSections.firstWhere((s) => s.id == _section.id);
  }

  Future<void> _updateAllGroups() async {
    await updateLatestData();

    try {
      // Get all courses with groups
      final groupedCourses =
          _section.courses.where((course) => course.idGroup != null).toList();

      if (groupedCourses.isEmpty) return;

      // First, check and reset groups with only one course
      final groups = groupedCourses.map((course) => course.idGroup!).toSet();

      for (final groupId in groups) {
        final coursesInGroup =
            groupedCourses.where((course) => course.idGroup == groupId).length;

        if (coursesInGroup == 1) {
          final singleCourse =
              groupedCourses.firstWhere((course) => course.idGroup == groupId);

          final updatedCourse = Course(
            id: singleCourse.id,
            name: singleCourse.name,
            credits: singleCourse.credits,
            idGroup: null,
            grade: singleCourse.grade,
            type: singleCourse.type,
            status: singleCourse.status,
            prerequisiteCourses: singleCourse.prerequisiteCourses,
          );

          await _programService.updateCourse(_section.id, updatedCourse);
        }
      }

      // Get updated list of courses with groups after resetting single-course groups
      await updateLatestData();
      final remainingGroupedCourses =
          _section.courses.where((course) => course.idGroup != null).toList();

      if (remainingGroupedCourses.isEmpty) {
        setState(() {
          _initializeGroupColors();
        });
        return;
      }

      // Create a map of old group IDs to new group IDs
      final oldToNewGroupIds = <int, int>{};
      var newGroupId = 1;

      // Assign new group IDs sequentially
      for (final course in remainingGroupedCourses) {
        if (!oldToNewGroupIds.containsKey(course.idGroup)) {
          oldToNewGroupIds[course.idGroup!] = newGroupId++;
        }
      }

      // Update all courses with new group IDs
      for (final course in remainingGroupedCourses) {
        final updatedCourse = Course(
          id: course.id,
          name: course.name,
          credits: course.credits,
          idGroup: oldToNewGroupIds[course.idGroup],
          grade: course.grade,
          type: course.type,
          status: course.status,
          prerequisiteCourses: course.prerequisiteCourses,
        );
        await _programService.updateCourse(_section.id, updatedCourse);
      }
      // Refresh the section
      await updateLatestData();
      setState(() {
        _initializeGroupColors();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _createGroup(List<Course> courses) async {
    if (courses.length < 2) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(_languageManager.currentStrings.groupMinTwoCourses)),
        );
      }
      return;
    }

    try {
      // Find the next available group ID
      final maxGroupId = _section.courses
          .where((course) => course.idGroup != null)
          .map((course) => course.idGroup!)
          .fold(0, (max, id) => id > max ? id : max);

      final newGroupId = maxGroupId + 1;

      // Update all selected courses with the new group ID
      for (final course in courses) {
        final updatedCourse = Course(
          id: course.id,
          name: course.name,
          credits: course.credits,
          idGroup: newGroupId,
          grade: course.grade,
          type: course.type,
          status: course.status,
          prerequisiteCourses: course.prerequisiteCourses,
        );
        await _programService.updateCourse(_section.id, updatedCourse);
      }

      // Update all group IDs
      await _updateAllGroups();

      setState(() {
        _isGroupMode = false;
        _selectedCourses.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_languageManager.currentStrings.groupCreated)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _removeFromGroup(Course course) async {
    try {
      final updatedCourse = Course(
        id: course.id,
        name: course.name,
        credits: course.credits,
        idGroup: null,
        grade: course.grade,
        type: course.type,
        status: course.status,
        prerequisiteCourses: course.prerequisiteCourses,
      );

      await _programService.updateCourse(_section.id, updatedCourse);

      // Update all group IDs
      await _updateAllGroups();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(_languageManager.currentStrings.courseRemovedFromGroup)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _addCourse() async {
    // final course = await showDialog<Course>(
    //   context: context,
    //   builder: (context) => Dialog(
    //     insetPadding: const EdgeInsets.symmetric(horizontal: 20),
    //     child: CourseFormDialog(sectionId: _section.id),
    //   ),
    // );

    final course = await showDialog<Course>(
        context: context,
        builder: (context) => CourseFormDialog(sectionId: _section.id));

    if (course != null) {
      try {
        await _programService.addCourse(_section.id, course);
        final updatedSections = await _programService.getSections();
        setState(() {
          _section = updatedSections.firstWhere((s) => s.id == _section.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(_languageManager.currentStrings.sectionAdded)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _editCourse(Course course) async {
    // final updatedCourse = await showDialog<Course>(
    //   context: context,
    //   builder: (context) => Dialog(
    //     insetPadding: const EdgeInsets.symmetric(horizontal: 20),
    //     child: CourseFormDialog(
    //       sectionId: _section.id,
    //       course: course,
    //     ),
    //   ),
    // );

    final updatedCourse = await showDialog<Course>(
        context: context,
        builder: (context) =>
            CourseFormDialog(sectionId: _section.id, course: course));

    if (updatedCourse != null) {
      try {
        await _programService.updateCourse(_section.id, updatedCourse);
        final updatedSections = await _programService.getSections();
        setState(() {
          _section = updatedSections.firstWhere((s) => s.id == _section.id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(_languageManager.currentStrings.sectionUpdated)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteCourse(Course course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_languageManager.currentStrings.confirmDelete),
        content: Text(_languageManager.currentStrings
            .courseDeleteConfirmation(course.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(_languageManager.currentStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(_languageManager.currentStrings.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _programService.deleteCourse(_section.id, course.id);
        await _updateAllGroups();
       setState(() {});
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_section.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_isGroupMode) ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _toggleGroupMode,
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _selectedCourses.isNotEmpty
                  ? () => _createGroup(_selectedCourses.toList())
                  : null,
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.group),
              onPressed: _toggleGroupMode,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addCourse,
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionInfo(),
            const Divider(height: 32),
            if (_isGroupMode) _buildGroupModeActions(),
            _buildCourseList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionInfo() {
    final completedRequiredCredits = _section.courses
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final completedOptionalCredits = _section.courses
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressRequiredCredits = _section.courses
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressOptionalCredits = _section.courses
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _section.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _section.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildCreditInfo(
              '${_languageManager.currentStrings.requiredCredits}:',
              _section.requiredCredits,
              completedCredits: completedRequiredCredits,
              inProgressCredits: inProgressRequiredCredits,
            ),
            const SizedBox(height: 4),
            _buildCreditInfo(
              '${_languageManager.currentStrings.optionalCredits}:',
              _section.optionalCredits,
              completedCredits: completedOptionalCredits,
              inProgressCredits: inProgressOptionalCredits,
            ),
            const SizedBox(height: 4),
            _buildCreditInfo(
              '${_languageManager.currentStrings.totalCredits}:',
              _section.requiredCredits + _section.optionalCredits,
              completedCredits:
                  completedRequiredCredits + completedOptionalCredits,
              inProgressCredits:
                  inProgressRequiredCredits + inProgressOptionalCredits,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditInfo(
    String label,
    int credits, {
    int? completedCredits,
    int? inProgressCredits,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            Text(
              completedCredits != null ? '$completedCredits' : '0',
              style: TextStyle(
                color: AppColors.success,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (inProgressCredits != null && inProgressCredits > 0) ...[
              Text(
                ' (+$inProgressCredits)',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
            Text(
              '/$credits ${_languageManager.currentStrings.credits}',
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? AppColors.primary : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupModeActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_selectedCourses.length} ${_languageManager.currentStrings.courses} ${_languageManager.currentStrings.selected}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _selectedCourses.clear()),
            child: Text(_languageManager.currentStrings.clearSelection),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList() {
    final completedCourses = _section.courses
        .where((course) => course.status == CourseStatus.completed)
        .toList();
    final inProgressCourses = _section.courses
        .where((course) => course.status == CourseStatus.inProgress)
        .toList();
    final notStartedCourses = _section.courses
        .where((course) => course.status == CourseStatus.notStarted)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (completedCourses.isNotEmpty) ...[
            _buildCourseSection(
              _languageManager.currentStrings.completedCourses,
              completedCourses,
              AppColors.success,
            ),
            const SizedBox(height: 16),
          ],
          if (inProgressCourses.isNotEmpty) ...[
            _buildCourseSection(
              _languageManager.currentStrings.inProgressCourses,
              inProgressCourses,
              AppColors.primary,
            ),
            const SizedBox(height: 16),
          ],
          if (notStartedCourses.isNotEmpty)
            _buildCourseSection(
              _languageManager.currentStrings.notStartedCourses,
              notStartedCourses,
              AppColors.textSecondary,
            ),
        ],
      ),
    );
  }

  Widget _buildCourseSection(String title, List<Course> courses, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...courses.map((course) => _buildCourseCard(course, color)),
      ],
    );
  }

  Widget _buildCourseCard(Course course, Color color) {
    final groupColor = _getGroupColor(course.idGroup);
    final isInGroup = course.idGroup != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border: isInGroup
              ? Border(
                  left: BorderSide(
                    color: groupColor,
                    width: 4,
                  ),
                )
              : null,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: _isGroupMode ? 0 : 16),
          horizontalTitleGap: 0,
          leading: _isGroupMode
              ? Checkbox(
                  value: _selectedCourses.contains(course),
                  onChanged: (value) => _toggleCourseSelection(course),
                )
              : null,
          title: Text(
            "${course.id} - ${course.name}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isInGroup ? groupColor : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip(
                        '${course.credits} ${_languageManager.currentStrings.credits}',
                        Icons.school),
                    const SizedBox(width: 8),
                    _buildChip(
                      course.type == CourseType.required
                          ? _languageManager.currentStrings.required
                          : _languageManager.currentStrings.optional,
                      Icons.bookmark,
                    ),
                    if (course.grade != null) ...[
                      const SizedBox(width: 8),
                      _buildChip(
                          '${_languageManager.currentStrings.grade}: ${course.grade}',
                          Icons.grade),
                    ],
                    if (isInGroup) ...[
                      const SizedBox(width: 8),
                      _buildChip(
                        '${_languageManager.currentStrings.group} ${course.idGroup}',
                        Icons.group,
                        color: groupColor,
                      ),
                    ],
                  ],
                ),
              ),
              if (course.prerequisiteCourses.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '${_languageManager.currentStrings.prerequisiteCourses}: ${course.prerequisiteCourses}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
          trailing: _isGroupMode
              ? PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.remove_circle, color: AppColors.error),
                          const SizedBox(width: 8),
                          Text(
                            _languageManager.currentStrings.removeFromGroup,
                            style: TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'remove') {
                      _removeFromGroup(course);
                    }
                  },
                )
              : PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 8),
                          Text(_languageManager.currentStrings.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: AppColors.error),
                          const SizedBox(width: 8),
                          Text(
                            _languageManager.currentStrings.delete,
                            style: TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _editCourse(course);
                        break;
                      case 'delete':
                        _deleteCourse(course);
                        break;
                    }
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color != null ? Colors.white : null),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color != null ? Colors.white : null,
            ),
          ),
        ],
      ),
    );
  }
}
