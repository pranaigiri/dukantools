import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dukan_tools/common/helper.dart';

class GramOrPrice extends StatefulWidget {
  const GramOrPrice({super.key});

  @override
  State<GramOrPrice> createState() => _GramOrPriceState();
}

class _GramOrPriceState extends State<GramOrPrice> {
  // Static variables for state persistence
  static double? _persistedPrice;
  static double? _persistedGram;
  static double? _persistedCalcPrice;
  static double? _persistedCalcGram;

  final itemPriceController = TextEditingController();
  final itemGramController = TextEditingController();
  final itemCalculatedPriceController = TextEditingController();
  final itemCalculatedGramController = TextEditingController();

  final _helper = Helper();

  double selectedPrice = 0;
  double selectedGram = 0;
  double calculatedPrice = 0;
  double calculatedGram = 0;

  @override
  void initState() {
    super.initState();
    // Restore state
    if (_persistedPrice != null) {
      selectedPrice = _persistedPrice!;
      itemPriceController.text = _helper.formatDouble(selectedPrice);
    }
    if (_persistedGram != null) {
      selectedGram = _persistedGram!;
      itemGramController.text = _helper.formatDouble(selectedGram);
    }
    if (_persistedCalcPrice != null) {
      calculatedPrice = _persistedCalcPrice!;
      itemCalculatedPriceController.text = _helper.formatDouble(calculatedPrice);
    }
    if (_persistedCalcGram != null) {
      calculatedGram = _persistedCalcGram!;
      itemCalculatedGramController.text = _helper.formatDouble(calculatedGram);
    }
    calculateRates();
  }

