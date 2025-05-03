import 'dart:io';

import 'package:flutter/material.dart';
import '../widgets/program_overview.dart';
import '../widgets/missing_credits_warning.dart';
import '../services/program_service.dart';
import '../services/course_service.dart';
import 'course_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Test Ad Unit IDs
  static final String _testRewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-5958322053700133/6273727285';

  final ProgramService _programService = ProgramService();
  final CourseService _courseService = CourseService();

  Map<String, dynamic>? progress;
  Map<String, dynamic>? missingCredits;
  double gpa = 0.0;
  bool isLoading = false;
  String errorMessage = '';
  Map<String, dynamic>? englishCert;

  // Thêm thuộc tính để quản lý quảng cáo
  RewardedAd? _rewardedAd;
  bool _isLoadingAd = false;

  Future<void> _refreshState() async {
    if (!mounted) return;

    await _loadData();
  }

  void _navigateToScreen(String route) async {
    print('Attempting to navigate to: $route');
    Widget screen;
    switch (route) {
      case '/courses':
        screen = const CourseScreen();
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

    // Refresh toàn bộ trạng thái khi quay lại
    if (mounted) {
      await _refreshState();
    }
  }

  @override
  void initState() {
    super.initState();
    // Khởi tạo Mobile Ads SDK
    MobileAds.instance.initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshState();
    });
  }

  Future<void> _loadData() async {
    if (!mounted || isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Load settings first to get useSampleData state
      final settings = await _programService.getSettings();

      // Lấy danh sách sections để tính toán tổng số tín chỉ
      final sections = await _programService.getSections();
      
      // Tính toán tổng số tín chỉ từ tất cả các sections
      final totalRequiredCredits = sections
          .fold(0, (sum, section) => sum + section.requiredCredits);
      final totalOptionalCredits = sections
          .fold(0, (sum, section) => sum + section.optionalCredits);
      final totalCredits = totalRequiredCredits + totalOptionalCredits;



      final programProgress = await _programService.getProgress(totalCredits);
      final missingRequiredCredits = await _programService.getMissingRequiredCredits();
      final calculatedGpa = await _courseService.calculateOverallGPA();

      if (mounted) {
        setState(() {
          progress = programProgress;

          englishCert = {
            'type': settings.englishCertType.displayName,
            'score': settings.englishScore,
            'required': settings.englishCertType.minScore,
          };

          missingCredits = {
            'hasMissingCredits': missingRequiredCredits['hasMissingCredits'] as bool? ?? false,
            'sections': (missingRequiredCredits['sections'] as List<dynamic>?)?.map((section) {
              return Map<String, dynamic>.from(section as Map<String, dynamic>);
            }).toList() ?? [],
          };
          
          gpa = calculatedGpa;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  // Thêm phương thức để load quảng cáo
  void _loadRewardedAd() {
    if (_isLoadingAd) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đang tải dữ liệu, vui lòng đợi...'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() => _isLoadingAd = true);

    RewardedAd.load(
      adUnitId: _testRewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              // Tải quảng cáo mới cho lần sau
              _loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Không thể hiển thị quảng cáo. Vui lòng thử lại sau.'),
                ),
              );
            },
          );

          setState(() => _isLoadingAd = false);
          _showSupportDialog();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Lỗi tải quảng cáo: ${error.message}');
          setState(() => _isLoadingAd = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể tải quảng cáo. Vui lòng thử lại sau.'),
            ),
          );
        },
      ),
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 8),
            Text('Ủng hộ tác giả'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cảm ơn bạn đã quan tâm đến việc ủng hộ tác giả! ❤️',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Bạn có thể ủng hộ bằng cách xem một quảng cáo ngắn. '
              'Điều này sẽ giúp tác giả có thêm động lực phát triển ứng dụng tốt hơn.',
            ),
            SizedBox(height: 16),
            if (_isLoadingAd)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Đang tải quảng cáo...'),
                  ],
                ),
              )
            else if (_rewardedAd != null)
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.play_circle_outline),
                  label: Text('Xem quảng cáo để ủng hộ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _rewardedAd?.show(
                      onUserEarnedReward: (ad, reward) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '❤️ Cảm ơn bạn đã ủng hộ! Chúc bạn học tập tốt!',
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: Colors.green,
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
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý tín chỉ'),
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
              child: const Text('Thử lại'),
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
          if (missingCredits != null && missingCredits!['hasMissingCredits'])
            MissingCreditsWarning(
              missingCredits: missingCredits!,
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
                'Môn học',
                Icons.school,
                '/courses',
                Colors.blue,
              ),
              _buildNavigationCard(
                context,
                'Tiến độ',
                Icons.timeline,
                '/progress',
                Colors.green,
              ),
              _buildNavigationCard(
                context,
                'Cài đặt',
                Icons.settings,
                '/settings',
                Colors.orange,
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
                  'Mọi đóng góp xin gửi về: trunhquang9@gmail.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Xin chân thành cảm ơn bạn đã sử dụng ứng dụng!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
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
                Colors.red.shade100,
                Colors.pink.shade50,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 8),
              Text(
                'Ủng hộ tác giả',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
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
