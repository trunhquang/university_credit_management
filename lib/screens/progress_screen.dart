import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/progress_model.dart';
import '../services/program_service.dart';
import '../services/course_service.dart';
import '../models/section.dart';
import '../l10n/language_manager.dart';
import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../widgets/progress/overall_progress.dart';
import '../widgets/progress/gpa_card.dart';
import '../widgets/progress/credits_summary.dart';
import '../widgets/progress/course_status_summary.dart';
import '../widgets/progress/section_progress.dart';

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
  ProgressModel? _progress;
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

      // Lấy thông tin tiến độ từ ProgramService
      _progress = await _programService.getProgress(totalCredits);

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
              OverallProgress(progress: _progress!,),
              const SizedBox(height: 24),
              GPACard(gpa: _overallGPA),
              const SizedBox(height: 24),
              CreditsSummary(progress: _progress!),
              const SizedBox(height: 24),
              CourseStatusSummary(progress: _progress!),
              const SizedBox(height: 24),
              if (_sections != null) SectionProgress(sections: _sections!),
            ],
          ),
        ),
      ),
    );
  }
} 