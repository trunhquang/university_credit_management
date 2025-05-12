import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'l10n/language_manager.dart';
import 'theme/app_theme.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize language manager
  final languageManager = LanguageManager();
  await languageManager.initialize();

  // Initialize Firebase only for mobile platforms
  if (!kIsWeb) {
    try {
      await FirebaseService.initialize();
    } catch (e) {
      debugPrint('Failed to initialize Firebase: $e');
    }
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageManager),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(context);
    return MaterialApp(
      title: languageManager.currentStrings.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: kIsWeb ? const ResponsiveLayout(child: HomeScreen()) : const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  const ResponsiveLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return child;
        } else if (constraints.maxWidth < 1200) {
          return Center(
            child: SizedBox(
              width: 600,
              child: child,
            ),
          );
        } else {
          return Center(
            child: SizedBox(
              width: 800,
              child: child,
            ),
          );
        }
      },
    );
  }
}
