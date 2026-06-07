import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dukan_tools/models/item.dart';

import '../models/tool_config.dart';
import '../models/legacy_card_config.dart';
import '../data/kirana_tools.dart';
import '../data/chai_tools.dart';
import '../data/saree_tools.dart';
import '../data/medical_tools.dart';
import '../data/hardware_tools.dart';
import '../data/mobile_tools.dart';
import '../data/others_tools.dart';
import '../widgets/category_chip_bar.dart';
import '../widgets/tool_grid_card.dart';
import 'tool_calculator_screen.dart';

class FinancialToolItem {
  final ToolConfig? toolConfig;
  final LegacyCardConfig? legacyConfig;

  FinancialToolItem.fromTool(this.toolConfig) : legacyConfig = null;
  FinancialToolItem.fromLegacy(this.legacyConfig) : toolConfig = null;

  String get toolId => toolConfig?.toolId ?? legacyConfig!.toolId;
  String get name => toolConfig?.name ?? legacyConfig!.name;
  String get description => toolConfig?.description ?? legacyConfig!.description;
  IconData get icon => toolConfig?.icon ?? legacyConfig!.icon;
  ShopCategory get category => toolConfig?.category ?? ShopCategory.others;
}

class FinancialToolsScreen extends StatefulWidget {
  const FinancialToolsScreen({super.key});

  @override
  State<FinancialToolsScreen> createState() => _FinancialToolsScreenState();
}

class _FinancialToolsScreenState extends State<FinancialToolsScreen> {
  String _selectedCategory = 'all';
  int _redExpiryCount = 0;
  int _yellowExpiryCount = 0;
  bool _isLoading = true;

