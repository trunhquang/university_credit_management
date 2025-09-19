import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/courses/presentation/pages/courses_list_page.dart';
import '../../features/courses/presentation/pages/course_detail_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/gpa/presentation/pages/gpa_page.dart';
import '../../features/planning/presentation/pages/planning_page.dart';
import '../../features/graduation/presentation/pages/graduation_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

/// App router configuration
class AppRouter {
  static const String dashboard = '/';
  static const String courses = '/courses';
  static const String courseDetail = '/courses/:courseId';
  static const String progress = '/progress';
  static const String gpa = '/gpa';
  static const String planning = '/planning';
  static const String graduation = '/graduation';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: dashboard,
    routes: [
      // Dashboard
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),

      // Courses
      GoRoute(
        path: courses,
        name: 'courses',
        builder: (context, state) => const CoursesListPage(),
      ),

      // Course Detail
      GoRoute(
        path: courseDetail,
        name: 'courseDetail',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          return CourseDetailPage(courseId: courseId);
        },
      ),

      // Progress
      GoRoute(
        path: progress,
        name: 'progress',
        builder: (context, state) => const ProgressPage(),
      ),

      // GPA
      GoRoute(
        path: gpa,
        name: 'gpa',
        builder: (context, state) => const GPAPage(),
      ),

      // Planning
      GoRoute(
        path: planning,
        name: 'planning',
        builder: (context, state) => const PlanningPage(),
      ),

      // Graduation
      GoRoute(
        path: graduation,
        name: 'graduation',
        builder: (context, state) => const GraduationPage(),
      ),

      // Settings
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Lỗi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Trang không tồn tại',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Đường dẫn: ${state.uri}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(dashboard),
              child: const Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Navigation helper methods
class AppNavigation {
  static void goToDashboard(BuildContext context) {
    context.go(AppRouter.dashboard);
  }

  static void goToCourses(BuildContext context) {
    context.go(AppRouter.courses);
  }

  static void goToCourseDetail(BuildContext context, String courseId) {
    context.go('/courses/$courseId');
  }

  static void goToProgress(BuildContext context) {
    context.go(AppRouter.progress);
  }

  static void goToGPA(BuildContext context) {
    context.go(AppRouter.gpa);
  }

  static void goToPlanning(BuildContext context) {
    context.go(AppRouter.planning);
  }

  static void goToGraduation(BuildContext context) {
    context.go(AppRouter.graduation);
  }

  static void goToSettings(BuildContext context) {
    context.go(AppRouter.settings);
  }

  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRouter.dashboard);
    }
  }
}
