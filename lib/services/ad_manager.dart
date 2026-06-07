import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dukan_tools/common/admob_helper.dart';

class AdManager with WidgetsBindingObserver {
  // Singleton pattern
  static final AdManager instance = AdManager._internal();
  AdManager._internal();

  // Lifecycle & Session variables
  bool _initialized = false;
  DateTime? _backgroundTime;
  bool _isAppOpenAdShowing = false;

  // Interstitial Ad state
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  int _interstitialRetryAttempts = 0;
  DateTime? _lastInterstitialShowTime;
  int _meaningfulActionsCount = 0;

  // Rewarded Ad state
  RewardedAd? _rewardedAd;
  bool _isRewardedLoading = false;
  int _rewardedRetryAttempts = 0;

  // App Open Ad state
  AppOpenAd? _appOpenAd;
  bool _isAppOpenLoading = false;
  DateTime? _appOpenAdLoadTime;

  // Constants
  static const int _maxRetryAttempts = 5;
  static const Duration _minTimeBetweenInterstitials = Duration(minutes: 2);
  static const int _minActionsBetweenInterstitials = 3;
  static const Duration _appOpenExpiry = Duration(hours: 4);

  /// Initialize the AdManager and preload initial ads
  Future<void> initialize() async {
    if (!AdMobHelper.isSupported) {
      _log('Ads are not supported on this platform. Disabling AdManager.');
      return;
    }
    if (_initialized) return;
    _initialized = true;

    _log('Initializing Google Mobile Ads SDK...');
    try {
      await MobileAds.instance.initialize();

      // Register widgets binding observer for App Open ads
      WidgetsBinding.instance.addObserver(this);

      // Preload Interstitial and Rewarded ads
      preloadInterstitialAd();
      preloadRewardedAd();
      _preloadAppOpenAd();
    } catch (e) {
      _log('Failed to initialize ads: $e');
    }
  }

  /// Increments the count of meaningful actions (e.g. calculations, navigation clicks)
  void incrementMeaningfulActions() {
    _meaningfulActionsCount++;
    _log('Meaningful action tracked. Current count: $_meaningfulActionsCount');
  }

  // --- ANALYTICS / LOGGING HELPER ---
  void _log(String message) {
    debugPrint('[AdManager] $message');
  }

  void _logAdEvent(String eventName, String adType, {String? extra}) {
    _log('Analytics Event -> Event: $eventName, Type: $adType${extra != null ? ", Detail: $extra" : ""}');
  }

  // --- INTERSTITIAL ADS ---

