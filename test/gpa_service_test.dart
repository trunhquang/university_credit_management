import 'package:flutter_test/flutter_test.dart';

import 'package:grad_tracker/core/models/course.dart';
import 'package:grad_tracker/core/models/gpa_model.dart';
import 'package:grad_tracker/features/gpa/domain/gpa_service.dart';

void main() {
  group('GPAService & GPAModel', () {
    test('calculate current GPA and predict target requirements', () {
      final courses = <Course>[
        Course(name: 'A', credits: 3, id: 'A', status: CourseStatus.completed, score: 8.0), // 3.3*3
        Course(name: 'B', credits: 2, id: 'B', status: CourseStatus.completed, score: 7.0), // 2.7*2
        Course(name: 'C', credits: 3, id: 'C', status: CourseStatus.notStarted),
        Course(name: 'D', credits: 2, id: 'D', status: CourseStatus.notStarted),
      ];

      final gpa = GPAModel();
      gpa.calculateGPA(courses);

      // Current GPA = ((3.3*3) + (2.7*2)) / (3+2) = (9.9 + 5.4) / 5 = 3.06
      expect(gpa.currentGPA, closeTo(3.06, 0.01));
      expect(gpa.completedCredits, 5);

      final remaining = GPAService.getRemainingCourses(courses);
      expect(remaining.length, 2);

      final predictions = GPAService.predictForTarget(gpa, 3.2, remaining);
      expect(predictions.keys, containsAll(['C', 'D']));
    });
  });
}


