import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/program_service.dart';
import '../models/section.dart';
import '../models/course.dart';
import '../screens/course_group_screen.dart';
import '../widgets/section_form_dialog.dart';
import '../theme/app_colors.dart';
import '../l10n/language_manager.dart';
import '../screens/all_courses_screen.dart';

class CourseSessionScreen extends StatefulWidget {
  const CourseSessionScreen({super.key});

  @override
  State<CourseSessionScreen> createState() => _CourseSessionScreenState();
}

class _CourseSessionScreenState extends State<CourseSessionScreen> {
  final _programService = ProgramService();
  List<Section>? _sections;
  bool _isLoading = false;
  String _errorMessage = '';
  late final LanguageManager _languageManager;

  @override
  void initState() {
    super.initState();
    _languageManager = Provider.of<LanguageManager>(context, listen: false);
    _languageManager.addListener(_onLanguageChanged);
    _loadDataSourcePreference();
  }

  @override
  void dispose() {
    _languageManager.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  Future<void> _loadDataSourcePreference() async {
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final sections = await _programService.getSections();
    _sections = sections;


    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addSection() async {
    final section = await showDialog<Section>(
      context: context,
      builder: (context) => const SectionFormDialog(),
    );

    if (section != null) {
      await _programService.addSection(section);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_languageManager.currentStrings.sectionAdded)),
        );
      }
    }
  }

  Future<void> _editSection(Section section) async {
    final updatedSection = await showDialog<Section>(
      context: context,
      builder: (context) => SectionFormDialog(section: section),
    );

    if (updatedSection != null) {
      await _programService.updateSection(updatedSection);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_languageManager.currentStrings.sectionUpdated)),
        );
      }
    }
  }

  Future<void> _deleteSection(Section section) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_languageManager.currentStrings.confirmDelete),
        content: Text(
          _languageManager.currentStrings.deleteSectionConfirmation(section.name),
        ),
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
      await _programService.deleteSection(section.id);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_languageManager.currentStrings.sectionDeleted)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_languageManager.currentStrings.sections),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllCoursesScreen(),
                ),
              ).then((_) => _loadData());
            },
            tooltip: _languageManager.currentStrings.allCourses,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSection,
            tooltip: _languageManager.currentStrings.addSection,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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

    if (_sections == null || _sections!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_languageManager.currentStrings.noSections),
            ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addSection,
                child: Text(_languageManager.currentStrings.addSection),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sections!.length,
      itemBuilder: (context, index) {
        final section = _sections![index];
        return _buildSectionCard(context, section);
      },
    );
  }

  Widget _buildSectionCard(BuildContext context, Section section) {
    // Calculate credits by status and type
    final completedRequiredCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final completedOptionalCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.completed &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressRequiredCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final inProgressOptionalCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.inProgress &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final registeringRequiredCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.registering &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final registeringOptionalCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.registering &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final needToRegisterRequiredCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.needToRegister &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final needToRegisterOptionalCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.needToRegister &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final notStartedRequiredCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.notStarted &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final notStartedOptionalCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.notStarted &&
            course.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    final failedRequiredCredits = section.courseGroups
        .expand((group) => group.courses)
        .where((course) =>
            course.status == CourseStatus.failed &&
            course.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);

    final failedOptionalCredits = section.courseGroups
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
    final completedCourses = section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.completed)
        .length;
    final inProgressCourses = section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.inProgress)
        .length;
    final registeringCourses = section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.registering)
        .length;
    final needToRegisterCourses = section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.needToRegister)
        .length;
    final notStartedCourses = section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.notStarted)
        .length;
    final failedCourses = section.courseGroups
        .expand((group) => group.courses)
        .where((course) => course.status == CourseStatus.failed)
        .length;

    final totalCredits = section.requiredCredits + section.optionalCredits;

    // Check if section is completed
    final isSectionCompleted = completedRequiredCredits >= section.requiredCredits &&
        completedOptionalCredits >= section.optionalCredits;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    section.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSectionCompleted
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      decoration: isSectionCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                if (isSectionCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
              ],
            ),
            subtitle: Text(
              section.description,
              style: TextStyle(
                fontSize: 14,
                color: isSectionCompleted
                    ? AppColors.textSecondary
                    : AppColors.textSecondary,
                decoration: isSectionCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            trailing: PopupMenuButton<String>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(_languageManager.currentStrings.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: AppColors.error),
                      const SizedBox(width: 8),
                      Text(
                        _languageManager.currentStrings.delete,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _editSection(section);
                    break;
                  case 'delete':
                    _deleteSection(section);
                    break;
                }
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseGroupScreen(section: section),
                ),
              ).then((_) => _loadData());
            },
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
                    isSectionCompleted
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
                        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
                        children: [
                          TextSpan(
                            text: '${_languageManager.currentStrings.required}: ',
                            style: TextStyle(
                              color: completedRequiredCredits >= section.requiredCredits
                                  ? AppColors.textSecondary
                                  : null,
                              decoration: completedRequiredCredits >= section.requiredCredits
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
                              style: const TextStyle(color: AppColors.progressInProgress),
                            ),
                          if (registeringRequiredCredits > 0)
                            TextSpan(
                              text: ' (+$registeringRequiredCredits)',
                              style: const TextStyle(color: AppColors.info),
                            ),
                          TextSpan(
                            text: '/${section.requiredCredits}',
                            style: TextStyle(
                              decoration: completedRequiredCredits >= section.requiredCredits
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
                        children: [
                          TextSpan(
                            text: '${_languageManager.currentStrings.optional}: ',
                            style: TextStyle(
                              color: completedOptionalCredits >= section.optionalCredits
                                  ? AppColors.textSecondary
                                  : null,
                              decoration: completedOptionalCredits >= section.optionalCredits
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
                              style: const TextStyle(color: AppColors.progressInProgress),
                            ),
                          if (registeringOptionalCredits > 0)
                            TextSpan(
                              text: ' (+$registeringOptionalCredits)',
                              style: const TextStyle(color: AppColors.info),
                            ),
                          TextSpan(
                            text: '/${section.optionalCredits}',
                            style: TextStyle(
                              decoration: completedOptionalCredits >= section.optionalCredits
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
                          color: isSectionCompleted
                              ? AppColors.textSecondary
                              : null,
                          decoration: isSectionCompleted
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
                          style: const TextStyle(color: AppColors.progressInProgress),
                        ),
                      if (totalRegisteringCredits > 0)
                        TextSpan(
                          text: ' (+$totalRegisteringCredits)',
                          style: const TextStyle(color: AppColors.info),
                        ),
                      TextSpan(
                        text: '/$totalCredits',
                        style: TextStyle(
                          decoration: isSectionCompleted
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
        ],
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
} 