  @override
  void dispose() {
    itemPriceController.dispose();
    itemGramController.dispose();
    itemCalculatedGramController.dispose();
    itemCalculatedPriceController.dispose();
    super.dispose();
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      itemPriceController.clear();
      itemGramController.clear();
      itemCalculatedPriceController.clear();
      itemCalculatedGramController.clear();

      selectedPrice = 0;
      selectedGram = 0;
      calculatedPrice = 0;
      calculatedGram = 0;

      _persistedPrice = null;
      _persistedGram = null;
      _persistedCalcPrice = null;
      _persistedCalcGram = null;
    });
  }

  void incrementPrice(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(itemPriceController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      selectedPrice = next;
      _persistedPrice = next;
      itemPriceController.text = next == 0 ? "" : _helper.formatDouble(next);
      calculateGram();
    });
  }

  void incrementGram(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(itemGramController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      selectedGram = next;
      _persistedGram = next;
      itemGramController.text = next == 0 ? "" : _helper.formatDouble(next);
      calculatePrice();
    });
  }

  void incrementCalcPrice(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(itemCalculatedPriceController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      calculatedPrice = next;
      _persistedCalcPrice = next;
      itemCalculatedPriceController.text = next == 0 ? "" : _helper.formatDouble(next);
      calculateGram();
    });
  }

  void incrementCalcGram(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(itemCalculatedGramController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      calculatedGram = next;
      _persistedCalcGram = next;
      itemCalculatedGramController.text = next == 0 ? "" : _helper.formatDouble(next);
      calculatePrice();
    });
  }

  Widget _buildQuickButtons({
    required List<double> increments,
    required Function(double) onIncrement,
    String suffix = "",
  }) {
    return Container(
      height: 38,
      margin: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: increments.length,
        itemBuilder: (context, index) {
          final val = increments[index];
          final sign = val > 0 ? "+" : "";
          final label = "$sign${val.toInt()}$suffix";
          return Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: Material(
              color: Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => onIncrement(val),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.orange,
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
    final hasInput = selectedPrice > 0 && selectedGram > 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Unit Price Setup',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (selectedPrice > 0 || selectedGram > 0)
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.refresh, size: 18, color: Colors.orange),
                  label: const Text('Reset', style: TextStyle(color: Colors.orange)),
                ),
            ],
          ),
          const SizedBox(height: 12),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                                signed: false,
                              ),
                              controller: itemPriceController,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                hintText: "0.00",
                                border: OutlineInputBorder(),
                                labelText: 'Item Price (₹)',
                                prefixIcon: Icon(Icons.currency_rupee, size: 18),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedPrice = double.tryParse(value) ?? 0;
                                  _persistedPrice = selectedPrice;
                                  if (value.isNotEmpty) {
                                    calculateGram();
                                  } else {
                                    itemCalculatedPriceController.clear();
                                    itemCalculatedGramController.clear();
                                    calculatedPrice = 0;
                                    calculatedGram = 0;
                                    _persistedCalcPrice = null;
                                    _persistedCalcGram = null;
                                  }
                                });
                              },
                            ),
                            _buildQuickButtons(
                              increments: [-50, -10, 10, 50, 100],
                              onIncrement: incrementPrice,
                              suffix: "",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                                signed: false,
                              ),
                              controller: itemGramController,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                hintText: "0",
                                border: OutlineInputBorder(),
                                labelText: 'Weight (g)',
                                prefixIcon: Icon(Icons.scale, size: 18),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedGram = double.tryParse(value) ?? 0;
                                  _persistedGram = selectedGram;
                                  if (value.isNotEmpty) {
                                    calculatePrice();
                                  } else {
                                    itemCalculatedPriceController.clear();
                                    itemCalculatedGramController.clear();
                                    calculatedPrice = 0;
                                    calculatedGram = 0;
                                    _persistedCalcPrice = null;
                                    _persistedCalcGram = null;
                                  }
                                });
                              },
                            ),
                            _buildQuickButtons(
                              increments: [-250, -50, 50, 250, 500],
                              onIncrement: incrementGram,
                              suffix: "g",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (hasInput) ...[
            Card(
              elevation: 0,
              color: Colors.orange.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: isDark ? Colors.orange.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Unit Rates Summary',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.orange.shade300 : Colors.orange.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildRateCol("Per 1g", selectedPrice / selectedGram, isDark),
                        _buildRateCol("Per 100g", (selectedPrice / selectedGram) * 100, isDark),
                        _buildRateCol("Per 1kg", (selectedPrice / selectedGram) * 1000, isDark),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Dynamic Calculation Converter',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade800,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: (isDark ? Colors.grey.shade800 : Colors.grey.shade300), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            controller: itemCalculatedPriceController,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              hintText: "0.00",
                              border: OutlineInputBorder(),
                              labelText: 'Desired Price (₹)',
                              prefixIcon: Icon(Icons.currency_rupee, size: 18),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                            ],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  itemCalculatedGramController.clear();
                                  calculatedPrice = 0;
                                  calculatedGram = 0;
                                  _persistedCalcPrice = null;
                                  _persistedCalcGram = null;
                                });
                              } else {
                                calculatedPrice = double.tryParse(value) ?? 0;
                                _persistedCalcPrice = calculatedPrice;
                                calculateGram();
                              }
                            },
                          ),
                          _buildQuickButtons(
                            increments: [-50, -10, 10, 50, 100],
                            onIncrement: incrementCalcPrice,
                            suffix: "",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.swap_horiz,
                          color: Colors.orange,
                          size: 32,
                        ),
                        onPressed: _swapCalculatedValues,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            controller: itemCalculatedGramController,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              hintText: "0",
                              border: OutlineInputBorder(),
                              labelText: 'Calculated Weight (g)',
                              prefixIcon: Icon(Icons.scale, size: 18),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                            ],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  itemCalculatedPriceController.clear();
                                  calculatedPrice = 0;
                                  calculatedGram = 0;
                                  _persistedCalcPrice = null;
                                  _persistedCalcGram = null;
                                });
                              } else {
                                calculatedGram = double.tryParse(value) ?? 0;
                                _persistedCalcGram = calculatedGram;
                                calculatePrice();
                              }
                            },
                          ),
                          _buildQuickButtons(
                            increments: [-250, -50, 50, 250, 500],
                            onIncrement: incrementCalcGram,
                            suffix: "g",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRateCol(String label, double value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
        ),
        const SizedBox(height: 4),
        Text(
          "₹${_helper.formatDouble(value)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.orange : Colors.orange.shade800,
          ),
        ),
      ],
    );
  }

  void calculateGram() {
    calculateRates();
    if (selectedPrice > 0) {
      calculatedGram = (selectedGram / selectedPrice) * calculatedPrice;
      _persistedCalcGram = calculatedGram;
      itemCalculatedGramController.text = _helper.formatDouble(calculatedGram);
    }
  }

  void calculatePrice() {
    calculateRates();
    if (selectedGram > 0) {
      calculatedPrice = (selectedPrice / selectedGram) * calculatedGram;
      _persistedCalcPrice = calculatedPrice;
      itemCalculatedPriceController.text = _helper.formatDouble(calculatedPrice);
    }
  }

  void _swapCalculatedValues() {
    HapticFeedback.lightImpact();
    setState(() {
      double temp = calculatedPrice;
      calculatedPrice = calculatedGram;
      calculatedGram = temp;
      
      _persistedCalcPrice = calculatedPrice;
      _persistedCalcGram = calculatedGram;
      
      itemCalculatedPriceController.text = calculatedPrice == 0 ? "" : _helper.formatDouble(calculatedPrice);
      itemCalculatedGramController.text = calculatedGram == 0 ? "" : _helper.formatDouble(calculatedGram);
      
      calculateGram();
    });
  }

  void calculateRates() {
    setState(() {});
  }
}
