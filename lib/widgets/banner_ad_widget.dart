import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dukan_tools/common/admob_helper.dart';

class BannerAdWidget extends StatefulWidget {
  final AdSize adSize;

  const BannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _loadFailed = false;

  bool get _isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  void initState() {
    super.initState();
    if (_isSupported) {
      _loadAd();
    } else {
      _loadFailed = true;
    }
  }

  void _loadAd() {
    try {
      _bannerAd = BannerAd(
        adUnitId: AdMobHelper.bannerUnitId,
        size: widget.adSize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() {
                _isLoaded = true;
                _loadFailed = false;
              });
              debugPrint('[BannerAdWidget] Banner ad loaded successfully.');
            }
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('[BannerAdWidget] Banner ad failed to load: ${error.message}');
            ad.dispose();
            if (mounted) {
              setState(() {
                _isLoaded = false;
                _loadFailed = true;
              });
            }
          },
          onAdOpened: (ad) => debugPrint('[BannerAdWidget] Banner ad opened.'),
          onAdClosed: (ad) => debugPrint('[BannerAdWidget] Banner ad closed.'),
          onAdClicked: (ad) => debugPrint('[BannerAdWidget] Banner ad clicked.'),
        ),
      );
      _bannerAd!.load();
    } catch (e) {
      debugPrint('[BannerAdWidget] Exception loading ad: $e');
      if (mounted) {
        setState(() {
          _loadFailed = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSupported || _loadFailed) {
      // If ads are unsupported or fail to load, collapse completely to maintain UI usability.
      return const SizedBox.shrink();
    }

    final adHeight = widget.adSize.height.toDouble();

    return SafeArea(
      top: false,
      child: SizedBox(
        height: adHeight,
        child: Container(
          width: double.infinity,
          height: adHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.grey.shade50,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                width: 0.5,
              ),
            ),
          ),
          child: _isLoaded
              ? SizedBox(
                  width: widget.adSize.width.toDouble(),
                  height: adHeight,
                  child: AdWidget(ad: _bannerAd!),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Loading Sponsored Space...',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
