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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionInfo(),
            const Divider(height: 32),
            _buildCourseGroupsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionInfo() {
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

  Widget _buildCourseGroupsList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _section.courseGroups.map((group) {
          return _buildCourseGroupCard(group);
        }).toList(),
      ),
    );
  }

  Widget _buildCourseGroupCard(CourseGroup group) {
    final completedRequiredCredits = group.courses
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final completedOptionalCredits = group.courses
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressRequiredCredits = group.courses
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressOptionalCredits = group.courses
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final totalCompletedCredits =
        completedRequiredCredits + completedOptionalCredits;
    final totalInProgressCredits =
        inProgressRequiredCredits + inProgressOptionalCredits;
    final totalCredits = group.requiredCredits + group.optionalCredits;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
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
              title: Text(
                group.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                group.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
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
                LinearProgressIndicator(
                  value: totalCompletedCredits / totalCredits,
                  backgroundColor: AppColors.progressBackground,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.progressValue),
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
                            text: '$completedRequiredCredits',
                            style: const TextStyle(color: AppColors.success),
                          ),
                          if (inProgressRequiredCredits > 0)
                            TextSpan(
                              text: ' (+$inProgressRequiredCredits)',
                              style: const TextStyle(
                                  color: AppColors.progressInProgress),
                            ),
                          TextSpan(text: '/${group.requiredCredits}'),
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
                              text: ' (+$inProgressOptionalCredits)',
                              style: const TextStyle(
                                  color: AppColors.progressInProgress),
                            ),
                          TextSpan(text: '/${group.optionalCredits}'),
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
                          style: const TextStyle(
                              color: AppColors.progressInProgress),
                        ),
                      TextSpan(text: '/$totalCredits'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ExpansionTile(
            title: Text(
              '${_languageManager.currentStrings.courses} (${group.courses.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: group.courses.map((course) {
              return CourseCard(
                course: course,
                languageManager: _languageManager,
                onChangeCourseStatus: (status) async {
                  var newCourse = course.copyWith(status: status);
                  await _programService.updateCourse(
                      _section.id, group.id, newCourse);
                  final updatedSection =
                      await _programService.getSection(_section.id);
                  setState(() {
                    _section = updatedSection!;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
