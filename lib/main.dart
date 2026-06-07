import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dukan_tools/screens/about_us.dart';
import 'package:dukan_tools/screens/item_details.dart';
import 'package:dukan_tools/screens/main_navigation_shell.dart';
import 'package:dukan_tools/services/database_service.dart';
import 'package:dukan_tools/providers/data_provider.dart';
import 'package:dukan_tools/services/ad_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize centralized ad manager
  AdManager.instance.initialize();

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
      title: 'Dukan Tools',
      theme: themeProvider.isDarkModeEnabled
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
            ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigationShell(),
        '/about-us': (context) => AboutUs(),
        '/itemDetails': (context) => const ItemDetails(),
      },
    );
  }
}
