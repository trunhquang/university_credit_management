import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/section.dart';
import '../models/course_group.dart';
import '../models/course.dart';
import '../services/program_service.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';
import '../widgets/course_card.dart';
import 'course_list_screen.dart';
import 'all_courses_screen.dart';

class CourseGroupScreen extends StatefulWidget {
  final Section section;

  const CourseGroupScreen({
    super.key,
    required this.section,
  });

  @override
  State<CourseGroupScreen> createState() => _CourseGroupScreenState();
}

class _CourseGroupScreenState extends State<CourseGroupScreen> {
  late Section _section;
  late final LanguageManager _languageManager;
  final _programService = ProgramService();
  final _searchController = TextEditingController();
  String _searchQuery = '';
  CourseStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _section = widget.section;
    _languageManager = Provider.of<LanguageManager>(context, listen: false);
    _languageManager.addListener(_onLanguageChanged);
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _languageManager.removeListener(_onLanguageChanged);
    super.dispose();
  }

  Future<void> _showAddEditGroupDialog([CourseGroup? group]) async {
    final nameController = TextEditingController(text: group?.name ?? '');
    final descriptionController =
        TextEditingController(text: group?.description ?? '');
    final requiredCreditsController =
        TextEditingController(text: group?.requiredCredits.toString() ?? '0');
    final optionalCreditsController =
        TextEditingController(text: group?.optionalCredits.toString() ?? '0');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(group == null
            ? _languageManager.currentStrings.createGroup
            : _languageManager.currentStrings.edit),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: _languageManager.currentStrings.group,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: _languageManager.currentStrings.description,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: requiredCreditsController,
                decoration: InputDecoration(
                  labelText: _languageManager.currentStrings.requiredCredits,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: optionalCreditsController,
                decoration: InputDecoration(
                  labelText: _languageManager.currentStrings.optionalCredits,
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_languageManager.currentStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              final newGroup = CourseGroup(
                id: group?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                description: descriptionController.text,
                requiredCredits:
                    int.tryParse(requiredCreditsController.text) ?? 0,
                optionalCredits:
                    int.tryParse(optionalCreditsController.text) ?? 0,
                courses: group?.courses ?? [],
              );

              if (group == null) {
                await _programService.addCourseGroup(_section.id, newGroup);
              } else {
                await _programService.updateCourseGroup(_section.id, newGroup);
              }
              if (mounted) {
                Navigator.pop(context);
                // Refresh section data
                final updatedSection =
                    await _programService.getSection(_section.id);
                if (updatedSection != null) {
                  setState(() {
                    _section = updatedSection;
                  });
                }
              }
            },
            child: Text(_languageManager.currentStrings.save),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteGroupConfirmation(CourseGroup group) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_languageManager.currentStrings.confirmDelete),
        content: Text(_languageManager.currentStrings.groupRemoved),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_languageManager.currentStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              await _programService.deleteCourseGroup(_section.id, group.id);
              if (mounted) {
                Navigator.pop(context);
                // Refresh section data
                final updatedSection =
                    await _programService.getSection(_section.id);
                if (updatedSection != null) {
                  setState(() {
                    _section = updatedSection;
                  });
                }
              }
            },
            child: Text(_languageManager.currentStrings.delete),
          ),
        ],
      ),
    );
  }

  List<Course> _filterCourses(List<Course> courses) {
    return courses.where((course) {
      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!course.id.toLowerCase().contains(query) &&
            !course.name.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Filter by status
      if (_selectedStatus != null && course.status != _selectedStatus) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_section.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditGroupDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _languageManager.currentStrings.searchCourse,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<CourseStatus?>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: _languageManager.currentStrings.filterByStatus,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
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
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionInfo(),
                  const Divider(height: 32),
                  _buildCourseGroupsList(),
                ],
              ),
            ),
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

  Widget _buildSectionInfo() {
    // Calculate credits by status and type
    final completedRequiredCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final completedOptionalCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressRequiredCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressOptionalCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final registeringRequiredCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.registering &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final registeringOptionalCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.registering &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final needToRegisterRequiredCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.needToRegister &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final needToRegisterOptionalCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.needToRegister &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final notStartedRequiredCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.notStarted &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final notStartedOptionalCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.notStarted &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final failedRequiredCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.failed &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final failedOptionalCredits = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.failed &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    // Calculate total credits by status
    final totalCompletedCredits = completedRequiredCredits + completedOptionalCredits;
    final totalInProgressCredits = inProgressRequiredCredits + inProgressOptionalCredits;
    final totalRegisteringCredits = registeringRequiredCredits + registeringOptionalCredits;
    final totalNeedToRegisterCredits = needToRegisterRequiredCredits + needToRegisterOptionalCredits;
    final totalNotStartedCredits = notStartedRequiredCredits + notStartedOptionalCredits;
    final totalFailedCredits = failedRequiredCredits + failedOptionalCredits;

    // Count courses by status
    final completedCourses = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.completed)
        .length;
    final inProgressCourses = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.inProgress)
        .length;
    final registeringCourses = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.registering)
        .length;
    final needToRegisterCourses = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.needToRegister)
        .length;
    final notStartedCourses = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.notStarted)
        .length;
    final failedCourses = _section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.failed)
        .length;

    // Check if section is completed
    final isSectionCompleted = completedRequiredCredits >= _section.requiredCredits &&
        completedOptionalCredits >= _section.optionalCredits;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCoursesScreen(selectedSectionId: _section.id),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _section.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: isSectionCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: isSectionCompleted
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSectionCompleted)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 24,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _section.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSectionCompleted
                          ? AppColors.textSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Course status summary
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (completedCourses > 0)
                  _buildStatusChip(
                    AppColors.success,
                    '${_languageManager.currentStrings.completed}: $completedCourses (${totalCompletedCredits} ${_languageManager.currentStrings.credits})',
                  ),
                if (inProgressCourses > 0)
                  _buildStatusChip(
                    AppColors.primary,
                    '${_languageManager.currentStrings.inProgress}: $inProgressCourses (${totalInProgressCredits} ${_languageManager.currentStrings.credits})',
                  ),
                if (registeringCourses > 0)
                  _buildStatusChip(
                    AppColors.info,
                    '${_languageManager.currentStrings.registering}: $registeringCourses (${totalRegisteringCredits} ${_languageManager.currentStrings.credits})',
                  ),
                if (needToRegisterCourses > 0)
                  _buildStatusChip(
                    AppColors.warning,
                    '${_languageManager.currentStrings.needToRegister}: $needToRegisterCourses (${totalNeedToRegisterCredits} ${_languageManager.currentStrings.credits})',
                  ),
                if (notStartedCourses > 0)
                  _buildStatusChip(
                    AppColors.textSecondary,
                    '${_languageManager.currentStrings.notStarted}: $notStartedCourses (${totalNotStartedCredits} ${_languageManager.currentStrings.credits})',
                  ),
                if (failedCourses > 0)
                  _buildStatusChip(
                    AppColors.error,
                    '${_languageManager.currentStrings.failed}: $failedCourses (${totalFailedCredits} ${_languageManager.currentStrings.credits})',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCreditInfo(
              '${_languageManager.currentStrings.requiredCredits}:',
              _section.requiredCredits,
              completedCredits: completedRequiredCredits,
              inProgressCredits: inProgressRequiredCredits,
              registeringCredits: registeringRequiredCredits,
              isCompleted: completedRequiredCredits >= _section.requiredCredits,
            ),
            const SizedBox(height: 4),
            _buildCreditInfo(
              '${_languageManager.currentStrings.optionalCredits}:',
              _section.optionalCredits,
              completedCredits: completedOptionalCredits,
              inProgressCredits: inProgressOptionalCredits,
              registeringCredits: registeringOptionalCredits,
              isCompleted: completedOptionalCredits >= _section.optionalCredits,
            ),
            const SizedBox(height: 4),
            _buildCreditInfo(
              '${_languageManager.currentStrings.totalCredits}:',
              _section.requiredCredits + _section.optionalCredits,
              completedCredits: totalCompletedCredits,
              inProgressCredits: totalInProgressCredits,
              registeringCredits: totalRegisteringCredits,
              isTotal: true,
              isCompleted: isSectionCompleted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCreditInfo(
    String label,
    int credits, {
    int? completedCredits,
    int? inProgressCredits,
    int? registeringCredits,
    bool isTotal = false,
    bool isCompleted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isCompleted ? AppColors.textSecondary : null,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        Row(
          children: [
            Text(
              completedCredits != null ? '$completedCredits' : '0',
              style: TextStyle(
                color: isCompleted ? AppColors.success : AppColors.success,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            if (inProgressCredits != null && inProgressCredits > 0)
              Text(
                ' (+$inProgressCredits)',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            if (registeringCredits != null && registeringCredits > 0)
              Text(
                ' (+$registeringCredits)',
                style: TextStyle(
                  color: AppColors.info,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            Text(
              '/$credits ${_languageManager.currentStrings.credits}',
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? AppColors.primary : null,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseGroupsList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _section.courseGroups
            .where((group) => _filterCourses(group.courses).isNotEmpty)
            .map((group) {
              return _buildCourseGroupCard(group);
            }).toList(),
      ),
    );
  }

  Widget _buildCourseGroupCard(CourseGroup group) {
    final filteredCourses = _filterCourses(group.courses);
    
    // Calculate credits by status and type
    final completedRequiredCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final completedOptionalCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressRequiredCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressOptionalCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final registeringRequiredCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.registering &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final registeringOptionalCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.registering &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final needToRegisterRequiredCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.needToRegister &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final needToRegisterOptionalCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.needToRegister &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final notStartedRequiredCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.notStarted &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final notStartedOptionalCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.notStarted &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final failedRequiredCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.failed &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final failedOptionalCredits = filteredCourses
        .where((course) =>
            course.status == CourseStatus.failed &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    // Calculate total credits by status
    final totalCompletedCredits = completedRequiredCredits + completedOptionalCredits;
    final totalInProgressCredits = inProgressRequiredCredits + inProgressOptionalCredits;
    final totalRegisteringCredits = registeringRequiredCredits + registeringOptionalCredits;
    final totalNeedToRegisterCredits = needToRegisterRequiredCredits + needToRegisterOptionalCredits;
    final totalNotStartedCredits = notStartedRequiredCredits + notStartedOptionalCredits;
    final totalFailedCredits = failedRequiredCredits + failedOptionalCredits;

    // Count courses by status
    final completedCourses = filteredCourses
        .where((course) => course.status == CourseStatus.completed)
        .length;
    final inProgressCourses = filteredCourses
        .where((course) => course.status == CourseStatus.inProgress)
        .length;
    final registeringCourses = filteredCourses
        .where((course) => course.status == CourseStatus.registering)
        .length;
    final needToRegisterCourses = filteredCourses
        .where((course) => course.status == CourseStatus.needToRegister)
        .length;
    final notStartedCourses = filteredCourses
        .where((course) => course.status == CourseStatus.notStarted)
        .length;
    final failedCourses = filteredCourses
        .where((course) => course.status == CourseStatus.failed)
        .length;

    final totalCredits = group.requiredCredits + group.optionalCredits;

    // Check if group is completed
    final isGroupCompleted = completedRequiredCredits >= group.requiredCredits &&
        completedOptionalCredits >= group.optionalCredits;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseListScreen(
                    section: _section,
                    courseGroup: group,
                  ),
                ),
              ).then((value) async {
                final updatedSection =
                    await _programService.getSection(_section.id);
                setState(() {
                  _section = updatedSection!;
                });
              });
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      group.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isGroupCompleted
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        decoration: isGroupCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  if (isGroupCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                ],
              ),
              subtitle: Text(
                group.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isGroupCompleted
                      ? AppColors.textSecondary
                      : AppColors.textSecondary,
                  decoration: isGroupCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                    ),
                    onPressed: () => _showAddEditGroupDialog(group),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.error),
                    onPressed: () => _showDeleteGroupConfirmation(group),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Course status summary
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (completedCourses > 0)
                      _buildStatusChip(
                        AppColors.success,
                        '${_languageManager.currentStrings.completed}: $completedCourses (${totalCompletedCredits} ${_languageManager.currentStrings.credits})',
                      ),
                    if (inProgressCourses > 0)
                      _buildStatusChip(
                        AppColors.primary,
                        '${_languageManager.currentStrings.inProgress}: $inProgressCourses (${totalInProgressCredits} ${_languageManager.currentStrings.credits})',
                      ),
                    if (registeringCourses > 0)
                      _buildStatusChip(
                        AppColors.info,
                        '${_languageManager.currentStrings.registering}: $registeringCourses (${totalRegisteringCredits} ${_languageManager.currentStrings.credits})',
                      ),
                    if (needToRegisterCourses > 0)
                      _buildStatusChip(
                        AppColors.warning,
                        '${_languageManager.currentStrings.needToRegister}: $needToRegisterCourses (${totalNeedToRegisterCredits} ${_languageManager.currentStrings.credits})',
                      ),
                    if (notStartedCourses > 0)
                      _buildStatusChip(
                        AppColors.textSecondary,
                        '${_languageManager.currentStrings.notStarted}: $notStartedCourses (${totalNotStartedCredits} ${_languageManager.currentStrings.credits})',
                      ),
                    if (failedCourses > 0)
                      _buildStatusChip(
                        AppColors.error,
                        '${_languageManager.currentStrings.failed}: $failedCourses (${totalFailedCredits} ${_languageManager.currentStrings.credits})',
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: totalCompletedCredits / totalCredits,
                  backgroundColor: AppColors.progressBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isGroupCompleted
                        ? AppColors.success
                        : AppColors.progressValue,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontSize: 12),
                        children: [
                          TextSpan(
                            text: '${_languageManager.currentStrings.required}: ',
                            style: TextStyle(
                              color: completedRequiredCredits >= group.requiredCredits
                                  ? AppColors.textSecondary
                                  : null,
                              decoration: completedRequiredCredits >= group.requiredCredits
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          TextSpan(
                            text: '$completedRequiredCredits',
                            style: const TextStyle(color: AppColors.success),
                          ),
                          if (inProgressRequiredCredits > 0)
                            TextSpan(
                              text: ' (+$inProgressRequiredCredits)',
                              style: const TextStyle(
                                  color: AppColors.progressInProgress),
                            ),
                          if (registeringRequiredCredits > 0)
                            TextSpan(
                              text: ' (+$registeringRequiredCredits)',
                              style: const TextStyle(
                                  color: AppColors.info),
                            ),
                          TextSpan(
                            text: '/${group.requiredCredits}',
                            style: TextStyle(
                              decoration: completedRequiredCredits >= group.requiredCredits
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontSize: 12),
                        children: [
                          TextSpan(
                            text: '${_languageManager.currentStrings.optional}: ',
                            style: TextStyle(
                              color: completedOptionalCredits >= group.optionalCredits
                                  ? AppColors.textSecondary
                                  : null,
                              decoration: completedOptionalCredits >= group.optionalCredits
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          TextSpan(
                            text: '$completedOptionalCredits',
                            style: const TextStyle(color: AppColors.success),
                          ),
                          if (inProgressOptionalCredits > 0)
                            TextSpan(
                              text: ' (+$inProgressOptionalCredits)',
                              style: const TextStyle(
                                  color: AppColors.progressInProgress),
                            ),
                          if (registeringOptionalCredits > 0)
                            TextSpan(
                              text: ' (+$registeringOptionalCredits)',
                              style: const TextStyle(
                                  color: AppColors.info),
                            ),
                          TextSpan(
                            text: '/${group.optionalCredits}',
                            style: TextStyle(
                              decoration: completedOptionalCredits >= group.optionalCredits
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: '${_languageManager.currentStrings.totalCredits}: ',
                        style: TextStyle(
                          color: isGroupCompleted
                              ? AppColors.textSecondary
                              : null,
                          decoration: isGroupCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      TextSpan(
                        text: '$totalCompletedCredits',
                        style: const TextStyle(color: AppColors.success),
                      ),
                      if (totalInProgressCredits > 0)
                        TextSpan(
                          text: ' (+$totalInProgressCredits)',
                          style: const TextStyle(
                              color: AppColors.progressInProgress),
                        ),
                      if (totalRegisteringCredits > 0)
                        TextSpan(
                          text: ' (+$totalRegisteringCredits)',
                          style: const TextStyle(
                              color: AppColors.info),
                        ),
                      TextSpan(
                        text: '/$totalCredits',
                        style: TextStyle(
                          decoration: isGroupCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (filteredCourses.isNotEmpty)
            ExpansionTile(
              title: Text(
                '${_languageManager.currentStrings.courses} (${filteredCourses.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: filteredCourses.map((course) {
                return CourseCard(
                  course: course,
                  languageManager: _languageManager,
                  onChangeCourseStatus: (status) {
                    setState(() {
                      final updatedCourse = course.copyWith(status: status);
                      final courseIndex = group.courses.indexOf(course);
                      if (courseIndex != -1) {
                        group.courses[courseIndex] = updatedCourse;
                        _saveCourseGroup(group);
                      }
                    });
                  },
                  onScoreChanged: (score) {
                    setState(() {
                      _saveCourseGroup(group);
                    });
                  },
                );
              }).toList(),
            ),
          if (filteredCourses.isEmpty && _searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  _languageManager.currentStrings.noCoursesFound,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _saveCourseGroup(CourseGroup group) async {
    try {
      await _programService.updateCourseGroup(_section.id, group);
      final updatedSection = await _programService.getSection(_section.id);
      if (updatedSection != null) {
        setState(() {
          _section = updatedSection;
        });
      }
    } catch (e) {
      debugPrint('Error saving course group: $e');
      // TODO: Show error message to user
    }
  }
}
