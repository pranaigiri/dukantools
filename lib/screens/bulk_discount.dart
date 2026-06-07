import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dukan_tools/common/helper.dart';

class BulkDiscount extends StatefulWidget {
  const BulkDiscount({super.key});

  @override
  State<BulkDiscount> createState() => _BulkDiscountState();
}

class _BulkDiscountState extends State<BulkDiscount> {
  // Static variables for state persistence
  static double? _persistedSinglePrice;
  static double? _persistedPackQty;
  static double? _persistedPackPrice;

  final TextEditingController singlePriceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController packPriceController = TextEditingController();

  final helper = Helper();

  double singlePrice = 0;
  double packQty = 12;
  double packPrice = 0;

  double equivUnitPrice = 0;
  double savingsPerUnit = 0;
  double totalSavings = 0;
  double savingsPercent = 0;

  @override
  void initState() {
    super.initState();
    // Restore state
    if (_persistedSinglePrice != null) {
      singlePrice = _persistedSinglePrice!;
      singlePriceController.text = helper.formatDouble(singlePrice);
    }
    if (_persistedPackQty != null) {
      packQty = _persistedPackQty!;
      qtyController.text = packQty.toInt().toString();
    } else {
      qtyController.text = packQty.toInt().toString();
    }
    if (_persistedPackPrice != null) {
      packPrice = _persistedPackPrice!;
      packPriceController.text = helper.formatDouble(packPrice);
    }
    calculateSavings();
  }

  @override
  void dispose() {
    singlePriceController.dispose();
    qtyController.dispose();
    packPriceController.dispose();
    super.dispose();
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      singlePriceController.clear();
      packPriceController.clear();
      qtyController.text = "12";
      singlePrice = 0;
      packQty = 12;
      packPrice = 0;
      equivUnitPrice = 0;
      savingsPerUnit = 0;
      totalSavings = 0;
      savingsPercent = 0;
      _persistedSinglePrice = null;
      _persistedPackQty = null;
      _persistedPackPrice = null;
    });
  }

  void calculateSavings() {
    double? sPrice = double.tryParse(singlePriceController.text);
    double? pQty = double.tryParse(qtyController.text);
    double? pPrice = double.tryParse(packPriceController.text);

    if (sPrice != null && pQty != null && pPrice != null && pQty > 0) {
      setState(() {
        singlePrice = sPrice;
        packQty = pQty;
        packPrice = pPrice;

        equivUnitPrice = packPrice / packQty;
        savingsPerUnit = singlePrice - equivUnitPrice;
        totalSavings = (singlePrice * packQty) - packPrice;
        if (singlePrice > 0) {
          savingsPercent = (savingsPerUnit / singlePrice) * 100;
        } else {
          savingsPercent = 0;
        }
      });
    } else {
      setState(() {
        equivUnitPrice = 0;
        savingsPerUnit = 0;
        totalSavings = 0;
        savingsPercent = 0;
      });
    }
  }

  void incrementSinglePrice(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(singlePriceController.text) ?? 0;
    double next = (current + val).clamp(0.0, 9999999.0);
    setState(() {
      singlePriceController.text = next == 0 ? "" : helper.formatDouble(next);
      _persistedSinglePrice = next;
      calculateSavings();
    });
  }

  void incrementPackPrice(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(packPriceController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      packPriceController.text = next == 0 ? "" : helper.formatDouble(next);
      _persistedPackPrice = next;
      calculateSavings();
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
    final primaryColor = Colors.cyan;
    final isSaving = totalSavings >= 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bulk Savings Calculator',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (singlePriceController.text.isNotEmpty || packPriceController.text.isNotEmpty)
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
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    controller: singlePriceController,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: "0.00",
                      border: OutlineInputBorder(),
                      labelText: 'Single Item Price (₹)',
                      prefixIcon: Icon(Icons.sell, size: 18),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    onChanged: (value) {
                      setState(() {
                        _persistedSinglePrice = double.tryParse(value);
                        calculateSavings();
                      });
                    },
                  ),
                  _buildQuickButtons(
                    onIncrement: incrementSinglePrice,
                    color: Colors.orange,
                    increments: [-100, -10, 10, 100, 500],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    controller: packPriceController,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: "0.00",
                      border: OutlineInputBorder(),
                      labelText: 'Bulk Pack Price (₹)',
                      prefixIcon: Icon(Icons.inventory_2, size: 18),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    onChanged: (value) {
                      setState(() {
                        _persistedPackPrice = double.tryParse(value);
                        calculateSavings();
                      });
                    },
                  ),
                  _buildQuickButtons(
                    onIncrement: incrementPackPrice,
                    color: Colors.cyan,
                    increments: [-1000, -100, 100, 1000, 5000],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pack Quantity (Items)",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
                      ),
                      Text(
                        "${packQty.toInt()} Items",
                        style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                  Slider(
                    value: packQty.clamp(2.0, 144.0),
                    min: 2.0,
                    max: 144.0,
                    divisions: 142,
                    activeColor: primaryColor,
                    inactiveColor: primaryColor.withValues(alpha: 0.2),
                    onChanged: (val) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        packQty = val;
                        qtyController.text = val.toInt().toString();
                        _persistedPackQty = val;
                        calculateSavings();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (singlePriceController.text.isNotEmpty && packPriceController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: isSaving ? Colors.cyan.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSaving
                      ? (isDark ? Colors.cyan.withValues(alpha: 0.3) : Colors.cyan.withValues(alpha: 0.5))
                      : (isDark ? Colors.red.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.5)),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      isSaving ? 'Total Bulk Discount' : 'Cost Leak (Bulk costs more!)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSaving ? Colors.cyan.shade800 : Colors.red.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isSaving
                          ? '${helper.formatDouble(savingsPercent.abs())}% Saved'
                          : '${helper.formatDouble(savingsPercent.abs())}% Extra Cost',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: isSaving ? Colors.cyan.shade800 : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryCol('Equivalent Unit Price', '₹${helper.formatDouble(equivUnitPrice)}', isDark),
                        _buildSummaryCol('Savings / Unit', '₹${helper.formatDouble(savingsPerUnit)}', isDark),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryCol('Single Items Total', '₹${helper.formatDouble(singlePrice * packQty)}', isDark),
                        _buildSummaryCol('Net Savings', '₹${helper.formatDouble(totalSavings)}', isDark),
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
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.cyan : Colors.cyan.shade800)),
      ],
    );
  }
}
