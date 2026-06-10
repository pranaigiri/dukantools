import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dukan_tools/data/item_data.dart';
import 'package:dukan_tools/models/item.dart';
import 'package:dukan_tools/services/ad_manager.dart';
import 'package:dukan_tools/l10n/app_localizations.dart';
import 'package:dukan_tools/common/localizations_helper.dart';

class CalculatorsTab extends StatefulWidget {
  const CalculatorsTab({super.key});

  @override
  CalculatorsTabState createState() => CalculatorsTabState();
}

class CalculatorsTabState extends State<CalculatorsTab> {
  final List<Item> items = itemData;
  int crossAxisCount = 2;
  bool _isCompactView = false;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context)!;

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
                segments: <ButtonSegment<bool>>[
                  ButtonSegment<bool>(
                    value: false,
                    label: Text(l10n.standard),
                    icon: const Icon(Icons.grid_view),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text(l10n.compact),
                    icon: const Icon(Icons.apps),
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
                  AdManager.instance.incrementMeaningfulActions();
                  AdManager.instance.showInterstitialAd(
                    onDismissed: () {
                      Navigator.pushNamed(
                        context,
                        '/itemDetails',
                        arguments: items[index],
                      );
                    },
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
                          LocalizationsHelper.translate(context, items[index].name),
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
