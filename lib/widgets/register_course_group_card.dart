import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/course_group.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';
import 'registering_course_card.dart';

class RegisterCourseGroupCard extends StatelessWidget {
  final CourseGroup group;
  final List<Course> courses;
  final bool isExpanded;
  final Function(String) toggleGroupExpansion;
  final Function(Course) onToggleSelection;
  final Function(Course) onToggleOpenStatus;
  final List<Course> selectedCourses;
  final LanguageManager languageManager;

  const RegisterCourseGroupCard({
    super.key,
    required this.group,
    required this.courses,
    required this.isExpanded,
    required this.toggleGroupExpansion,
    required this.onToggleSelection,
    required this.onToggleOpenStatus,
    required this.selectedCourses,
    required this.languageManager,
  });

  bool get _isGroupCreditMet {
    // Tính tổng số tín chỉ bắt buộc đã hoàn thành, đang học hoặc đang đăng ký
    final completedRequiredCredits = group.courses.where((c) => 
      c.type == CourseType.required && [
        CourseStatus.completed,
        CourseStatus.inProgress,
        CourseStatus.registering,
      ].contains(c.status)
    ).fold(0, (sum, c) => sum + c.credits);

    // Tính tổng số tín chỉ tự chọn đã hoàn thành, đang học hoặc đang đăng ký
    final completedOptionalCredits = group.courses.where((c) => 
      c.type == CourseType.optional && [
        CourseStatus.completed,
        CourseStatus.inProgress,
        CourseStatus.registering,
      ].contains(c.status)
    ).fold(0, (sum, c) => sum + c.credits);

    // Kiểm tra xem đã đủ cả số tín chỉ bắt buộc và tự chọn chưa
    return completedRequiredCredits >= group.requiredCredits && 
           completedOptionalCredits >= group.optionalCredits;
  }

  int get _completedRequiredCredits {
    return group.courses.where((c) => 
      c.type == CourseType.required && [
        CourseStatus.completed,
        CourseStatus.inProgress,
        CourseStatus.registering,
      ].contains(c.status)
    ).fold(0, (sum, c) => sum + c.credits);
  }

  int get _completedOptionalCredits {
    return group.courses.where((c) => 
      c.type == CourseType.optional && [
        CourseStatus.completed,
        CourseStatus.inProgress,
        CourseStatus.registering,
      ].contains(c.status)
    ).fold(0, (sum, c) => sum + c.credits);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              toggleGroupExpansion(group.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.group_work,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          group.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: _isGroupCreditMet ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      if (_isGroupCreditMet)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColors.success,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Đã đủ tín chỉ',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        Text(
                          '${courses.length} ${languageManager.currentStrings.courses}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tín chỉ bắt buộc:',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: group.requiredCredits > 0 
                                ? _completedRequiredCredits / group.requiredCredits 
                                : 1.0,
                              backgroundColor: AppColors.outlineVariant,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _completedRequiredCredits >= group.requiredCredits 
                                  ? AppColors.success 
                                  : AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$_completedRequiredCredits/${group.requiredCredits}',
                              style: TextStyle(
                                fontSize: 12,
                                color: _completedRequiredCredits >= group.requiredCredits 
                                  ? AppColors.success 
                                  : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tín chỉ tự chọn:',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: group.optionalCredits > 0 
                                ? _completedOptionalCredits / group.optionalCredits 
                                : 1.0,
                              backgroundColor: AppColors.background,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _completedOptionalCredits >= group.optionalCredits 
                                  ? AppColors.success 
                                  : AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$_completedOptionalCredits/${group.optionalCredits}',
                              style: TextStyle(
                                fontSize: 12,
                                color: _completedOptionalCredits >= group.optionalCredits 
                                  ? AppColors.success 
                                  : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            ...courses.map((course) => RegisteringCourseCard(
              course: course,
              group: group,
              isSelected: selectedCourses.contains(course),
              onToggleSelection: _isGroupCreditMet ? null : onToggleSelection,
              onToggleOpenStatus: onToggleOpenStatus,
              languageManager: languageManager,
            )),
          ],
        ],
      ),
    );
  }
} 