import 'package:flutter/material.dart';

import '../l10n/language_manager.dart';
import '../models/course.dart';
import '../theme/app_colors.dart';

class CourseStatusDropdown extends StatelessWidget {
  final Course course;
  final LanguageManager languageManager;
  final void Function(CourseStatus) onChangeCourseStatus;
  final bool isAcceptedChangeStatus;

  const CourseStatusDropdown({
    super.key,
    required this.course,
    required this.languageManager,
    required this.onChangeCourseStatus,
    required this.isAcceptedChangeStatus,
  });

  Widget _buildCourseStatusChip(CourseStatus status) {
    Color color;
    String text;

    switch (status) {
      case CourseStatus.notStarted:
        color = AppColors.textSecondary;
        text = languageManager.currentStrings.notStarted;
        break;
      case CourseStatus.inProgress:
        color = AppColors.primary;
        text = languageManager.currentStrings.inProgress;
        break;
      case CourseStatus.completed:
        color = AppColors.success;
        text = languageManager.currentStrings.completed;
        break;
      case CourseStatus.failed:
        color = AppColors.error;
        text = languageManager.currentStrings.failed;
        break;
      case CourseStatus.registering:
        color = AppColors.info;
        text = languageManager.currentStrings.registering;
        break;
      case CourseStatus.needToRegister:
        color = AppColors.warning;
        text = languageManager.currentStrings.needToRegister;
        break;
    }

    return _statusChip(
      color,
      text,
    );
  }

  _statusChip(
    Color color,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        // borderRadius: BorderRadius.circular(12),
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

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _buildCourseStatusChip(course.status),
      onPressed: () {
        if ([
          CourseStatus.inProgress,
          CourseStatus.completed,
          CourseStatus.failed,
          CourseStatus.registering
        ].contains(course.status) || isAcceptedChangeStatus) {
          var list = [
            CourseStatus.inProgress,
            CourseStatus.completed,
            CourseStatus.failed
          ];
          list.remove(course.status);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cập nhật trạng thái'),
              content: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ...CourseStatus.values.
                        ...list.asMap().entries.map((entry) {
                          return InkWell(
                              onTap: () {
                                onChangeCourseStatus(entry.value);
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: _buildCourseStatusChip(entry.value),
                              ));
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
      color: Colors.white,
    );
  }
}