  /// Owned here so it survives tab switches (CategoryChipBar may be disposed
  /// and recreated when switching tabs, but this controller is not).
  final ScrollController _chipScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  @override
  void dispose() {
    _chipScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCategory = prefs.getString('financial_tools_last_category') ?? 'all';
    await _loadExpiryWarnings();
    // Single setState to avoid triggering multiple rebuilds
    if (mounted) {
      setState(() {
        _selectedCategory = savedCategory;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadExpiryWarnings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('expiry_tracker_entries') ?? '[]';
    int redCount = 0;
    int yellowCount = 0;
    try {
      final list = json.decode(jsonStr) as List;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      for (var e in list) {
        final dateStr = e['expiryDate'] as String?;
        if (dateStr != null) {
          final expDate = DateTime.tryParse(dateStr);
          if (expDate != null) {
            final days = expDate.difference(today).inDays;
            if (days < 60) {
              redCount++;
            } else if (days < 90) {
              yellowCount++;
            }
          }
        }
      }
    } catch (_) {}

    _redExpiryCount = redCount;
    _yellowExpiryCount = yellowCount;
  }

  Future<void> _selectCategory(String catId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCategory = catId;
    });
    await prefs.setString('financial_tools_last_category', catId);
  }

  Color _getCategoryColor(ShopCategory cat) {
    switch (cat) {
      case ShopCategory.kirana:
        return const Color(0xFFD32F2F);
      case ShopCategory.chai:
        return const Color(0xFFE65100);
      case ShopCategory.saree:
        return const Color(0xFF7B1FA2);
      case ShopCategory.medical:
        return const Color(0xFF00796B);
      case ShopCategory.hardware:
        return const Color(0xFF455A64);
      case ShopCategory.mobile:
        return const Color(0xFF303F9F);
      case ShopCategory.others:
        return const Color(0xFF1976D2);
    }
  }

  ShopCategory _getCategoryEnum(String catId) {
    switch (catId) {
      case 'kirana':
        return ShopCategory.kirana;
      case 'chai':
        return ShopCategory.chai;
      case 'saree':
        return ShopCategory.saree;
      case 'medical':
        return ShopCategory.medical;
      case 'hardware':
        return ShopCategory.hardware;
      case 'mobile':
        return ShopCategory.mobile;
      case 'others':
      default:
        return ShopCategory.others;
    }
  }

  List<FinancialToolItem> _getItemsForCategory(String catId) {
    switch (catId) {
      case 'kirana':
        return kiranaTools.map((t) => FinancialToolItem.fromTool(t)).toList();
      case 'chai':
        return chaiTools.map((t) => FinancialToolItem.fromTool(t)).toList();
      case 'saree':
        return sareeTools.map((t) => FinancialToolItem.fromTool(t)).toList();
      case 'medical':
        return medicalTools.map((t) => FinancialToolItem.fromTool(t)).toList();
      case 'hardware':
        return hardwareTools.map((t) => FinancialToolItem.fromTool(t)).toList();
      case 'mobile':
        return mobileTools.map((t) => FinancialToolItem.fromTool(t)).toList();
      case 'others':
      default:
        final List<FinancialToolItem> list = [];
        list.addAll(othersTools.map((t) => FinancialToolItem.fromTool(t)));
        list.addAll(othersLegacyCards.map((c) => FinancialToolItem.fromLegacy(c)));
        return list;
    }
  }

  void _openTool(FinancialToolItem item) async {
    Item routeItem;

    if (item.toolConfig != null) {
      routeItem = Item(
        id: item.toolId.hashCode,
        name: item.name,
        iconData: item.icon,
        color: _getCategoryColor(item.category),
        widget: ToolCalculatorScreen(config: item.toolConfig!),
      );
    } else {
      routeItem = Item(
        id: item.toolId.hashCode,
        name: item.name,
        iconData: item.icon,
        color: item.legacyConfig!.color,
        widget: item.legacyConfig!.widget,
      );
    }

    await Navigator.pushNamed(
      context,
      '/itemDetails',
      arguments: routeItem,
    );

    // Refresh expiry warnings when returning
    _loadExpiryWarnings();
  }

  void _navigateToExpiryTracker() {
    final expTool = medicalTools.firstWhere((t) => t.toolId == 'expiry_tracker_medical');
    _openTool(FinancialToolItem.fromTool(expTool));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showWarningBanner = (_redExpiryCount > 0 || _yellowExpiryCount > 0) &&
        (_selectedCategory == 'all' || _selectedCategory == 'medical');

    return Column(
      children: [
        CategoryChipBar(
          selectedCategory: _selectedCategory,
          onCategorySelected: _selectCategory,
          scrollController: _chipScrollController,
        ),
        if (showWarningBanner)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Material(
              color: _redExpiryCount > 0
                  ? Colors.red.withValues(alpha: isDark ? 0.15 : 0.08)
                  : Colors.orange.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: _navigateToExpiryTracker,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _redExpiryCount > 0 ? Colors.red.withValues(alpha: 0.5) : Colors.orange.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: _redExpiryCount > 0 ? Colors.red : Colors.orange,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Critical Expiry Warning',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _redExpiryCount > 0 ? Colors.red : Colors.orange.shade800,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_redExpiryCount > 0 ? "$_redExpiryCount item(s) expiring in <60 days. " : ""}${_yellowExpiryCount > 0 ? "$_yellowExpiryCount item(s) expiring in <90 days." : ""}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: _redExpiryCount > 0 ? Colors.red : Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // If 'All' is selected, group tools by category with header labels
        if (_selectedCategory == 'all')
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...CategoryChipBar.categories.map((cat) {
                    final String catId = cat['id'] as String;
                    if (catId == 'all') return const SizedBox.shrink();

                    final tools = _getItemsForCategory(catId);
                    if (tools.isEmpty) return const SizedBox.shrink();

                    final catEnum = _getCategoryEnum(catId);
                    final catColor = _getCategoryColor(catEnum);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0, bottom: 10.0),
                          child: Row(
                            children: [
                              Icon(
                                cat['icon'] as IconData,
                                color: catColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                cat['label'] as String,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: catColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tools.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.05,
                          ),
                          itemBuilder: (context, index) {
                            final item = tools[index];
                            return ToolGridCard(
                              name: item.name,
                              description: item.description,
                              icon: item.icon,
                              category: item.category,
                              onTap: () => _openTool(item),
                            );
                          },
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          )
        else
          // Else, show single grid list for the selected category
          Expanded(
            child: Builder(
              builder: (context) {
                // Cache once to avoid recomputing on every itemBuilder call
                final tools = _getItemsForCategory(_selectedCategory);
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tools.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final item = tools[index];
                    return ToolGridCard(
                      name: item.name,
                      description: item.description,
                      icon: item.icon,
                      category: item.category,
                      onTap: () => _openTool(item),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
