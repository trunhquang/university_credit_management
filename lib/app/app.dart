import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../core/state/curriculum_state.dart';
import '../core/theme/app_theme.dart';
import '../features/dashboard/dashboard_screen.dart';

class GradTrackerApp extends StatelessWidget {
  const GradTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurriculumState()..load()),
      ],
      child: MaterialApp(
        title: 'Graduation Tracker',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('vi')],
        home: const DashboardScreen(),
      ),
    );
  }
}


