import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_tools/common/helper.dart';

class InterestCalculate extends StatefulWidget {
  const InterestCalculate({super.key});

  @override
  State<InterestCalculate> createState() => _InterestCalculateState();
}

enum InterestType { add, sub }

class _InterestCalculateState extends State<InterestCalculate> {
  // Static variables for state persistence
  static double? _persistedAmount;
  static double? _persistedPercent;
  static InterestType _persistedInterestType = InterestType.add;

  InterestType _interestType = InterestType.add;
  final helper = Helper();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController percentController = TextEditingController();

  double calculatedAmount = 0;
  double calculatedInterest = 0;

  @override
  void initState() {
    super.initState();
    // Restore state
    _interestType = _persistedInterestType;
    if (_persistedAmount != null) {
      amountController.text = helper.formatDouble(_persistedAmount!);
    }
    if (_persistedPercent != null) {
      percentController.text = _persistedPercent!.toStringAsFixed(1);
    }
    calculateInterest();
  }

  @override
  void dispose() {
    amountController.dispose();
    percentController.dispose();
    super.dispose();
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      amountController.clear();
      percentController.clear();
      calculatedAmount = 0;
      calculatedInterest = 0;
      _persistedAmount = null;
      _persistedPercent = null;
    });
  }

  void calculateInterest() {
    double? tempAmount = double.tryParse(amountController.text);
    double? tempPercent = double.tryParse(percentController.text);
    double tempCalculatedAmount = 0;
    double tempCalculatedInterest = 0;

    if (tempAmount != null && tempPercent != null) {
      if (_interestType == InterestType.add) {
        tempCalculatedAmount = tempAmount + (tempAmount * tempPercent / 100);
        tempCalculatedInterest = tempCalculatedAmount - tempAmount;
      } else {
        tempCalculatedAmount = tempAmount - (tempAmount * tempPercent / 100);
        tempCalculatedInterest = tempAmount - tempCalculatedAmount;
      }
    }
    setState(() {
      calculatedAmount = tempCalculatedAmount;
      calculatedInterest = tempCalculatedInterest;
    });
  }

  void incrementAmount(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(amountController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      amountController.text = next == 0 ? "" : helper.formatDouble(next);
      _persistedAmount = next;
      calculateInterest();
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
    final primaryColor = Colors.lightBlue;
    final isAdd = _interestType == InterestType.add;

    double currentPercent = double.tryParse(percentController.text) ?? 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Interest Calculator',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (amountController.text.isNotEmpty || percentController.text.isNotEmpty)
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
                    'Interest Type',
                    style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(
                            child: Text(
                              "Add (+)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          selected: _interestType == InterestType.add,
                          selectedColor: Colors.green,
                          labelStyle: TextStyle(
                            color: _interestType == InterestType.add ? Colors.white : Colors.green,
                          ),
                          backgroundColor: Colors.green.withValues(alpha: 0.08),
                          side: BorderSide(color: _interestType == InterestType.add ? Colors.green : Colors.green.withValues(alpha: 0.3)),
                          onSelected: (selected) {
                            if (selected) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _interestType = InterestType.add;
                                _persistedInterestType = InterestType.add;
                                calculateInterest();
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
                              "Subtract (-)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          selected: _interestType == InterestType.sub,
                          selectedColor: Colors.red,
                          labelStyle: TextStyle(
                            color: _interestType == InterestType.sub ? Colors.white : Colors.red,
                          ),
                          backgroundColor: Colors.red.withValues(alpha: 0.08),
                          side: BorderSide(color: _interestType == InterestType.sub ? Colors.red : Colors.red.withValues(alpha: 0.3)),
                          onSelected: (selected) {
                            if (selected) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _interestType = InterestType.sub;
                                _persistedInterestType = InterestType.sub;
                                calculateInterest();
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
                    decoration: const InputDecoration(
                      hintText: "Enter Principal Amount",
                      border: OutlineInputBorder(),
                      labelText: 'Principal Amount (₹)',
                      prefixIcon: Icon(Icons.currency_rupee, size: 18),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    onChanged: (value) {
                      setState(() {
                        _persistedAmount = double.tryParse(value);
                        calculateInterest();
                      });
                    },
                  ),
                  _buildQuickButtons(
                    onIncrement: incrementAmount,
                    color: primaryColor,
                    increments: [-10000, -1000, 1000, 10000, 50000],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Interest Rate (%)",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
                      ),
                      Text(
                        "${currentPercent.toStringAsFixed(1)} %",
                        style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                  Slider(
                    value: currentPercent.clamp(0.0, 100.0),
                    min: 0.0,
                    max: 100.0,
                    divisions: 200,
                    activeColor: primaryColor,
                    inactiveColor: primaryColor.withValues(alpha: 0.2),
                    onChanged: (val) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        percentController.text = val.toStringAsFixed(1);
                        _persistedPercent = val;
                        calculateInterest();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (amountController.text.isNotEmpty && percentController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: isAdd ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isAdd
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
                      isAdd ? 'Total Amount (After Interest)' : 'Total Amount (Before Interest)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isAdd ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${helper.formatDouble(calculatedAmount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: isAdd
                            ? (isDark ? Colors.green.shade300 : Colors.green.shade800)
                            : (isDark ? Colors.red.shade300 : Colors.red.shade800),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryCol('Principal', '₹${helper.formatDouble(double.tryParse(amountController.text) ?? 0)}', isAdd, isDark),
                        _buildSummaryCol(isAdd ? 'Interest Added' : 'Interest Deducted', '₹${helper.formatDouble(calculatedInterest)}', isAdd, isDark),
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

  Widget _buildSummaryCol(String label, String val, bool isAdd, bool isDark) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 12)),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: isAdd
              ? (isDark ? Colors.green.shade300 : Colors.green.shade800)
              : (isDark ? Colors.red.shade300 : Colors.red.shade800),
        )),
      ],
    );
  }
}
