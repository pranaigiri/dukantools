import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dukan_tools/common/helper.dart';

class MarginCalculate extends StatefulWidget {
  const MarginCalculate({super.key});

  @override
  State<MarginCalculate> createState() => _MarginCalculateState();
}

enum MarginType { percent, amount }

class _MarginCalculateState extends State<MarginCalculate> {
  // Static variables for state persistence
  static double? _persistedPrice;
  static double? _persistedQty;
  static double? _persistedMargin;
  static MarginType _persistedMarginType = MarginType.percent;

  final TextEditingController itemPriceController = TextEditingController();
  final TextEditingController itemQtyController = TextEditingController();
  final TextEditingController itemMarginController = TextEditingController();

  double rawTotal = 0;
  double marginTotal = 0;

  MarginType _marginType = MarginType.percent;

  final helper = Helper();

  @override
  void initState() {
    super.initState();
    // Restore state
    _marginType = _persistedMarginType;
    if (_persistedPrice != null) {
      itemPriceController.text = helper.formatDouble(_persistedPrice!);
    }
    if (_persistedQty != null) {
      itemQtyController.text = _persistedQty!.toInt().toString();
    }
    if (_persistedMargin != null) {
      itemMarginController.text = _marginType == MarginType.percent
          ? _persistedMargin!.toStringAsFixed(1)
          : helper.formatDouble(_persistedMargin!);
    }
    calculateRawAndMarginTotal();
  }

