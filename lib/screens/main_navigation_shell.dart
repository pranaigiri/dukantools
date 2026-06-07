import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_tools/common/version_code.dart';
import 'package:shop_tools/main.dart'; // To access ThemeProvider
import 'package:shop_tools/screens/dashboard_tab.dart';
import 'package:shop_tools/screens/day_book_tab.dart';
import 'package:shop_tools/screens/ledger_tab.dart';
import 'package:shop_tools/screens/calculators_tab.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    DashboardTab(),
    DayBookTab(),
    LedgerTab(),
    CalculatorsTab(),
  ];

  final List<String> _titles = const [
    "Overview Insights",
    "Day Book / Daily P&L",
    "Digital Ledger / Khata",
    "Financial Toolset",
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final versionCode = VersionCode();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.0,
                spreadRadius: 1.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            title: Text(_titles[_currentIndex]),
            actions: [
              IconButton(
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                icon: Icon(
                  themeProvider.isDarkModeEnabled ? Icons.wb_sunny : Icons.nights_stay,
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'lib/assets/icons/shop_tools_logo.png',
              width: 80,
              height: 80,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.shop, size: 80, color: Colors.blue),
            ),
            const Text(
              "Shop Tools",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<String>(
              future: versionCode.getVersionCode(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text('-', textAlign: TextAlign.center);
                } else {
                  return Text(
                    'Version: ${snapshot.data}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.black12, thickness: 0.5),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about-us');
              },
            ),
          ],
        ),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          elevation: 8,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Day Book',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Ledger',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              activeIcon: Icon(Icons.calculate),
              label: 'Calculators',
            ),
          ],
        ),
      ),
    );
  }
}
