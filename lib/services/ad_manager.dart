import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  // Test Ad Unit IDs
  static final String _testRewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-5958322053700133/4534228068'
      : 'ca-app-pub-5958322053700133/6273727285';

  RewardedAd? _rewardedAd;
  bool _isLoadingAd = false;

  void loadRewardedAd({
    required BuildContext context,
    required VoidCallback onAdLoaded,
    required VoidCallback onAdFailed,
  }) {
    if (_isLoadingAd) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đang tải dữ liệu, vui lòng đợi...'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    _isLoadingAd = true;

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
              loadRewardedAd(
                context: context,
                onAdLoaded: onAdLoaded,
                onAdFailed: onAdFailed,
              );
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

          _isLoadingAd = false;
          onAdLoaded();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Lỗi tải quảng cáo: ${error.message}');
          _isLoadingAd = false;
          onAdFailed();
        },
      ),
    );
  }

  void showRewardedAd({
    required BuildContext context,
    required VoidCallback onRewardEarned,
  }) {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quảng cáo chưa sẵn sàng. Vui lòng thử lại sau.'),
        ),
      );
      return;
    }

    _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) {
        onRewardEarned();
      },
    );
  }

  bool get isLoadingAd => _isLoadingAd;
  bool get isAdReady => _rewardedAd != null;
} 