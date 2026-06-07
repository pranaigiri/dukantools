import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shop_tools/common/admob_helper.dart';
import 'package:shop_tools/common/version_code.dart';
import 'package:shop_tools/data/item_data.dart';
import 'package:shop_tools/screens/about_us.dart';
import 'package:shop_tools/screens/item_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // List<String> devices = ['C3D220603635C490707BC02C3BDD4058'];

  // RequestConfiguration requestConfiguration = RequestConfiguration(
  //   testDeviceIds: devices,
  // );
  // MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkModeEnabled = prefs.getBool('isDarkModeEnabled') ?? false;
    _isDarkModeEnabled = isDarkModeEnabled;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkModeEnabled = !_isDarkModeEnabled;
    prefs.setBool('isDarkModeEnabled', _isDarkModeEnabled);
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Shop Tools',
      theme: themeProvider.isDarkModeEnabled
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
            ),
      initialRoute: '/',
      routes: {
        '/': (context) {
          try {
            return const HomePage();
          } catch (e) {
            // Handle the exception or display an error page
            return const HomePage();
          }
        },
        '/about-us': (context) {
          try {
            return AboutUs();
          } catch (e) {
            // Handle the exception or display an error page
            return const HomePage();
          }
        },
        '/itemDetails': (context) {
          try {
            return const ItemDetails();
          } catch (e) {
            // Handle the exception or display an error page
            return const HomePage();
          }
        },
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Item> items = itemData;
  int crossAxisCount =
      2; // Default crossAxisCount value for extra smaller screens
  bool _isCompactView = false;

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

  InterstitialAd? _interstitialAd;
  final int maxFailedLoadAttempts = 3;
  int _interstitialLoadAttempts = 0;
  bool interstitialAdShow = true;

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
    super.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final versionCode = VersionCode();

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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4.0,
                spreadRadius: 2.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            title: const Text('Shop Tools'),
            actions: [
              IconButton(
                onPressed: () {
                  themeProvider.toggleTheme(); // Use the toggleTheme function
                },
                icon: Icon(themeProvider.isDarkModeEnabled
                    ? Icons.wb_sunny
                    : Icons
                        .nights_stay), // Use the theme state to determine the icon
              ),
            ],
          ),
        ),
      ),
      body: Column(
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
                    interstitialAdShow ? _showInterstitialAd() : null;

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
                                fontWeight: FontWeight.w500),
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
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'lib/assets/icons/shop_tools_logo.png',
              width: 80,
              height: 80,
            ),
            const Text(
              "Shop Tools",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            FutureBuilder<String>(
              future: versionCode.getVersionCode(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('-');
                } else {
                  return Text(
                    '${snapshot.data}',
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  );
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Colors.black12,
              thickness: 0.5,
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about-us');
              },
            ),
          ],
        ),
      ),
    );
  }
}
