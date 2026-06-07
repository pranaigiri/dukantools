import 'dart:io';
import 'package:flutter/foundation.dart';

class AdMobHelper {
  static bool get isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  // Flag to force test ads even in release build (useful for local release testing)
  static const bool _forceTestAds = false;

  static bool get _useTestAds => kDebugMode || _forceTestAds;

  static String get bannerUnitId {
    if (_useTestAds) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/6300978111";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/2934735716";
      }
      throw UnsupportedError("Platform does not support ads");
    } else {
      // Production Banner Ad Unit IDs
      if (Platform.isAndroid) {
        return "ca-app-pub-5976582399377469/7547191918";
      } else if (Platform.isIOS) {
        // Fallback or prod iOS banner ID if configured
        return "ca-app-pub-3940256099942544/2934735716";
      }
      throw UnsupportedError("Platform does not support ads");
    }
  }

  static String get interstitialUnitId {
    if (_useTestAds) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/1033173712";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/4411468910";
      }
      throw UnsupportedError("Platform does not support ads");
    } else {
      // Production Interstitial Ad Unit IDs
      if (Platform.isAndroid) {
        return "ca-app-pub-5976582399377469/6214902713";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/4411468910";
      }
      throw UnsupportedError("Platform does not support ads");
    }
  }

  static String get rewardedUnitId {
    if (_useTestAds) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/5224354917";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/1712485313";
      }
      throw UnsupportedError("Platform does not support ads");
    } else {
      // Production Rewarded Ad Unit IDs (placeholder or real if available)
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/5224354917";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/1712485313";
      }
      throw UnsupportedError("Platform does not support ads");
    }
  }

  static String get appOpenUnitId {
    if (_useTestAds) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/9257395921";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/5575463023";
      }
      throw UnsupportedError("Platform does not support ads");
    } else {
      // Production App Open Ad Unit IDs
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/9257395921";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/5575463023";
      }
      throw UnsupportedError("Platform does not support ads");
    }
  }
}
