import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dukan_tools/common/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exchange_rates_model.dart';
import 'package:dukan_tools/services/currency_converter_service.dart';

class CurrencyConvert extends StatefulWidget {
  const CurrencyConvert({super.key});

  @override
  State<CurrencyConvert> createState() => _CurrencyConvertState();
}

List<Map<String, double>> currencies = [];

class _CurrencyConvertState extends State<CurrencyConvert> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _activeTabIndex = 0;

  // Live Rates State
  static String? _persistedCurrencyA;
  static String? _persistedCurrencyB;
  static String? _persistedCaVal;
  static String? _persistedCbVal;

  String currencyA = "INR";
  String currencyB = "USD";

  final TextEditingController caController = TextEditingController();
  final TextEditingController cbController = TextEditingController();

  // Manual Rates State
  String manualCurrencyA = "USD";
  String manualCurrencyB = "INR";
  final TextEditingController manualRateController = TextEditingController(text: "83.50");
  final TextEditingController manualCaController = TextEditingController();
  final TextEditingController manualCbController = TextEditingController();

  final _helper = Helper();
  final _currencyConvertService = CurrencyConverterService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _activeTabIndex = _tabController!.index;
      });
    });

    currencies = _currencyConvertService.getRatesFromResponse(
        ExchangeRatesModel.fromJson(_currencyConvertService.staticApiResponse));

    // Restore Live state
    if (_persistedCurrencyA != null) currencyA = _persistedCurrencyA!;
    if (_persistedCurrencyB != null) currencyB = _persistedCurrencyB!;
    if (_persistedCaVal != null) caController.text = _persistedCaVal!;
    if (_persistedCbVal != null) cbController.text = _persistedCbVal!;

    // Load saved settings
    _loadSavedSettings();

    updateExchangeRates().then((_) {
      if (_persistedCurrencyA == null && _persistedCurrencyB == null) {
        getSavedDropdowns();
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    caController.dispose();
    cbController.dispose();
    manualRateController.dispose();
    manualCaController.dispose();
    manualCbController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      manualCurrencyA = prefs.getString("manualCurrencyA") ?? "USD";
      manualCurrencyB = prefs.getString("manualCurrencyB") ?? "INR";
      manualRateController.text = prefs.getString("manualRate") ?? "83.50";
      manualCaController.text = prefs.getString("manualCaVal") ?? "";
      manualCbController.text = prefs.getString("manualCbVal") ?? "";
    });
  }

  Future<void> _saveManualSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("manualCurrencyA", manualCurrencyA);
    await prefs.setString("manualCurrencyB", manualCurrencyB);
    await prefs.setString("manualRate", manualRateController.text);
    await prefs.setString("manualCaVal", manualCaController.text);
    await prefs.setString("manualCbVal", manualCbController.text);
  }

  void _clearAllLive() {
    HapticFeedback.mediumImpact();
    setState(() {
      caController.clear();
      cbController.clear();
      _persistedCaVal = null;
      _persistedCbVal = null;
    });
  }

  void _clearAllManual() {
    HapticFeedback.mediumImpact();
    setState(() {
      manualCaController.clear();
      manualCbController.clear();
      _saveManualSettings();
    });
  }

  Future<void> updateExchangeRates() async {
    final value = await _currencyConvertService.getExchangeRates();
    if (mounted) {
      setState(() {
        currencies = value;
      });
    }
  }

  Future<void> getSavedDropdowns() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dropdownA = prefs.getString("dropdownA");
    String? dropdownB = prefs.getString("dropdownB");

    setState(() {
      if (dropdownA != null && currencies.any((e) => e.keys.first == dropdownA)) {
        currencyA = dropdownA;
        _persistedCurrencyA = currencyA;
      }
      if (dropdownB != null && currencies.any((e) => e.keys.first == dropdownB)) {
        currencyB = dropdownB;
        _persistedCurrencyB = currencyB;
      }
    });
  }

  Future<void> saveDropdownSelections() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("dropdownA", currencyA);
    await prefs.setString("dropdownB", currencyB);
  }

  void selectPair(String a, String b) {
    HapticFeedback.mediumImpact();
    setState(() {
      currencyA = a;
      currencyB = b;
      _persistedCurrencyA = a;
      _persistedCurrencyB = b;
      saveDropdownSelections();
      if (caController.text.isNotEmpty) {
        calculateB();
      } else if (cbController.text.isNotEmpty) {
        calculateA();
      }
    });
  }

  void incrementA(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(caController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      caController.text = next == 0 ? "" : _helper.formatDouble(next);
      _persistedCaVal = caController.text;
      calculateB();
    });
  }

  void incrementB(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(cbController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      cbController.text = next == 0 ? "" : _helper.formatDouble(next);
      _persistedCbVal = cbController.text;
      calculateA();
    });
  }

  void incrementManualA(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(manualCaController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      manualCaController.text = next == 0 ? "" : _helper.formatDouble(next);
      calculateManualB();
      _saveManualSettings();
    });
  }

  void incrementManualB(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(manualCbController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      manualCbController.text = next == 0 ? "" : _helper.formatDouble(next);
      calculateManualA();
      _saveManualSettings();
    });
  }

  Widget _buildQuickButtons({
    required Function(double) onIncrement,
    required Color color,
  }) {
    final increments = [-100, -10, 10, 100, 1000];
    return Container(
      height: 38,
      margin: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: increments.length,
        itemBuilder: (context, index) {
          final val = increments[index];
          final sign = val > 0 ? "+" : "";
          final label = "$sign${val.toInt()}";
          return Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: Material(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => onIncrement(val.toDouble()),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: color.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
          child: TabBar(
            controller: _tabController,
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            tabs: const [
              Tab(icon: Icon(Icons.sync), text: "Live Rates (API)"),
              Tab(icon: Icon(Icons.edit_note), text: "Manual Rates (Offline)"),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _activeTabIndex == 0 ? _buildLiveRatesTab(isDark) : _buildManualRatesTab(isDark),
      ],
    );
  }

  Widget _buildLiveRatesTab(bool isDark) {
    final theme = Theme.of(context);
    final primaryColor = Colors.lightGreen;
    final popularPairs = [
      {"label": "USD ➔ INR", "a": "USD", "b": "INR"},
      {"label": "EUR ➔ INR", "a": "EUR", "b": "INR"},
      {"label": "GBP ➔ INR", "a": "GBP", "b": "INR"},
      {"label": "AED ➔ INR", "a": "AED", "b": "INR"},
      {"label": "USD ➔ EUR", "a": "USD", "b": "EUR"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular Pairs",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
              ),
              if (caController.text.isNotEmpty || cbController.text.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearAllLive,
                  icon: Icon(Icons.refresh, size: 18, color: primaryColor),
                  label: Text('Reset', style: TextStyle(color: primaryColor)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: popularPairs.map((pair) {
                final isCurrent = currencyA == pair["a"] && currencyB == pair["b"];
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                    label: Text(
                      pair["label"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? Colors.white : primaryColor,
                      ),
                    ),
                    selected: isCurrent,
                    selectedColor: primaryColor,
                    backgroundColor: primaryColor.withOpacity(0.08),
                    side: BorderSide(color: isCurrent ? primaryColor : primaryColor.withOpacity(0.3)),
                    onSelected: (selected) {
                      if (selected) {
                        selectPair(pair["a"]!, pair["b"]!);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Currency A input card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: (isDark ? Colors.grey.shade800 : Colors.grey.shade300), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          controller: caController,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "Enter amount",
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            labelText: currencyA,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,10}'))
                          ],
                          onChanged: (value) {
                            setState(() {
                              _persistedCaVal = value;
                              if (value.isNotEmpty) {
                                calculateB();
                              } else {
                                cbController.clear();
                                _persistedCbVal = "";
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            labelText: "From",
                          ),
                          isExpanded: true,
                          value: currencies.any((e) => e.keys.first == currencyA)
                              ? currencyA
                              : currencies.isNotEmpty ? currencies[0].keys.first : "INR",
                          elevation: 16,
                          onChanged: (String? value) {
                            if (value != null) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                currencyA = value;
                                _persistedCurrencyA = value;
                                if (caController.text.isNotEmpty) {
                                  calculateB();
                                }
                                saveDropdownSelections();
                              });
                            }
                          },
                          items: currencies.map<DropdownMenuItem<String>>(
                              (Map<String, double> currency) {
                            String currencyName = currency.keys.first;
                            return DropdownMenuItem<String>(
                              value: currencyName,
                              child: Text(currencyName),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  _buildQuickButtons(
                    onIncrement: incrementA,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: IconButton(
              icon: const Icon(
                Icons.swap_vert,
                color: Colors.lightGreen,
                size: 32,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  final tempCur = currencyA;
                  currencyA = currencyB;
                  currencyB = tempCur;
                  _persistedCurrencyA = currencyA;
                  _persistedCurrencyB = currencyB;
                  saveDropdownSelections();
                  if (caController.text.isNotEmpty) {
                    calculateB();
                  }
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          // Currency B input card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: (isDark ? Colors.grey.shade800 : Colors.grey.shade300), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          controller: cbController,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "Converted value",
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            labelText: currencyB,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,10}'))
                          ],
                          onChanged: (value) {
                            setState(() {
                              _persistedCbVal = value;
                              if (value.isNotEmpty) {
                                calculateA();
                              } else {
                                caController.clear();
                                _persistedCaVal = "";
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            labelText: "To",
                          ),
                          isExpanded: true,
                          value: currencies.any((e) => e.keys.first == currencyB)
                              ? currencyB
                              : currencies.length > 1 ? currencies[1].keys.first : "USD",
                          elevation: 16,
                          onChanged: (String? value) {
                            if (value != null) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                currencyB = value;
                                _persistedCurrencyB = value;
                                if (cbController.text.isNotEmpty) {
                                  calculateA();
                                }
                                saveDropdownSelections();
                              });
                            }
                          },
                          items: currencies.map<DropdownMenuItem<String>>(
                              (Map<String, double> currency) {
                            String currencyName = currency.keys.first;
                            return DropdownMenuItem<String>(
                              value: currencyName,
                              child: Text(currencyName),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  _buildQuickButtons(
                    onIncrement: incrementB,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Metadata Box showing Last Updated and Next Refresh Dates
          FutureBuilder<Map<String, String>>(
            future: _currencyConvertService.getCacheMetadata(),
            builder: (context, snapshot) {
              final metadata = snapshot.data ?? {
                'lastUpdated': 'Fetching...',
                'nextRefresh': 'Fetching...'
              };
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Last Updated (Rates)",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          metadata['lastUpdated']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Next Refresh Schedule",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          metadata['nextRefresh']!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildManualRatesTab(bool isDark) {
    final accentColor = Colors.teal;
    final currencyList = currencies.map((e) => e.keys.first).toList();
    if (currencyList.isEmpty) {
      currencyList.addAll(['USD', 'EUR', 'GBP', 'INR', 'AED', 'SAR', 'CAD', 'AUD', 'JPY']);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Offline Manual Conversion",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
              ),
              if (manualCaController.text.isNotEmpty || manualCbController.text.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearAllManual,
                  icon: Icon(Icons.refresh, size: 18, color: accentColor),
                  label: Text('Reset', style: TextStyle(color: accentColor)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Custom exchange rate card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: (isDark ? Colors.grey.shade800 : Colors.grey.shade300), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Set Custom Exchange Rate",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        "1 $manualCurrencyA = ",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          controller: manualRateController,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "Exchange Rate",
                            suffixText: manualCurrencyB,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          onChanged: (val) {
                            calculateManualB();
                            _saveManualSettings();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Manual input card (Currency A)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: (isDark ? Colors.grey.shade800 : Colors.grey.shade300), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          controller: manualCaController,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "Enter amount",
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            labelText: manualCurrencyA,
                          ),
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              calculateManualB();
                            } else {
                              manualCbController.clear();
                            }
                            _saveManualSettings();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            labelText: "From",
                          ),
                          isExpanded: true,
                          value: manualCurrencyA,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                manualCurrencyA = value;
                                calculateManualB();
                                _saveManualSettings();
                              });
                            }
                          },
                          items: currencyList.map<DropdownMenuItem<String>>((String name) {
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  _buildQuickButtons(
                    onIncrement: incrementManualA,
                    color: accentColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: IconButton(
              icon: const Icon(Icons.swap_vert, size: 32, color: Colors.teal),
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  final temp = manualCurrencyA;
                  manualCurrencyA = manualCurrencyB;
                  manualCurrencyB = temp;
                  
                  if (manualCaController.text.isNotEmpty) {
                    calculateManualB();
                  }
                  _saveManualSettings();
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          // Manual output card (Currency B)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: (isDark ? Colors.grey.shade800 : Colors.grey.shade300), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          controller: manualCbController,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "Converted value",
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            labelText: manualCurrencyB,
                          ),
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              calculateManualA();
                            } else {
                              manualCaController.clear();
                            }
                            _saveManualSettings();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            labelText: "To",
                          ),
                          isExpanded: true,
                          value: manualCurrencyB,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                manualCurrencyB = value;
                                calculateManualB();
                                _saveManualSettings();
                              });
                            }
                          },
                          items: currencyList.map<DropdownMenuItem<String>>((String name) {
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  _buildQuickButtons(
                    onIncrement: incrementManualB,
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Live Calculations
  double caRate = 0;
  double cbRate = 0;
  void initValues() {
    for (var currency in currencies) {
      if (currency.keys.first == currencyA) {
        caRate = currency.values.first;
      }
      if (currency.keys.first == currencyB) {
        cbRate = currency.values.first;
      }
    }
  }

  void calculateA() {
    initValues();
    if (cbRate == 0) return;
    double? tempCbValue = double.tryParse(cbController.text);
    if (tempCbValue == null) return;
    double caVal = (caRate / cbRate) * tempCbValue;
    setState(() {
      caController.text = _helper.formatDouble(caVal);
      _persistedCaVal = caController.text;
    });
  }

  void calculateB() {
    initValues();
    if (caRate == 0) return;
    double? tempCaValue = double.tryParse(caController.text);
    if (tempCaValue == null) return;
    double cbVal = (cbRate / caRate) * tempCaValue;
    setState(() {
      cbController.text = _helper.formatDouble(cbVal);
      _persistedCbVal = cbController.text;
    });
  }

  // Manual Calculations
  void calculateManualA() {
    final rate = double.tryParse(manualRateController.text) ?? 1.0;
    if (rate == 0) return;
    final valB = double.tryParse(manualCbController.text) ?? 0.0;
    final valA = valB / rate;
    setState(() {
      manualCaController.text = _helper.formatDouble(valA);
    });
  }

  void calculateManualB() {
    final rate = double.tryParse(manualRateController.text) ?? 1.0;
    final valA = double.tryParse(manualCaController.text) ?? 0.0;
    final valB = valA * rate;
    setState(() {
      manualCbController.text = _helper.formatDouble(valB);
    });
  }
}
