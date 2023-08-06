import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gram_or_price/common/admob_helper.dart';
import 'package:gram_or_price/common/banner_ad.dart';
import 'package:gram_or_price/data/item_data.dart';
import 'package:gram_or_price/screens/about_us.dart';
import 'package:gram_or_price/screens/item_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

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
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Dukan Tools',
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
            return const AboutUs();
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
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Item> items = itemData;
  int crossAxisCount =
      2; // Default crossAxisCount value for extra smaller screens

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  InterstitialAd? _interstitialAd;
  final int maxFailedLoadAttempts = 3;
  int _interstitialLoadAttempts = 0;
  bool interstitialAdShow = true;

  void _createInterstitialAd() {
    InterstitialAd.load(
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

    // Adjust the crossAxisCount based on the screen width
    if (screenWidth <= 400) {
      crossAxisCount = 2; // For extra smaller screens
    } else if (screenWidth <= 600) {
      crossAxisCount = 3; // For smaller screens
    } else if (screenWidth <= 1200) {
      crossAxisCount = 4; // For medium-sized screens
    } else {
      crossAxisCount = 6; // For larger screens
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4.0,
                spreadRadius: 2.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            title: const Text('Dukan Tools'),
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
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
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
                      size: 65,
                      color: Colors.white,
                    ),
                    Text(
                      items[index].name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'lib/assets/icons/dukan_tools_logo_2.png',
              width: 80,
              height: 80,
            ),
            const Text(
              "Dukan Tools",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            const Text(
              "1.0.0",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
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
