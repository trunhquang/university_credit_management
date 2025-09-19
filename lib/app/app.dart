import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/state/curriculum_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/navigation/app_router.dart';

class GradTrackerApp extends StatelessWidget {
  const GradTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurriculumProvider()),
      ],
      child: MaterialApp.router(
        title: 'Grad Tracker',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: AppRouter.router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('vi')],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


