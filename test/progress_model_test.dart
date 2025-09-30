import 'package:flutter_test/flutter_test.dart';

import 'package:grad_tracker/core/models/course.dart';
import 'package:grad_tracker/core/models/course_group.dart';
import 'package:grad_tracker/core/models/section.dart';
import 'package:grad_tracker/core/models/progress_model.dart';

void main() {
  group('ProgressModel', () {
    test('updates credits and statistics correctly', () {
      final section = Section(
        id: 'S1',
        name: 'Demo',
        description: 'desc',
        requiredCredits: 6,
        optionalCredits: 0,
        courseGroups: [
          CourseGroup(
            id: 'G1',
            name: 'G1',
            description: 'g1',
            requiredCredits: 6,
            optionalCredits: 0,
            courses: [
              Course(name: 'A', credits: 3, id: 'A', status: CourseStatus.completed),
              Course(name: 'B', credits: 3, id: 'B', status: CourseStatus.inProgress),
            ],
          ),
        ],
      );

      final model = ProgressModel();
      model.updateProgress([section]);

      expect(model.completedCredits, 3);
      expect(model.inProgressCredits, 3);
      expect(model.notStartedCredits, 0);

      final stats = model.getCourseStatistics();
      expect(stats['total'], 2);
      expect(stats['completed'], 1);
      expect(stats['inProgress'], 1);
      expect(stats['notStarted'], 0);

      final sectionProgress = model.getSectionProgress();
      expect(sectionProgress['S1']!.completedCredits, 3);
      expect(sectionProgress['S1']!.totalCredits, 6);
      expect(sectionProgress['S1']!.progressPercentage, closeTo(50.0, 0.01));
    });
  });
}


