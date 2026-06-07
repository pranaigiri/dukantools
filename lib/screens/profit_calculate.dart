import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dukan_tools/common/helper.dart';

class ProfitCalculate extends StatefulWidget {
  const ProfitCalculate({super.key});

  @override
  State<ProfitCalculate> createState() => _ProfitCalculateState();
}

class _ProfitCalculateState extends State<ProfitCalculate> {
  // Static variables for state persistence
  static double? _persistedBuy;
  static double? _persistedSell;
  static double? _persistedQty;

  final TextEditingController buyController = TextEditingController();
  final TextEditingController sellController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  double yourProfit = 0;
  double profitPercent = 0;

  final helper = Helper();

  @override
  void initState() {
    super.initState();
    // Restore state
    if (_persistedBuy != null) {
      buyController.text = helper.formatDouble(_persistedBuy!);
    }
    if (_persistedSell != null) {
      sellController.text = helper.formatDouble(_persistedSell!);
    }
    if (_persistedQty != null) {
      qtyController.text = helper.formatDouble(_persistedQty!);
    }
    calculateBuySell();
  }

  @override
  void dispose() {
    buyController.dispose();
    sellController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      buyController.clear();
      sellController.clear();
      qtyController.clear();
      yourProfit = 0;
      profitPercent = 0;
      _persistedBuy = null;
      _persistedSell = null;
      _persistedQty = null;
    });
  }

  void calculateBuySell() {
    double? buyPrice = double.tryParse(buyController.text);
    double? sellPrice = double.tryParse(sellController.text);
    double? qty = double.tryParse(qtyController.text);

    if (buyPrice != null && sellPrice != null) {
      double q = qty ?? 1;
      setState(() {
        yourProfit = (sellPrice - buyPrice) * q;
        if (buyPrice > 0) {
          profitPercent = ((sellPrice - buyPrice) / buyPrice) * 100;
        } else {
          profitPercent = 0;
        }
      });
    } else {
      setState(() {
        yourProfit = 0;
        profitPercent = 0;
      });
    }
  }

  void incrementBuy(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(buyController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      buyController.text = next == 0 ? "" : helper.formatDouble(next);
      _persistedBuy = next;
      calculateBuySell();
    });
  }

  void incrementSell(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(sellController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      sellController.text = next == 0 ? "" : helper.formatDouble(next);
      _persistedSell = next;
      calculateBuySell();
    });
  }

  void incrementQty(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(qtyController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999.0);
    setState(() {
      qtyController.text = next == 0 ? "" : next.toInt().toString();
      _persistedQty = next;
      calculateBuySell();
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
    final primaryColor = Colors.green;
    final isProfit = yourProfit >= 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profit Calculator',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (buyController.text.isNotEmpty ||
                  sellController.text.isNotEmpty ||
                  qtyController.text.isNotEmpty)
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
                              controller: buyController,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                hintText: "0.00",
                                border: OutlineInputBorder(),
                                labelText: 'Buy Price (₹)',
                                prefixIcon: Icon(Icons.shopping_cart, size: 18),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _persistedBuy = double.tryParse(value);
                                  calculateBuySell();
                                });
                              },
                            ),
                            _buildQuickButtons(
                              onIncrement: incrementBuy,
                              color: Colors.red,
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
                                decimal: true,
                                signed: false,
                              ),
                              controller: sellController,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                hintText: "0.00",
                                border: OutlineInputBorder(),
                                labelText: 'Sell Price (₹)',
                                prefixIcon: Icon(Icons.sell, size: 18),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _persistedSell = double.tryParse(value);
                                  calculateBuySell();
                                });
                              },
                            ),
                            _buildQuickButtons(
                              onIncrement: incrementSell,
                              color: Colors.green,
                              increments: [-50, -10, 10, 50, 100],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    controller: qtyController,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: "1",
                      border: OutlineInputBorder(),
                      labelText: 'Quantity (Optional)',
                      prefixIcon: Icon(Icons.production_quantity_limits, size: 18),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        _persistedQty = double.tryParse(value);
                        calculateBuySell();
                      });
                    },
                  ),
                  _buildQuickButtons(
                    onIncrement: incrementQty,
                    color: Colors.blue,
                    increments: [-10, -1, 1, 10, 50],
                    suffix: " pcs",
                  ),
                ],
              ),
            ),
          ),
          if (buyController.text.isNotEmpty && sellController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: isProfit ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isProfit
                      ? (isDark ? Colors.green.withValues(alpha: 0.3) : Colors.green.withValues(alpha: 0.5))
                      : (isDark ? Colors.red.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.5)),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      isProfit ? 'Net Profit' : 'Net Loss',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isProfit ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${helper.formatDouble(yourProfit.abs())}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: isProfit
                            ? (isDark ? Colors.green.shade300 : Colors.green.shade800)
                            : (isDark ? Colors.red.shade300 : Colors.red.shade800),
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isProfit ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                        children: [
                          TextSpan(
                            text: '${helper.formatDouble(profitPercent.abs())}% ',
                          ),
                          TextSpan(
                            text: isProfit ? 'Profit margin' : 'Loss on buy price',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryCol('Cost Price', '₹${helper.formatDouble((double.tryParse(buyController.text) ?? 0) * (double.tryParse(qtyController.text) ?? 1))}', isDark),
                        _buildSummaryCol('Sale Price', '₹${helper.formatDouble((double.tryParse(sellController.text) ?? 0) * (double.tryParse(qtyController.text) ?? 1))}', isDark),
                      ],
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

  Widget _buildSummaryCol(String label, String val, bool isDark) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 12)),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.grey.shade300 : Colors.black87)),
      ],
    );
  }
}
