import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gram_or_price/common/admob_helper.dart';
import 'package:gram_or_price/main.dart';
import 'package:gram_or_price/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

int adExpTime = 60;

class _ItemDetailsState extends State<ItemDetails> {
  BannerAd? _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  Future<void> _createBottomBannerAd() async {
    DateTime? cachedAdTimestamp;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cachedAdTimestamp = DateTime.tryParse(
      prefs.getString("cachedAdTime")!.toString(),
    );

    int? secDiff;
    if (cachedAdTimestamp != null) {
      secDiff = DateTime.now().difference(cachedAdTimestamp).inSeconds;
    }

    print("-----------------------LOADING BANNER AD");

    if ((_bottomBannerAd == null && secDiff == null) ||
        secDiff == null ||
        secDiff > adExpTime) {
      BannerAd(
        adUnitId: AdMobHelper.bannerUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            _bottomBannerAd = ad as BannerAd;
            setState(() {
              _isBottomBannerAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            _bottomBannerAd?.dispose();
            ad.dispose();
          },
        ),
      ).load();
    }
  }

  Timer? _timer;
  Future<void> startTimer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime? cachedAdTimestamp;
    int? secDiff;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        cachedAdTimestamp = DateTime.tryParse(
          prefs.getString("cachedAdTime").toString(),
        );
        if (cachedAdTimestamp != null) {
          secDiff = DateTime.now().difference(cachedAdTimestamp!).inSeconds;
        }
      },
    );

    if (secDiff! > adExpTime) {
      _createBottomBannerAd();
    }
  }

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd?.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments == null) {
      return const HomePage();
    } else {
      try {
        final Item item = ModalRoute.of(context)!.settings.arguments as Item;
        Widget currentWidget = item.widget;

        return Scaffold(
          appBar: AppBar(
            title: Text(item.name),
            backgroundColor: item.color,
            iconTheme: const IconThemeData(color: Colors.white),
            toolbarTextStyle: const TextTheme(
              titleLarge: TextStyle(
                color: Colors.white, // Sets the color of the title
                fontSize: 20,
              ),
            ).bodyMedium,
            titleTextStyle: const TextTheme(
              titleLarge: TextStyle(
                color: Colors.white, // Sets the color of the title
                fontSize: 20,
              ),
            ).titleLarge,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: currentWidget,
                ),
              ),
            ],
          ),
          bottomNavigationBar: _isBottomBannerAdLoaded
              ? SizedBox(
                  height: AdSize.banner.height.toDouble(),
                  width: AdSize.banner.width.toDouble(),
                  child: AdWidget(ad: _bottomBannerAd!),
                  //child: const Text("AD LOADED"),
                )
              : null,
        );
      } catch (e) {
        throw const CircularProgressIndicator();
      }
    }
  }
}
