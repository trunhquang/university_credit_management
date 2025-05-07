import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_update_service.dart';
import '../widgets/program_overview.dart';
import '../services/program_service.dart';
import '../services/course_service.dart';
import '../services/ad_manager.dart';
import '../l10n/language_manager.dart';
import '../theme/app_colors.dart';
import 'course_session_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProgramService _programService = ProgramService();
  final CourseService _courseService = CourseService();
  final AdManager _adManager = AdManager();
  late final LanguageManager _languageManager;

  Map<String, dynamic>? progress;
  double gpa = 0.0;
  bool isLoading = false;
  String errorMessage = '';
  Map<String, dynamic>? englishCert;

  @override
  void initState() {
    super.initState();
    AppUpdateService.checkForUpdates(context);
    _languageManager = Provider.of<LanguageManager>(context, listen: false);
    _languageManager.addListener(_onLanguageChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshState();
    });
  }

  @override
  void dispose() {
    _languageManager.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  Future<void> _refreshState() async {
    if (!mounted) return;
    await _loadData();
  }

  void _navigateToScreen(String route) async {
    print('Attempting to navigate to: $route');
    Widget screen;
    switch (route) {
      case '/courses':
        screen = const CourseSessionScreen();
        break;
      case '/progress':
        screen = const ProgressScreen();
        break;
      case '/settings':
        screen = const SettingsScreen();
        break;
      default:
        return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    if (mounted) {
      await _refreshState();
    }
  }

  Future<void> _loadData() async {
    if (!mounted || isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final settings = await _programService.getSettings();
    final sections = await _programService.getSections();
    
    final totalRequiredCredits = sections
        .fold(0, (sum, section) => sum + section.requiredCredits);
    final totalOptionalCredits = sections
        .fold(0, (sum, section) => sum + section.optionalCredits);
    final totalCredits = totalRequiredCredits + totalOptionalCredits;

    final programProgress = await _programService.getProgress(totalCredits);
    final calculatedGpa = await _courseService.calculateOverallGPA();

    if (mounted) {
      setState(() {
        progress = programProgress;
        englishCert = {
          'type': settings.englishCertType.getDisplayName(_languageManager.currentStrings),
          'score': settings.englishScore,
          'required': settings.englishCertType.minScore,
        };
        gpa = calculatedGpa;
        isLoading = false;
      });
    }
  }

  void _loadRewardedAd() {
    _adManager.loadRewardedAd(
      context: context,
      onAdLoaded: _showSupportDialog,
      onAdFailed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_languageManager.currentStrings.functionDeveloping),
          ),
          // SnackBar(
          //   content: Text(_languageManager.currentStrings.adLoadFailed),
          // ),
        );
      },
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.favorite, color: AppColors.support),
            SizedBox(width: 8),
            Text(_languageManager.currentStrings.supportAuthor),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _languageManager.currentStrings.thankYouForSupport,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Text(_languageManager.currentStrings.supportDescription),
            SizedBox(height: 16),
            if (_adManager.isLoadingAd)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text(_languageManager.currentStrings.loadingAd),
                  ],
                ),
              )
            else if (_adManager.isAdReady)
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.play_circle_outline),
                  label: Text(_languageManager.currentStrings.watchAdToSupport),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.progress,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _adManager.showRewardedAd(
                      context: context,
                      onRewardEarned: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _languageManager.currentStrings.thankYouMessage,
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: AppColors.progress,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_languageManager.currentStrings.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_languageManager.currentStrings.appName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: Text(_languageManager.currentStrings.retry),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          if (progress != null)
            ProgramOverview(
              progress: progress!,
              gpa: gpa,
              englishCert: englishCert!,
            ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildNavigationCard(
                context,
                _languageManager.currentStrings.courses,
                Icons.school,
                '/courses',
                AppColors.courses,
              ),
              _buildNavigationCard(
                context,
                _languageManager.currentStrings.progress,
                Icons.timeline,
                '/progress',
                AppColors.progress,
              ),
              _buildNavigationCard(
                context,
                _languageManager.currentStrings.settings,
                Icons.settings,
                '/settings',
                AppColors.settings,
              ),
              _buildSupportCard(),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Text(
                  _languageManager.currentStrings.contactEmail,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  _languageManager.currentStrings.thankYouForUsing,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context,
    String title,
    IconData icon,
    String route,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => _navigateToScreen(route),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildSupportCard() {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: _loadRewardedAd,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.supportGradientStart,
                AppColors.supportGradientEnd,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 48,
                color: AppColors.support,
              ),
              const SizedBox(height: 8),
              Text(
                _languageManager.currentStrings.supportAuthor,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.support,
                ),
              ),
              Text(
                '❤️',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