  @override
  void dispose() {
    itemPriceController.dispose();
    itemQtyController.dispose();
    itemMarginController.dispose();
    super.dispose();
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      itemPriceController.clear();
      itemQtyController.clear();
      itemMarginController.clear();
      rawTotal = 0;
      marginTotal = 0;
      _persistedPrice = null;
      _persistedQty = null;
      _persistedMargin = null;
    });
  }

  void calculateRawAndMarginTotal() {
    double? tempPrice = double.tryParse(itemPriceController.text);
    double? tempQty = double.tryParse(itemQtyController.text);

    if (tempPrice != null && tempQty != null) {
      rawTotal = tempPrice * tempQty;

      double? tempMargin = double.tryParse(itemMarginController.text);
      if (tempMargin != null) {
        if (_marginType == MarginType.percent) {
          marginTotal = (rawTotal * tempMargin / 100) + rawTotal;
        } else {
          marginTotal = (tempPrice + tempMargin) * tempQty;
        }
      } else {
        marginTotal = rawTotal;
      }
    } else {
      rawTotal = 0;
      marginTotal = 0;
    }
    setState(() {});
  }

  void incrementPrice(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(itemPriceController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      itemPriceController.text = next == 0 ? "" : helper.formatDouble(next);
      _persistedPrice = next;
      calculateRawAndMarginTotal();
    });
  }

  void incrementQty(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(itemQtyController.text) ?? 0;
    double next = (current + val).clamp(1.0, 999999.0);
    setState(() {
      itemQtyController.text = next.toInt().toString();
      _persistedQty = next;
      calculateRawAndMarginTotal();
    });
  }

  void incrementMarginAmount(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(itemMarginController.text) ?? 0;
    double next = (current + val).clamp(0.0, 999999.0);
    setState(() {
      itemMarginController.text = next == 0 ? "" : helper.formatDouble(next);
      _persistedMargin = next;
      calculateRawAndMarginTotal();
    });
  }

  Widget _buildQuickButtons({
    required Function(double) onIncrement,
    required Color color,
    required List<double> increments,
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
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => onIncrement(val),
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
    final primaryColor = Colors.indigo;

    double currentMarginPercent = 0.0;
    if (_marginType == MarginType.percent) {
      currentMarginPercent = double.tryParse(itemMarginController.text) ?? 0.0;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Margin Calculator',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (itemPriceController.text.isNotEmpty ||
                  itemQtyController.text.isNotEmpty ||
                  itemMarginController.text.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: Icon(Icons.refresh, size: 18, color: primaryColor),
                  label: Text('Reset', style: TextStyle(color: primaryColor)),
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
                                labelText: 'Cost / Item (₹)',
                                prefixIcon: Icon(Icons.currency_rupee, size: 18),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _persistedPrice = double.tryParse(value);
                                  calculateRawAndMarginTotal();
                                });
                              },
                            ),
                            _buildQuickButtons(
                              onIncrement: incrementPrice,
                              color: primaryColor,
                              increments: [-50, -10, 10, 50, 100],
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
                                decimal: false,
                                signed: false,
                              ),
                              controller: itemQtyController,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                hintText: "1",
                                border: OutlineInputBorder(),
                                labelText: 'Quantity',
                                prefixIcon: Icon(Icons.production_quantity_limits, size: 18),
                              ),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (value) {
                                setState(() {
                                  _persistedQty = double.tryParse(value);
                                  calculateRawAndMarginTotal();
                                });
                              },
                            ),
                            _buildQuickButtons(
                              onIncrement: incrementQty,
                              color: Colors.blue,
                              increments: [-5, -1, 1, 5, 10],
                              suffix: " pcs",
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
          if (itemPriceController.text.isNotEmpty && itemQtyController.text.isNotEmpty) ...[
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Raw Cost Total",
                          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 13),
                        ),
                        Text(
                          "₹${helper.formatDouble(rawTotal)}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Margin Mode',
                      style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(
                              child: Text(
                                "Percent (%)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            selected: _marginType == MarginType.percent,
                            selectedColor: primaryColor,
                            labelStyle: TextStyle(
                              color: _marginType == MarginType.percent ? Colors.white : primaryColor,
                            ),
                            backgroundColor: primaryColor.withValues(alpha: 0.08),
                            side: BorderSide(color: _marginType == MarginType.percent ? primaryColor : primaryColor.withValues(alpha: 0.3)),
                            onSelected: (selected) {
                              if (selected) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _marginType = MarginType.percent;
                                  _persistedMarginType = MarginType.percent;
                                  itemMarginController.clear();
                                  _persistedMargin = null;
                                  calculateRawAndMarginTotal();
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(
                              child: Text(
                                "Flat Amount (₹)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            selected: _marginType == MarginType.amount,
                            selectedColor: primaryColor,
                            labelStyle: TextStyle(
                              color: _marginType == MarginType.amount ? Colors.white : primaryColor,
                            ),
                            backgroundColor: primaryColor.withValues(alpha: 0.08),
                            side: BorderSide(color: _marginType == MarginType.amount ? primaryColor : primaryColor.withValues(alpha: 0.3)),
                            onSelected: (selected) {
                              if (selected) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _marginType = MarginType.amount;
                                  _persistedMarginType = MarginType.amount;
                                  itemMarginController.clear();
                                  _persistedMargin = null;
                                  calculateRawAndMarginTotal();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_marginType == MarginType.percent) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Margin Percentage", style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontWeight: FontWeight.bold)),
                          Text(
                            "${currentMarginPercent.toStringAsFixed(1)} %",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Slider(
                        value: currentMarginPercent.clamp(0.0, 100.0),
                        min: 0.0,
                        max: 100.0,
                        divisions: 200,
                        activeColor: primaryColor,
                        inactiveColor: primaryColor.withValues(alpha: 0.2),
                        onChanged: (val) {
                          HapticFeedback.lightImpact();
                          setState(() {
                            itemMarginController.text = val.toStringAsFixed(1);
                            _persistedMargin = val;
                            calculateRawAndMarginTotal();
                          });
                        },
                      ),
                    ] else ...[
                      TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        controller: itemMarginController,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          hintText: "0.00",
                          border: OutlineInputBorder(),
                          labelText: 'Margin per Item (₹)',
                          prefixIcon: Icon(Icons.add, size: 18),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                        ],
                        onChanged: (value) {
                          setState(() {
                            _persistedMargin = double.tryParse(value);
                            calculateRawAndMarginTotal();
                          });
                        },
                      ),
                      _buildQuickButtons(
                        onIncrement: incrementMarginAmount,
                        color: primaryColor,
                        increments: [-10, -5, 5, 10, 50],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (itemMarginController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: Colors.green.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: isDark ? Colors.green.withValues(alpha: 0.3) : Colors.green.withValues(alpha: 0.5), width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Total Price (Incl. Margin)',
                        style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                        Text(
                          '₹${helper.formatDouble(marginTotal)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            color: isDark ? Colors.green : Colors.green.shade800,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryCol('Raw Total', '₹${helper.formatDouble(rawTotal)}', isDark),
                          _buildSummaryCol('Net Profit Margin', '₹${helper.formatDouble(marginTotal - rawTotal)}', isDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCol(String label, String val, bool isDark) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 12)),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.green : Colors.green.shade800)),
      ],
    );
  }
}
