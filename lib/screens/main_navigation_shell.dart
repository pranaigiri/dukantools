import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dukan_tools/common/version_code.dart';
import 'package:dukan_tools/main.dart'; // To access ThemeProvider
import 'package:dukan_tools/screens/dashboard_tab.dart';
import 'package:dukan_tools/screens/day_book_tab.dart';
import 'package:dukan_tools/screens/ledger_tab.dart';
import 'package:dukan_tools/features/financial_tools/screens/financial_tools_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  /// Track which tabs have been visited so we only build them on first access.
  /// This avoids building all 4 heavy tabs simultaneously (was causing 747
  /// skipped frames).
  final Set<int> _initializedTabs = {0}; // Tab 0 (dashboard) always built

  final List<String> _titles = const [
    "Overview Insights",
    "Day Book / Daily P&L",
    "Digital Ledger / Khata",
    "Financial Toolset",
  ];

  Widget _buildTab(int index) {
    switch (index) {
      case 0:
        return const DashboardTab();
      case 1:
        return const DayBookTab();
      case 2:
        return const LedgerTab();
      case 3:
        return const FinancialToolsScreen();
      default:
        return const SizedBox.shrink();
    }
  }

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
                color: Colors.black.withValues(alpha: 0.1),
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
                  themeProvider.isDarkModeEnabled
                      ? Icons.wb_sunny
                      : Icons.nights_stay,
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
              'lib/assets/icons/dukan_tools_logo.png',
              width: 80,
              height: 80,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.shop, size: 80, color: Colors.blue),
            ),
            const Text(
              "Dukan Tools",
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
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(4, (index) {
          // Only build tabs that have been visited; show empty placeholder for others
          if (_initializedTabs.contains(index)) {
            return _buildTab(index);
          }
          return const SizedBox.shrink();
        }),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
              _initializedTabs.add(index); // Lazily initialize the tab
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
