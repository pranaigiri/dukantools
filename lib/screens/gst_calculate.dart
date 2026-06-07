import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_tools/common/helper.dart';

class GstCalculate extends StatefulWidget {
  const GstCalculate({super.key});

  @override
  State<GstCalculate> createState() => _GstCalculateState();
}

enum GstType { exclusive, inclusive }

class _GstCalculateState extends State<GstCalculate> {
  // Static fields for state persistence
  static double? _persistedAmount;
  static double? _persistedGstRate;
  static GstType _persistedGstType = GstType.exclusive;

  final TextEditingController amountController = TextEditingController();
  final helper = Helper();

  GstType _gstType = GstType.exclusive;
  double gstRate = 18.0;

  double baseAmount = 0;
  double gstAmount = 0;
  double cgst = 0;
  double sgst = 0;
  double totalAmount = 0;

  final List<double> taxSlabs = [5.0, 12.0, 18.0, 28.0];

  @override
  void initState() {
    super.initState();
    // Restore state
    _gstType = _persistedGstType;
    if (_persistedGstRate != null) {
      gstRate = _persistedGstRate!;
    }
    if (_persistedAmount != null) {
      amountController.text = helper.formatDouble(_persistedAmount!);
    }
    calculateGst();
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      amountController.clear();
      baseAmount = 0;
      gstAmount = 0;
      cgst = 0;
      sgst = 0;
      totalAmount = 0;
      _persistedAmount = null;
    });
  }

  void calculateGst() {
    double? amount = double.tryParse(amountController.text);
    if (amount == null || amount == 0) {
      setState(() {
        baseAmount = 0;
        gstAmount = 0;
        cgst = 0;
        sgst = 0;
        totalAmount = 0;
      });
      return;
    }

    setState(() {
      if (_gstType == GstType.exclusive) {
        // Exclusive of Tax: Amount is Base Price
        baseAmount = amount;
        gstAmount = (baseAmount * gstRate) / 100;
        totalAmount = baseAmount + gstAmount;
      } else {
        // Inclusive of Tax: Amount is Total Price
        totalAmount = amount;
        baseAmount = totalAmount / (1 + (gstRate / 100));
        gstAmount = totalAmount - baseAmount;
      }
      cgst = gstAmount / 2;
      sgst = gstAmount / 2;
    });
  }

  void incrementAmount(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(amountController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      amountController.text = next == 0 ? "" : helper.formatDouble(next);
      _persistedAmount = next;
      calculateGst();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.teal;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GST Tax Calculator',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (amountController.text.isNotEmpty)
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
                  Text(
                    'Calculation Type',
                    style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(
                            child: Text(
                              "Exclusive (Add GST)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          selected: _gstType == GstType.exclusive,
                          selectedColor: primaryColor,
                          labelStyle: TextStyle(
                            color: _gstType == GstType.exclusive ? Colors.white : primaryColor,
                          ),
                          backgroundColor: primaryColor.withValues(alpha: 0.08),
                          side: BorderSide(color: _gstType == GstType.exclusive ? primaryColor : primaryColor.withValues(alpha: 0.3)),
                          onSelected: (selected) {
                            if (selected) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _gstType = GstType.exclusive;
                                _persistedGstType = GstType.exclusive;
                                calculateGst();
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
                              "Inclusive (Split GST)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          selected: _gstType == GstType.inclusive,
                          selectedColor: primaryColor,
                          labelStyle: TextStyle(
                            color: _gstType == GstType.inclusive ? Colors.white : primaryColor,
                          ),
                          backgroundColor: primaryColor.withValues(alpha: 0.08),
                          side: BorderSide(color: _gstType == GstType.inclusive ? primaryColor : primaryColor.withValues(alpha: 0.3)),
                          onSelected: (selected) {
                            if (selected) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _gstType = GstType.inclusive;
                                _persistedGstType = GstType.inclusive;
                                calculateGst();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    controller: amountController,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Enter amount",
                      border: const OutlineInputBorder(),
                      labelText: _gstType == GstType.exclusive ? 'Base Amount (₹)' : 'Total Amount (₹)',
                      prefixIcon: const Icon(Icons.currency_rupee, size: 18),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    onChanged: (value) {
                      setState(() {
                        _persistedAmount = double.tryParse(value);
                        calculateGst();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 38,
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [-500, -100, 100, 500, 1000, 5000].map((val) {
                        final sign = val > 0 ? "+" : "";
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: Material(
                            color: primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () => incrementAmount(val.toDouble()),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "$sign${val.toInt()}",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  // GST Slab Quick-Select Chips
                  Text(
                    "Standard GST Slabs",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: taxSlabs.map((slab) {
                        final isSelected = gstRate == slab;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: ChoiceChip(
                            label: Text(
                              "${slab.toInt()}%",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : primaryColor,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: primaryColor,
                            backgroundColor: primaryColor.withValues(alpha: 0.08),
                            side: BorderSide(color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.3)),
                            onSelected: (selected) {
                              if (selected) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  gstRate = slab;
                                  _persistedGstRate = slab;
                                  calculateGst();
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Custom Tax Rate (%)",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
                      ),
                      Text(
                        "${gstRate.toStringAsFixed(1)} %",
                        style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                  Slider(
                    value: gstRate.clamp(0.0, 50.0),
                    min: 0.0,
                    max: 50.0,
                    divisions: 100,
                    activeColor: primaryColor,
                    inactiveColor: primaryColor.withValues(alpha: 0.2),
                    onChanged: (val) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        gstRate = val;
                        _persistedGstRate = val;
                        calculateGst();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (amountController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Colors.teal.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: isDark ? Colors.teal.withValues(alpha: 0.3) : Colors.teal.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      _gstType == GstType.exclusive ? 'Total Price (Base + GST)' : 'Base Price (Excl. GST)',
                      style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${helper.formatDouble(_gstType == GstType.exclusive ? totalAmount : baseAmount)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryCol('Base Price', '₹${helper.formatDouble(baseAmount)}', isDark),
                        _buildSummaryCol('Total GST (${gstRate.toStringAsFixed(1)}%)', '₹${helper.formatDouble(gstAmount)}', isDark),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryCol('CGST (Central Tax)', '₹${helper.formatDouble(cgst)}', isDark),
                        _buildSummaryCol('SGST (State Tax)', '₹${helper.formatDouble(sgst)}', isDark),
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
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.teal : Colors.teal.shade800)),
      ],
    );
  }
}
