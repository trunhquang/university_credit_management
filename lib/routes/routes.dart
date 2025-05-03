import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/course_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/settings_screen.dart';

class Routes {
  static const String home = '/';
  static const String courses = '/courses';
  static const String progress = '/progress';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/courses':
        return MaterialPageRoute(builder: (_) => const CourseScreen());
      case '/progress':
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 