  void preloadInterstitialAd() {
    if (!AdMobHelper.isSupported) return;
    if (_interstitialAd != null || _isInterstitialLoading) return;
    _isInterstitialLoading = true;
    _log('Preloading Interstitial Ad...');

    InterstitialAd.load(
      adUnitId: AdMobHelper.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _logAdEvent('ad_loaded', 'interstitial');
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          _interstitialRetryAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          _logAdEvent('ad_load_failed', 'interstitial', extra: error.message);
          _interstitialAd = null;
          _isInterstitialLoading = false;
          _handleInterstitialLoadFailure();
        },
      ),
    );
  }

  void _handleInterstitialLoadFailure() {
    if (_interstitialRetryAttempts >= _maxRetryAttempts) {
      _log('Max retry attempts reached for Interstitial. Stopping retries.');
      return;
    }
    _interstitialRetryAttempts++;
    final delay = Duration(seconds: _interstitialRetryAttempts * 5);
    _log('Retrying Interstitial load in ${delay.inSeconds}s (Attempt $_interstitialRetryAttempts/$_maxRetryAttempts)');
    Timer(delay, () => preloadInterstitialAd());
  }

  /// Shows the interstitial ad if frequency-capping conditions are met.
  /// Always runs [onDismissed] to ensure smooth user flow.
  void showInterstitialAd({required VoidCallback onDismissed}) {
    final now = DateTime.now();
    final timePassed = _lastInterstitialShowTime == null ||
        now.difference(_lastInterstitialShowTime!) >= _minTimeBetweenInterstitials;
    final actionsPassed = _meaningfulActionsCount >= _minActionsBetweenInterstitials;

    _log('Checking Interstitial Frequency Capping. TimePassed: $timePassed, ActionsPassed: $actionsPassed (Count: $_meaningfulActionsCount)');

    if (timePassed && actionsPassed && _interstitialAd != null) {
      _logAdEvent('ad_show_requested', 'interstitial');
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _logAdEvent('ad_impression', 'interstitial');
          _lastInterstitialShowTime = DateTime.now();
          _meaningfulActionsCount = 0;
        },
        onAdDismissedFullScreenContent: (ad) {
          _logAdEvent('ad_dismissed', 'interstitial');
          ad.dispose();
          _interstitialAd = null;
          preloadInterstitialAd();
          onDismissed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _logAdEvent('ad_show_failed', 'interstitial', extra: error.message);
          ad.dispose();
          _interstitialAd = null;
          preloadInterstitialAd();
          onDismissed();
        },
        onAdClicked: (ad) {
          _logAdEvent('ad_clicked', 'interstitial');
        },
      );
      _interstitialAd!.show();
    } else {
      _log('Frequency capping not met or Interstitial not loaded. Continuing flow.');
      onDismissed();
    }
  }

  // --- REWARDED ADS ---

  void preloadRewardedAd() {
    if (!AdMobHelper.isSupported) return;
    if (_rewardedAd != null || _isRewardedLoading) return;
    _isRewardedLoading = true;
    _log('Preloading Rewarded Ad...');

    RewardedAd.load(
      adUnitId: AdMobHelper.rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _logAdEvent('ad_loaded', 'rewarded');
          _rewardedAd = ad;
          _isRewardedLoading = false;
          _rewardedRetryAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          _logAdEvent('ad_load_failed', 'rewarded', extra: error.message);
          _rewardedAd = null;
          _isRewardedLoading = false;
          _handleRewardedLoadFailure();
        },
      ),
    );
  }

  void _handleRewardedLoadFailure() {
    if (_rewardedRetryAttempts >= _maxRetryAttempts) {
      _log('Max retry attempts reached for Rewarded. Stopping retries.');
      return;
    }
    _rewardedRetryAttempts++;
    final delay = Duration(seconds: _rewardedRetryAttempts * 5);
    _log('Retrying Rewarded load in ${delay.inSeconds}s (Attempt $_rewardedRetryAttempts/$_maxRetryAttempts)');
    Timer(delay, () => preloadRewardedAd());
  }

  /// Shows rewarded ad. If ad not ready, informs user and/or continues gracefully.
  void showRewardedAd({
    required VoidCallback onRewardEarned,
    required VoidCallback onDismissed,
  }) {
    if (_rewardedAd != null) {
      _logAdEvent('ad_show_requested', 'rewarded');
      bool rewarded = false;

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _logAdEvent('ad_impression', 'rewarded');
        },
        onAdDismissedFullScreenContent: (ad) {
          _logAdEvent('ad_dismissed', 'rewarded');
          ad.dispose();
          _rewardedAd = null;
          preloadRewardedAd();
          if (rewarded) {
            onRewardEarned();
          }
          onDismissed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _logAdEvent('ad_show_failed', 'rewarded', extra: error.message);
          ad.dispose();
          _rewardedAd = null;
          preloadRewardedAd();
          onDismissed();
        },
        onAdClicked: (ad) {
          _logAdEvent('ad_clicked', 'rewarded');
        },
      );
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        _logAdEvent('ad_reward_earned', 'rewarded', extra: '${reward.amount} ${reward.type}');
        rewarded = true;
      });
    } else {
      _log('Rewarded ad not loaded yet.');
      onDismissed();
    }
  }

  // --- APP OPEN ADS ---

  void _preloadAppOpenAd() {
    if (!AdMobHelper.isSupported) return;
    if (_appOpenAd != null || _isAppOpenLoading) return;
    _isAppOpenLoading = true;
    _log('Preloading App Open Ad...');

    AppOpenAd.load(
      adUnitId: AdMobHelper.appOpenUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _logAdEvent('ad_loaded', 'app_open');
          _appOpenAd = ad;
          _isAppOpenLoading = false;
          _appOpenAdLoadTime = DateTime.now();
        },
        onAdFailedToLoad: (error) {
          _logAdEvent('ad_load_failed', 'app_open', extra: error.message);
          _appOpenAd = null;
          _isAppOpenLoading = false;
        },
      ),
    );
  }

  bool get _isAppOpenAdAvailable {
    if (_appOpenAd == null || _appOpenAdLoadTime == null) return false;
    // App open ads should not be used if loaded more than 4 hours ago
    return DateTime.now().difference(_appOpenAdLoadTime!) < const Duration(hours: 4);
  }

  void _showAppOpenAdIfAvailable() {
    if (_isAppOpenAdShowing) {
      _log('App Open Ad is already showing. Skipping.');
      return;
    }

    if (!_isAppOpenAdAvailable) {
      _log('App Open Ad not available. Loading one.');
      _preloadAppOpenAd();
      return;
    }

    _logAdEvent('ad_show_requested', 'app_open');
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _logAdEvent('ad_impression', 'app_open');
        _isAppOpenAdShowing = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _logAdEvent('ad_dismissed', 'app_open');
        _isAppOpenAdShowing = false;
        ad.dispose();
        _appOpenAd = null;
        _preloadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _logAdEvent('ad_show_failed', 'app_open', extra: error.message);
        _isAppOpenAdShowing = false;
        ad.dispose();
        _appOpenAd = null;
        _preloadAppOpenAd();
      },
      onAdClicked: (ad) {
        _logAdEvent('ad_clicked', 'app_open');
      },
    );
    _appOpenAd!.show();
  }

  // --- LIFECYCLE OBSERVER ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundTime = DateTime.now();
      _log('App paused at $_backgroundTime');
    } else if (state == AppLifecycleState.resumed) {
      _log('App resumed');
      if (_backgroundTime != null) {
        final duration = DateTime.now().difference(_backgroundTime!);
        _log('Duration in background: ${duration.inSeconds}s (threshold: ${_appOpenExpiry.inHours}h)');
        if (duration >= _appOpenExpiry) {
          _showAppOpenAdIfAvailable();
        } else {
          _log('Background duration less than threshold. Not showing App Open ad.');
        }
      }
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _appOpenAd?.dispose();
  }
}
