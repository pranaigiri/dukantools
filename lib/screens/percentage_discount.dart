import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_tools/common/helper.dart';

class PercentageDiscount extends StatefulWidget {
  const PercentageDiscount({super.key});

  @override
  State<PercentageDiscount> createState() => _PercentageDiscountState();
}

class _PercentageDiscountState extends State<PercentageDiscount> {
  // Static variables for state persistence
  static double? _persistedAmount;
  static double? _persistedPercent;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();

  double afterOff = 0.00;
  double remAmount = 0.00;

  final helper = Helper();

  @override
  void initState() {
    super.initState();
    // Restore state
    if (_persistedAmount != null) {
      _amountController.text = helper.formatDouble(_persistedAmount!);
    }
    if (_persistedPercent != null) {
      _percentController.text = _persistedPercent!.toStringAsFixed(1);
    }
    calculatePercentage();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _percentController.dispose();
    super.dispose();
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      _amountController.clear();
      _percentController.clear();
      afterOff = 0.00;
      remAmount = 0.00;
      _persistedAmount = null;
      _persistedPercent = null;
    });
  }

  void calculatePercentage() {
    double? tempAmount = double.tryParse(_amountController.text);
    double? tempPercent = double.tryParse(_percentController.text);

    setState(() {
      if (tempAmount != null && tempPercent != null) {
        afterOff = (tempAmount * tempPercent) / 100;
        remAmount = tempAmount - afterOff;
      } else {
        afterOff = 0;
        remAmount = 0;
      }
    });
  }

  void incrementAmount(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(_amountController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      _amountController.text = next == 0 ? "" : helper.formatDouble(next);
      _persistedAmount = next;
      calculatePercentage();
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

    double currentPercent = double.tryParse(_percentController.text) ?? 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calculate Discount',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_amountController.text.isNotEmpty || _percentController.text.isNotEmpty)
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
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    controller: _amountController,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: "Enter Original Price",
                      border: OutlineInputBorder(),
                      labelText: 'Original Price (₹)',
                      prefixIcon: Icon(Icons.currency_rupee, size: 18),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    onChanged: (value) {
                      setState(() {
                        _persistedAmount = double.tryParse(value);
                        calculatePercentage();
                      });
                    },
                  ),
                  _buildQuickButtons(
                    onIncrement: incrementAmount,
                    color: Colors.orange,
                    increments: [-1000, -100, -10, 10, 100, 1000],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discount Rate (%)",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
                      ),
                      Text(
                        "${currentPercent.toStringAsFixed(1)} % Off",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                      ),
                    ],
                  ),
                  Slider(
                    value: currentPercent.clamp(0.0, 100.0),
                    min: 0.0,
                    max: 100.0,
                    divisions: 200,
                    activeColor: Colors.orange,
                    inactiveColor: Colors.orange.withValues(alpha: 0.2),
                    onChanged: (val) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _percentController.text = val.toStringAsFixed(1);
                        _persistedPercent = val;
                        calculatePercentage();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_amountController.text.isNotEmpty && _percentController.text.isNotEmpty) ...[
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
                      'Final Price (After Discount)',
                      style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${helper.formatDouble(remAmount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: isDark ? Colors.green.shade300 : Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryCol('Original Price', '₹${helper.formatDouble(double.tryParse(_amountController.text) ?? 0)}', Colors.grey, isDark),
                        _buildSummaryCol('You Save', '₹${helper.formatDouble(afterOff)}', Colors.green, isDark),
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

  Widget _buildSummaryCol(String label, String val, Color valColor, bool isDark) {
    Color finalColor = valColor;
    if (valColor == Colors.grey) {
      finalColor = isDark ? Colors.grey.shade400 : Colors.grey.shade800;
    } else if (valColor == Colors.green) {
      finalColor = isDark ? Colors.green.shade300 : Colors.green.shade800;
    }
    return Column(
      children: [
        Text(label, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 12)),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: finalColor)),
      ],
    );
  }
}
