import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_tools/common/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exchange_rates_model.dart';
import 'package:shop_tools/services/currency_converter_service.dart';

class CurrencyConvert extends StatefulWidget {
  const CurrencyConvert({super.key});

  @override
  State<CurrencyConvert> createState() => _CurrencyConvertState();
}

List<Map<String, double>> currencies = [];

class _CurrencyConvertState extends State<CurrencyConvert> {
  // Static variables for state persistence
  static String? _persistedCurrencyA;
  static String? _persistedCurrencyB;
  static String? _persistedCaVal;
  static String? _persistedCbVal;

  String currencyA = "INR";
  String currencyB = "USD";

  final TextEditingController caController = TextEditingController();
  final TextEditingController cbController = TextEditingController();

  final _helper = Helper();
  final _currencyConvertService = CurrencyConverterService();

  @override
  void initState() {
    super.initState();
    currencies = _currencyConvertService.getRatesFromResponse(
        ExchangeRatesModel.fromJson(_currencyConvertService.staticApiResponse));

    // Load persisted state if available, otherwise restore dropdown selections from SharedPreferences
    if (_persistedCurrencyA != null) currencyA = _persistedCurrencyA!;
    if (_persistedCurrencyB != null) currencyB = _persistedCurrencyB!;
    if (_persistedCaVal != null) caController.text = _persistedCaVal!;
    if (_persistedCbVal != null) cbController.text = _persistedCbVal!;

    updateExchangeRates().then((_) {
      if (_persistedCurrencyA == null && _persistedCurrencyB == null) {
        getSavedDropdowns();
      }
    });
  }

  @override
  void dispose() {
    caController.dispose();
    cbController.dispose();
    super.dispose();
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      caController.clear();
      cbController.clear();
      _persistedCaVal = null;
      _persistedCbVal = null;
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
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => onIncrement(val.toDouble()),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: color.withValues(alpha: 0.3)),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.lightGreen;

    final popularPairs = [
      {"label": "USD ➔ INR", "a": "USD", "b": "INR"},
      {"label": "EUR ➔ INR", "a": "EUR", "b": "INR"},
      {"label": "GBP ➔ INR", "a": "GBP", "b": "INR"},
      {"label": "AED ➔ INR", "a": "AED", "b": "INR"},
      {"label": "USD ➔ EUR", "a": "USD", "b": "EUR"},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Currency Converter',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (caController.text.isNotEmpty || cbController.text.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: Icon(Icons.refresh, size: 18, color: primaryColor),
                  label: Text('Reset', style: TextStyle(color: primaryColor)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Popular Currency Pairs Chips
          Text(
            "Popular Pairs",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
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
                    backgroundColor: primaryColor.withValues(alpha: 0.08),
                    side: BorderSide(color: isCurrent ? primaryColor : primaryColor.withValues(alpha: 0.3)),
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
                            border: const OutlineInputBorder(),
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
                            border: OutlineInputBorder(),
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
          const Center(
            child: Icon(
              Icons.swap_vert,
              color: Colors.lightGreen,
              size: 32,
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
                            border: const OutlineInputBorder(),
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
                            border: OutlineInputBorder(),
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
          // Caching status bar
          FutureBuilder<String>(
            future: _currencyConvertService.getNextUpdateDuration(),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? 'Fetching caching info...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade800,
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

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
}
