import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/section.dart';
import '../models/course_group.dart';
import '../models/course.dart';
import '../services/program_service.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';
import '../widgets/course_card.dart';

class CourseListScreen extends StatefulWidget {
  final Section section;
  final CourseGroup courseGroup;

  const CourseListScreen({
    super.key,
    required this.section,
    required this.courseGroup,
  });

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  late Section _section;
  late CourseGroup _courseGroup;
  late final LanguageManager _languageManager;
  final _programService = ProgramService();

  @override
  void initState() {
    super.initState();
    _section = widget.section;
    _courseGroup = widget.courseGroup;
    _languageManager = Provider.of<LanguageManager>(context, listen: false);
    _languageManager.addListener(_onLanguageChanged);
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _languageManager.removeListener(_onLanguageChanged);
    super.dispose();
  }

  Future<void> _showAddEditCourseDialog([Course? course]) async {
    final idController = TextEditingController(text: course?.id ?? '');
    final nameController = TextEditingController(text: course?.name ?? '');
    final creditsController =
        TextEditingController(text: course?.credits.toString() ?? '0');
    final scoreController =
        TextEditingController(text: course?.score?.toString() ?? '');
    CourseType selectedType = course?.type ?? CourseType.required;
    CourseStatus selectedStatus = course?.status ?? CourseStatus.notStarted;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(course == null
              ? _languageManager.currentStrings.addCourse
              : _languageManager.currentStrings.editCourse),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: _languageManager.currentStrings.courseId,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: _languageManager.currentStrings.courseName,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: creditsController,
                  decoration: InputDecoration(
                    labelText: _languageManager.currentStrings.credits,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<CourseType>(
                  value: selectedType,
                  decoration: InputDecoration(
                    labelText: _languageManager.currentStrings.courseType,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: CourseType.required,
                      child: Text(_languageManager.currentStrings.required),
                    ),
                    DropdownMenuItem(
                      value: CourseType.optional,
                      child: Text(_languageManager.currentStrings.optional),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<CourseStatus>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    labelText: _languageManager.currentStrings.status,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: CourseStatus.notStarted,
                      child: Text(_languageManager.currentStrings.notStarted),
                    ),
                    DropdownMenuItem(
                      value: CourseStatus.inProgress,
                      child: Text(_languageManager.currentStrings.inProgress),
                    ),
                    DropdownMenuItem(
                      value: CourseStatus.completed,
                      child: Text(_languageManager.currentStrings.completed),
                    ),
                    DropdownMenuItem(
                      value: CourseStatus.failed,
                      child: Text(_languageManager.currentStrings.failed),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedStatus = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: scoreController,
                  decoration: InputDecoration(
                    labelText: _languageManager.currentStrings.score,
                    hintText: _languageManager.currentStrings.enterScore,
                    enabled: selectedStatus == CourseStatus.completed ||
                        selectedStatus == CourseStatus.failed,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  enabled: selectedStatus == CourseStatus.completed ||
                      selectedStatus == CourseStatus.failed,
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
                final newCourse = Course(
                  id: idController.text,
                  name: nameController.text,
                  credits: int.tryParse(creditsController.text) ?? 0,
                  type: selectedType,
                  status: selectedStatus,
                  score: selectedStatus == CourseStatus.completed ||
                          selectedStatus == CourseStatus.failed
                      ? double.tryParse(scoreController.text)
                      : null,
                );

                if (course == null) {
                  await _programService.addCourse(
                      _section.id, _courseGroup.id, newCourse);
                } else {
                  await _programService.updateCourse(
                      _section.id, _courseGroup.id, newCourse);
                }
                _refreshData();

                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(_languageManager.currentStrings.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfo() {
    // Calculate credits by status and type
    final completedRequiredCredits = _courseGroup.courses
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final completedOptionalCredits = _courseGroup.courses
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressRequiredCredits = _courseGroup.courses
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressOptionalCredits = _courseGroup.courses
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final registeringRequiredCredits = _courseGroup.courses
        .where((course) =>
            course.status == CourseStatus.registering &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final registeringOptionalCredits = _courseGroup.courses
        .where((course) =>
            course.status == CourseStatus.registering &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final needToRegisterRequiredCredits = _courseGroup.courses
        .where((course) =>
            course.status == CourseStatus.needToRegister &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final needToRegisterOptionalCredits = _courseGroup.courses
        .where((course) =>
            course.status == CourseStatus.needToRegister &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final notStartedRequiredCredits = _courseGroup.courses
        .where((course) =>
            course.status == CourseStatus.notStarted &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final notStartedOptionalCredits = _courseGroup.courses
        .where((course) =>
            course.status == CourseStatus.notStarted &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final failedRequiredCredits = _courseGroup.courses
        .where((course) =>
            course.status == CourseStatus.failed &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final failedOptionalCredits = _courseGroup.courses
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
    final completedCourses = _courseGroup.courses
        .where((course) => course.status == CourseStatus.completed)
        .length;
    final inProgressCourses = _courseGroup.courses
        .where((course) => course.status == CourseStatus.inProgress)
        .length;
    final registeringCourses = _courseGroup.courses
        .where((course) => course.status == CourseStatus.registering)
        .length;
    final needToRegisterCourses = _courseGroup.courses
        .where((course) => course.status == CourseStatus.needToRegister)
        .length;
    final notStartedCourses = _courseGroup.courses
        .where((course) => course.status == CourseStatus.notStarted)
        .length;
    final failedCourses = _courseGroup.courses
        .where((course) => course.status == CourseStatus.failed)
        .length;

    final totalCredits = _courseGroup.requiredCredits + _courseGroup.optionalCredits;

    // Check if group is completed
    final isGroupCompleted = completedRequiredCredits >= _courseGroup.requiredCredits &&
        completedOptionalCredits >= _courseGroup.optionalCredits;

    // Update group completion status if needed
    if (isGroupCompleted != _courseGroup.isCompleted) {
      _updateGroupCompletionStatus(isGroupCompleted);
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _courseGroup.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: _courseGroup.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: _courseGroup.isCompleted
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (_courseGroup.isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _courseGroup.description,
              style: TextStyle(
                fontSize: 14,
                color: _courseGroup.isCompleted
                    ? AppColors.textSecondary
                    : AppColors.textSecondary,
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
            LinearProgressIndicator(
              value: totalCompletedCredits / totalCredits,
              backgroundColor: AppColors.progressBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                _courseGroup.isCompleted
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
                          text:
                              '${_languageManager.currentStrings.required}: '),
                      TextSpan(
                        text: '${completedRequiredCredits}',
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
                      TextSpan(text: '/${_courseGroup.requiredCredits}'),
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
                          text:
                              '${_languageManager.currentStrings.optional}: '),
                      TextSpan(
                        text: '$completedOptionalCredits',
                        style: const TextStyle(color: AppColors.success),
                      ),
                      if (inProgressOptionalCredits > 0)
                        TextSpan(
                          text: ' (+${inProgressOptionalCredits})',
                          style: const TextStyle(
                              color: AppColors.progressInProgress),
                        ),
                      if (registeringOptionalCredits > 0)
                        TextSpan(
                          text: ' (+$registeringOptionalCredits)',
                          style: const TextStyle(
                              color: AppColors.info),
                        ),
                      TextSpan(text: '/${_courseGroup.optionalCredits}'),
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
                      text:
                          '${_languageManager.currentStrings.totalCredits}: '),
                  TextSpan(
                    text: '$totalCompletedCredits',
                    style: const TextStyle(color: AppColors.success),
                  ),
                  if (totalInProgressCredits > 0)
                    TextSpan(
                      text: ' (+$totalInProgressCredits)',
                      style:
                          const TextStyle(color: AppColors.progressInProgress),
                    ),
                  if (totalRegisteringCredits > 0)
                    TextSpan(
                      text: ' (+$totalRegisteringCredits)',
                      style:
                          const TextStyle(color: AppColors.info),
                    ),
                  TextSpan(text: '/$totalCredits'),
                ],
              ),
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

  Future<void> _updateGroupCompletionStatus(bool isCompleted) async {
    final updatedGroup = _courseGroup.copyWith(isCompleted: isCompleted);
    await _programService.updateCourseGroup(_section.id, updatedGroup);
    _refreshData();
  }

  Widget _buildCourseList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_languageManager.currentStrings.courses} (${_courseGroup.courses.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._courseGroup.courses.map((course) {
            return Dismissible(
              key: Key(course.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                color: AppColors.error,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: (direction) async {
                final result = await _showDeleteCourseConfirmation(course);
                return result ?? false;
              },
              onDismissed: (direction) async {
                // Item will be removed from the list immediately
                setState(() {
                  _courseGroup.courses.removeWhere((c) => c.id == course.id);
                });
                // Then update the backend
                await _programService.deleteCourse(
                    _section.id, _courseGroup.id, course.id);
                // Refresh data to ensure consistency
                _refreshData();
              },
              child: GestureDetector(
                  onTap: () => _showAddEditCourseDialog(course),
                  child: CourseCard(
                    course: course,
                    languageManager: _languageManager,
                    onChangeCourseStatus: (status) {
                      _saveCourseGroup(course: course, status: status);
                    },
                    onScoreChanged: (score) {
                      _saveCourseGroup(course: course, score: score);
                    },
                  )),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _saveCourseGroup(
      {required Course course, CourseStatus? status, double? score}) async {
    var _course = score ?? course.score;
    if (status != CourseStatus.completed ) {
      _course = 0;
    }
    var newCourse = course.copyWith(
        status: status ?? course.status, score: score ?? _course);
    await _programService.updateCourse(_section.id, _courseGroup.id, newCourse);
    _refreshData();
  }

  Future<void> _refreshData() async {
    final updatedSection = await _programService.getSection(_section.id);
    if (updatedSection != null && mounted) {
      setState(() {
        _section = updatedSection;
        _courseGroup = updatedSection.courseGroups.firstWhere(
          (group) => group.id == _courseGroup.id,
        );
      });
    }
  }

  Future<bool?> _showDeleteCourseConfirmation(Course course) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_languageManager.currentStrings.confirmDelete),
        content: Text(_languageManager.currentStrings.courseRemoved),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_languageManager.currentStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_languageManager.currentStrings.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_courseGroup.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditCourseDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupInfo(),
            const Divider(height: 32),
            _buildCourseList(),
          ],
        ),
      ),
    );
  }
}
