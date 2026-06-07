import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_tools/screens/about_us.dart';
import 'package:shop_tools/screens/item_details.dart';
import 'package:shop_tools/screens/main_navigation_shell.dart';
import 'package:shop_tools/services/database_service.dart';
import 'package:shop_tools/providers/data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  
  // Initialize Offline Hive database
  await DatabaseService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<DataProvider>(
          create: (_) => DataProvider(),
        ),
      ],
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
            return const MainNavigationShell();
          } catch (e) {
            return const MainNavigationShell();
          }
        },
        '/about-us': (context) {
          try {
            return AboutUs();
          } catch (e) {
            return const MainNavigationShell();
          }
        },
        '/itemDetails': (context) {
          try {
            return const ItemDetails();
          } catch (e) {
            return const MainNavigationShell();
          }
        },
      },
    );
  }
}
