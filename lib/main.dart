import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'l10n/language_manager.dart';
import 'screens/home_screen.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize language manager
  final languageManager = LanguageManager();
  await languageManager.initialize();
    try {
    await FirebaseService.initialize();
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
    // You might want to show an error dialog or handle the error appropriately
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
