import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gram_or_price/common/admob_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _admobBannerAd;
  Timer? _timer;
  DateTime? lastLoadedTimestamp;
  int adExpTime = 10;

  @override
  void initState() {
    super.initState();
    loadBannerAd();
    startTimer();
  }

  Future<void> loadBannerAd() async {
    DateTime? cachedAdTimestamp;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cachedAdTimestamp = DateTime.tryParse(
      prefs.getString("cachedAdTime").toString(),
    );

    int? secDiff;
    if (cachedAdTimestamp != null) {
      secDiff = DateTime.now().difference(cachedAdTimestamp).inSeconds;
    }

    if ((_admobBannerAd == null && secDiff == null) ||
        secDiff == null ||
        secDiff > adExpTime) {
      BannerAd(
          adUnitId: AdMobHelper.bannerUnitId,
          request: const AdRequest(),
          size: AdSize.banner,
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _admobBannerAd = ad as BannerAd;
              });

              //store the loaded time
              lastLoadedTimestamp = DateTime.timestamp();
              prefs.setString(
                "cachedAdTime",
                DateTime.timestamp().toString(),
              );
            },
            onAdFailedToLoad: (ads, error) {
              ads.dispose();
            },
          )).load();
    }
  }

  Future<void> startTimer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      DateTime? cachedAdTimestamp = DateTime.tryParse(
        prefs.getString("cachedAdTime").toString(),
      );

      int? secDiff;
      if (cachedAdTimestamp != null) {
        secDiff = DateTime.now().difference(cachedAdTimestamp).inSeconds;
      }

      if (secDiff! > adExpTime) {
        loadBannerAd();
      }
    });
  }

  @override
  void dispose() {
    _admobBannerAd?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          if (_admobBannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: _admobBannerAd!.size.width.toDouble(),
                height: _admobBannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _admobBannerAd!),
              ),
            ),
        ],
      ),
    );
  }
}
