import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/program_service.dart';
import '../models/section.dart';
import '../models/course.dart';
import '../screens/course_group_screen.dart';
import '../widgets/section_form_dialog.dart';
import '../theme/app_colors.dart';
import '../l10n/language_manager.dart';

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
    // Tính toán số tín chỉ đã hoàn thành
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

    // Tính toán số tín chỉ đang học
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

    final totalCompletedCredits = completedRequiredCredits + completedOptionalCredits;
    final totalInProgressCredits = inProgressRequiredCredits + inProgressOptionalCredits;
    final totalCredits = section.requiredCredits + section.optionalCredits;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(
              section.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              section.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
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
                LinearProgressIndicator(
                  value: totalCompletedCredits / totalCredits,
                  backgroundColor: AppColors.progressBackground,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.progressValue),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
                        children: [
                          TextSpan(text: '${_languageManager.currentStrings.required}: '),
                          TextSpan(
                            text: '$completedRequiredCredits',
                            style: const TextStyle(color: AppColors.success),
                          ),
                          if (inProgressRequiredCredits > 0)
                            TextSpan(
                              text: ' (+$inProgressRequiredCredits)',
                              style: const TextStyle(color: AppColors.progressInProgress),
                            ),
                          TextSpan(text: '/${section.requiredCredits}'),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
                        children: [
                          TextSpan(text: '${_languageManager.currentStrings.optional}: '),
                          TextSpan(
                            text: '$completedOptionalCredits',
                            style: const TextStyle(color: AppColors.success),
                          ),
                          if (inProgressOptionalCredits > 0)
                            TextSpan(
                              text: ' (+$inProgressOptionalCredits)',
                              style: const TextStyle(color: AppColors.progressInProgress),
                            ),
                          TextSpan(text: '/${section.optionalCredits}'),
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
                      TextSpan(text: '${_languageManager.currentStrings.totalCredits}: '),
                      TextSpan(
                        text: '$totalCompletedCredits',
                        style: const TextStyle(color: AppColors.success),
                      ),
                      if (totalInProgressCredits > 0)
                        TextSpan(
                          text: ' (+$totalInProgressCredits)',
                          style: const TextStyle(color: AppColors.progressInProgress),
                        ),
                      TextSpan(text: '/$totalCredits'),
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
} 