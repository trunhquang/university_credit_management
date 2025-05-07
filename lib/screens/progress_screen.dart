import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/program_service.dart';
import '../services/course_service.dart';
import '../models/section.dart';
import '../models/course.dart';
import '../l10n/language_manager.dart';
import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final ProgramService _programService = ProgramService();
  final CourseService _courseService = CourseService();
  bool _isLoading = false;
  String _errorMessage = '';
  List<Section>? _sections;
  Map<String, dynamic>? _progress;
  double _overallGPA = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted || _isLoading) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Lấy dữ liệu thực từ service
      final sections = await _programService.getSections();

      // Tính toán tổng số tín chỉ
      final totalRequiredCredits = sections
          .fold(0, (sum, section) => sum + section.requiredCredits);
      final totalOptionalCredits = sections
          .fold(0, (sum, section) => sum + section.optionalCredits);
      final totalCredits = totalRequiredCredits + totalOptionalCredits;

      // Tính toán số tín chỉ đã hoàn thành và đang học
      final completedRequiredCredits = sections
          .expand((s) => s.allCourses)
          .where((c) => c.status == CourseStatus.completed && c.type == CourseType.required)
          .fold(0, (sum, course) => sum + course.credits);

      final completedOptionalCredits = sections
          .expand((s) => s.allCourses)
          .where((c) => c.status == CourseStatus.completed && c.type == CourseType.optional)
          .fold(0, (sum, course) => sum + course.credits);

      final inProgressRequiredCredits = sections
          .expand((s) => s.allCourses)
          .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.required)
          .fold(0, (sum, course) => sum + course.credits);

      final inProgressOptionalCredits = sections
          .expand((s) => s.allCourses)
          .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.optional)
          .fold(0, (sum, course) => sum + course.credits);

      final totalCompletedCredits = completedRequiredCredits + completedOptionalCredits;
      final totalInProgressCredits = inProgressRequiredCredits + inProgressOptionalCredits;

      _progress = {
        'totalCredits': totalCredits,
        'completedCredits': totalCompletedCredits,
        'inProgressCredits': totalInProgressCredits,
        'remainingCredits': totalCredits - totalCompletedCredits - totalInProgressCredits,
        'completedRequiredCredits': completedRequiredCredits,
        'completedOptionalCredits': completedOptionalCredits,
        'inProgressRequiredCredits': inProgressRequiredCredits,
        'inProgressOptionalCredits': inProgressOptionalCredits,
        'totalRequiredCredits': totalRequiredCredits,
        'totalOptionalCredits': totalOptionalCredits,
        'overallProgress': (totalCompletedCredits / totalCredits * 100).clamp(0, 100),
      };

      _sections = sections;
      _overallGPA = await _courseService.calculateOverallGPA();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Lỗi khi tải dữ liệu: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(context);
    final strings = languageManager.currentStrings;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.progressText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: AppColors.background,
      body: _buildBody(strings),
    );
  }

  Widget _buildBody(AppStrings strings) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(strings.retry),
            ),
          ],
        ),
      );
    }

    if (_progress == null) {
      return Center(
        child: Text(
          strings.noSections,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverallProgress(strings),
              const SizedBox(height: 24),
              _buildGPACard(strings),
              const SizedBox(height: 24),
              _buildCreditsSummary(strings),
              const SizedBox(height: 24),
              _buildSectionProgress(strings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallProgress(AppStrings strings) {
    final percentage = _progress!['overallProgress'].toDouble() ?? 0.0;
    final completedCredits = _progress!['completedCredits'] as int;
    final inProgressCredits = _progress!['inProgressCredits'] as int;
    final totalCredits = _progress!['totalCredits'] as int;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.completionProgress,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.progressBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage == 100 ? AppColors.progressCompleted : AppColors.progressInProgress,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${percentage.toStringAsFixed(2)}% ${strings.completed}',
                  style: TextStyle(
                    fontSize: 16,
                    color: percentage == 100 ? AppColors.success : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style.copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: '$completedCredits',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (inProgressCredits > 0)
                        TextSpan(
                          text: ' (+$inProgressCredits)',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      TextSpan(text: '/$totalCredits ${strings.credits}'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGPACard(AppStrings strings) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.school, size: 48, color: AppColors.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.gpa,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  _overallGPA.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditsSummary(AppStrings strings) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strings.totalCredits,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${strings.total}: ${_progress!['totalCredits']} ${strings.credits}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCreditRow(
              strings.requiredCredits,
              _progress!['completedRequiredCredits'],
              _progress!['inProgressRequiredCredits'],
              _progress!['totalRequiredCredits'],
              AppColors.primary,
              strings,
            ),
            const SizedBox(height: 12),
            _buildCreditRow(
              strings.optionalCredits,
              _progress!['completedOptionalCredits'],
              _progress!['inProgressOptionalCredits'],
              _progress!['totalOptionalCredits'],
              AppColors.secondary,
              strings,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: AppColors.divider),
            ),
            _buildCreditRow(
              strings.totalCredits,
              _progress!['completedCredits'],
              _progress!['inProgressCredits'],
              _progress!['totalCredits'],
              AppColors.info,
              strings,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditRow(
    String title,
    int completed,
    int inProgress,
    int total,
    Color color,
    AppStrings strings, {
    bool isTotal = false,
  }) {
    final double progress = total > 0 ? (completed + inProgress) / total : 0;
    final remaining = total - completed - inProgress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.progressBackground,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            children: [
              TextSpan(
                text: '$completed',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (inProgress > 0)
                TextSpan(
                  text: ' (+$inProgress)',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              TextSpan(text: '/$total ${strings.credits}'),
              if (remaining > 0)
                TextSpan(
                  text: ' • ${strings.remainingCredits}: $remaining',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionProgress(AppStrings strings) {
    if (_sections == null || _sections!.isEmpty) {
      return Center(
        child: Text(
          strings.noSections,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.sections,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...(_sections ?? []).map((section) => _buildSectionCard(section, strings)),
      ],
    );
  }

  Widget _buildSectionCard(Section section, AppStrings strings) {
    final completedRequiredCredits = section.allCourses
        .where((c) => c.status == CourseStatus.completed && c.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);
    final completedOptionalCredits = section.allCourses
        .where((c) => c.status == CourseStatus.completed && c.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);
    final inProgressRequiredCredits = section.allCourses
        .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.required)
        .fold(0, (sum, course) => sum + course.credits);
    final inProgressOptionalCredits = section.allCourses
        .where((c) => c.status == CourseStatus.inProgress && c.type == CourseType.optional)
        .fold(0, (sum, course) => sum + course.credits);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            if (section.requiredCredits > 0)
              _buildCreditRow(
                strings.required,
                completedRequiredCredits,
                inProgressRequiredCredits,
                section.requiredCredits,
                AppColors.primary,
                strings,
              ),
            if (section.optionalCredits > 0) ...[
              const SizedBox(height: 8),
              _buildCreditRow(
                strings.optional,
                completedOptionalCredits,
                inProgressOptionalCredits,
                section.optionalCredits,
                AppColors.secondary,
                strings,
              ),
            ],
          ],
        ),
      ),
    );
  }
} 