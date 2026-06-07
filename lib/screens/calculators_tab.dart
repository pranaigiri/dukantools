import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dukan_tools/common/admob_helper.dart';
import 'package:dukan_tools/data/item_data.dart';
import 'package:dukan_tools/models/item.dart';

class CalculatorsTab extends StatefulWidget {
  const CalculatorsTab({super.key});

  @override
  CalculatorsTabState createState() => CalculatorsTabState();
}

class CalculatorsTabState extends State<CalculatorsTab> {
  final List<Item> items = itemData;
  int crossAxisCount = 2;
  bool _isCompactView = false;
  InterstitialAd? _interstitialAd;
  final int maxFailedLoadAttempts = 3;
  int _interstitialLoadAttempts = 0;
  bool interstitialAdShow = true;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    _loadViewPreference();
  }

  Future<void> _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCompactView = prefs.getBool('isCompactView') ?? false;
    });
  }

  Future<void> _setViewPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCompactView', value);
    setState(() {
      _isCompactView = value;
    });
  }

  Future<void> _createInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdMobHelper.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      _createInterstitialAd();
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust layout parameters based on compact mode and screen width
    final double padding = _isCompactView ? 12.0 : 20.0;
    final double spacing = _isCompactView ? 8.0 : 10.0;
    final double iconSize = _isCompactView ? 36.0 : 65.0;
    final double fontSize = _isCompactView ? 13.0 : 16.0;

    if (_isCompactView) {
      if (screenWidth <= 400) {
        crossAxisCount = 3;
      } else if (screenWidth <= 600) {
        crossAxisCount = 3;
      } else if (screenWidth <= 1200) {
        crossAxisCount = 5;
      } else {
        crossAxisCount = 8;
      }
    } else {
      if (screenWidth <= 400) {
        crossAxisCount = 2;
      } else if (screenWidth <= 600) {
        crossAxisCount = 2;
      } else if (screenWidth <= 1200) {
        crossAxisCount = 4;
      } else {
        crossAxisCount = 6;
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SegmentedButton<bool>(
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                segments: const <ButtonSegment<bool>>[
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Standard'),
                    icon: Icon(Icons.grid_view),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('Compact'),
                    icon: Icon(Icons.apps),
                  ),
                ],
                selected: <bool>{_isCompactView},
                onSelectionChanged: (Set<bool> newSelection) {
                  _setViewPreference(newSelection.first);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(padding),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  interstitialAdShow = !interstitialAdShow;
                  if (interstitialAdShow) {
                    _showInterstitialAd();
                  }

                  Navigator.pushNamed(
                    context,
                    '/itemDetails',
                    arguments: items[index],
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: items[index].color,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        items[index].iconData,
                        size: iconSize,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          items[index].name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
