import 'dart:io';

class AdMobHelper {
  static String get bannerUnitId {
    const String testAdUnitId = "ca-app-pub-3940256099942544/6300978111";
    const String prodAdUnitId = "ca-app-pub-5976582399377469/7547191918";

    if (Platform.isAndroid) {
      return testAdUnitId;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError("Platform does not support");
    }
  }

  static String get interstitialUnitId {
    const String testAdUnitId = "ca-app-pub-3940256099942544/1033173712";
    const String prodAdUnitId = "ca-app-pub-5976582399377469/6214902713";

    if (Platform.isAndroid) {
      return testAdUnitId;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError("Platform does not support");
    }
  }
}
