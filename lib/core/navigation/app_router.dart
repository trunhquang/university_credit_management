import 'package:flutter/foundation.dart';
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

  /// Navigation stack tracking
  static final List<String> _navigationStack = [];
  
  /// Get current navigation stack
  static List<String> get navigationStack => List.unmodifiable(_navigationStack);
  
  /// Get current page name
  static String get currentPage => _navigationStack.isNotEmpty ? _navigationStack.last : 'unknown';
  
  /// Log navigation action
  static void _logNavigation(String action, String from, String to, {Map<String, String>? params}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final paramsStr = params != null ? ' | Params: $params' : '';
      debugPrint('🚀 [ROUTER] $timestamp | $action | $from → $to$paramsStr');
      debugPrint('📚 [STACK] Current stack: $_navigationStack');
    }
  }
  
  /// Update navigation stack
  static void _updateStack(String pageName, String action) {
    switch (action) {
      case 'push':
        _navigationStack.add(pageName);
        break;
      case 'pop':
        if (_navigationStack.isNotEmpty) {
          _navigationStack.removeLast();
        }
        break;
      case 'replace':
        // For main tabs, replace the current page or add if stack is empty
        if (_navigationStack.isNotEmpty) {
          _navigationStack.removeLast();
        }
        _navigationStack.add(pageName);
        break;
      case 'clear':
        _navigationStack.clear();
        _navigationStack.add(pageName);
        break;
    }
  }

  static final GoRouter router = GoRouter(
    initialLocation: dashboard,
    routes: [
      // Dashboard
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) {
          _updateStack('dashboard', 'replace');
          _logNavigation('NAVIGATE', currentPage, 'dashboard');
          return const DashboardPage();
        },
      ),

      // Courses
      GoRoute(
        path: courses,
        name: 'courses',
        builder: (context, state) {
          _updateStack('courses', 'replace');
          _logNavigation('NAVIGATE', currentPage, 'courses');
          return const CoursesListPage();
        },
      ),

      // Course Detail
      GoRoute(
        path: courseDetail,
        name: 'courseDetail',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          _updateStack('courseDetail', 'push');
          _logNavigation('NAVIGATE', currentPage, 'courseDetail', params: {'courseId': courseId});
          return CourseDetailPage(courseId: courseId);
        },
      ),

      // Progress
      GoRoute(
        path: progress,
        name: 'progress',
        builder: (context, state) {
          _updateStack('progress', 'replace');
          _logNavigation('NAVIGATE', currentPage, 'progress');
          return const ProgressPage();
        },
      ),

      // GPA
      GoRoute(
        path: gpa,
        name: 'gpa',
        builder: (context, state) {
          _updateStack('gpa', 'replace');
          _logNavigation('NAVIGATE', currentPage, 'gpa');
          return const GPAPage();
        },
      ),

      // Planning
      GoRoute(
        path: planning,
        name: 'planning',
        builder: (context, state) {
          _updateStack('planning', 'replace');
          _logNavigation('NAVIGATE', currentPage, 'planning');
          return const PlanningPage();
        },
      ),

      // Graduation
      GoRoute(
        path: graduation,
        name: 'graduation',
        builder: (context, state) {
          _updateStack('graduation', 'replace');
          _logNavigation('NAVIGATE', currentPage, 'graduation');
          return const GraduationPage();
        },
      ),

      // Settings
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) {
          _updateStack('settings', 'replace');
          _logNavigation('NAVIGATE', currentPage, 'settings');
          return const SettingsPage();
        },
      ),
    ],
    errorBuilder: (context, state) {
      _logNavigation('ERROR', currentPage, 'error', params: {'uri': state.uri.toString()});
      return Scaffold(
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
      );
    },
  );
}

/// Navigation helper methods
class AppNavigation {
  static void goToDashboard(BuildContext context) {
    AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'dashboard');
    context.go(AppRouter.dashboard);
  }

  static void goToCourses(BuildContext context) {
    AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'courses');
    context.go(AppRouter.courses);
  }

  static void goToCourseDetail(BuildContext context, String courseId) {
    AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'courseDetail', params: {'courseId': courseId});
    context.go('/courses/$courseId');
  }

  static void goToProgress(BuildContext context) {
    AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'progress');
    context.go(AppRouter.progress);
  }

  static void goToGPA(BuildContext context) {
    AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'gpa');
    context.go(AppRouter.gpa);
  }

  static void goToPlanning(BuildContext context) {
    AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'planning');
    context.go(AppRouter.planning);
  }

  static void goToGraduation(BuildContext context) {
    AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'graduation');
    context.go(AppRouter.graduation);
  }

  static void goToSettings(BuildContext context) {
    AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'settings');
    context.go(AppRouter.settings);
  }

  static void goBack(BuildContext context) {
    if (context.canPop()) {
      AppRouter._logNavigation('POP', AppRouter.currentPage, 'previous');
      AppRouter._updateStack('', 'pop');
      context.pop();
    } else {
      AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'dashboard', params: {'reason': 'fallback'});
      AppRouter._updateStack('dashboard', 'clear');
      context.go(AppRouter.dashboard);
    }
  }

  /// Log UI render events
  static void logUIRender(String widgetName, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final dataStr = data != null ? ' | Data: $data' : '';
      debugPrint('🎨 [UI_RENDER] $timestamp | $widgetName$dataStr');
      debugPrint('📚 [STACK] Current page: ${AppRouter.currentPage}');
    }
  }

  /// Log state changes
  static void logStateChange(String stateName, dynamic oldValue, dynamic newValue) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      debugPrint('🔄 [STATE] $timestamp | $stateName: $oldValue → $newValue');
      debugPrint('📚 [STACK] Current page: ${AppRouter.currentPage}');
    }
  }

  /// Log user actions
  static void logUserAction(String action, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final dataStr = data != null ? ' | Data: $data' : '';
      debugPrint('👆 [USER_ACTION] $timestamp | $action$dataStr');
      debugPrint('📚 [STACK] Current page: ${AppRouter.currentPage}');
    }
  }
}
