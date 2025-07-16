import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  // ✅ Ad Unit ID cho Interstitial (đảm bảo là đúng định dạng trung gian)
  static final String _interstitialAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-5958322053700133/6298418640' // ID Interstitial Android
      : 'ca-app-pub-5958322053700133/6273727285'; // iOS

  // ✅ Ad Unit ID cho Rewarded (test ID)
  static final String _rewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isLoadingAd = false;

  // ---------------- INTERSTITIAL ----------------

  void loadInterstitialAd({
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

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoadingAd = false;

          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
            },
          );

          onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          debugPrint('Lỗi tải Interstitial: ${error.message}');
          _isLoadingAd = false;
          onAdFailed();
        },
      ),
    );
  }

  void showInterstitialAd(BuildContext context) {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quảng cáo chưa sẵn sàng')),
      );
    }
  }

  // ---------------- REWARDED ----------------

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
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoadingAd = false;

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              // Tải lại cho lần sau
              loadRewardedAd(
                context: context,
                onAdLoaded: () {},
                onAdFailed: () {},
              );
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Không thể hiển thị quảng cáo có thưởng.'),
                ),
              );
            },
          );

          onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          debugPrint('Lỗi tải Rewarded: ${error.message}');
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
          content: Text('Quảng cáo có thưởng chưa sẵn sàng.'),
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

  // ---------------- GETTERS ----------------

  bool get isLoadingAd => _isLoadingAd;
  bool get isRewardedAdReady => _rewardedAd != null;
  bool get isInterstitialAdReady => _interstitialAd != null;
}
