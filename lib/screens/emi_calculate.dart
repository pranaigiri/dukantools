import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmiCalculate extends StatefulWidget {
  const EmiCalculate({super.key});

  @override
  State<EmiCalculate> createState() => _EmiCalculateState();
}

class _EmiCalculateState extends State<EmiCalculate> {
  // Static variables for state persistence
  static double? _persistedAmount;
  static double? _persistedTenure;
  static double? _persistedInterest;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();
  final TextEditingController interestController = TextEditingController();

  int yourEmi = 0;
  double totalInterest = 0;
  double totalPayable = 0;

  @override
  void initState() {
    super.initState();
    // Restore state
    if (_persistedAmount != null) {
      amountController.text = _persistedAmount!.toInt().toString();
    }
    if (_persistedTenure != null) {
      tenureController.text = _persistedTenure!.toInt().toString();
    }
    if (_persistedInterest != null) {
      interestController.text = _persistedInterest!.toString();
    }
    calculateEmi();
  }

  @override
  void dispose() {
    amountController.dispose();
    tenureController.dispose();
    interestController.dispose();
    super.dispose();
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      amountController.clear();
      tenureController.clear();
      interestController.clear();
      yourEmi = 0;
      totalInterest = 0;
      totalPayable = 0;
      _persistedAmount = null;
      _persistedTenure = null;
      _persistedInterest = null;
    });
  }

  void calculateEmi() {
    double? tempAmount = double.tryParse(amountController.text);
    double? tempTenure = double.tryParse(tenureController.text);
    double? tempInterest = double.tryParse(interestController.text);

    if (tempAmount != null && tempTenure != null && tempInterest != null && tempTenure > 0) {
      double calculatedInterestVal = (tempAmount * tempInterest) / 100;
      double calculatedPayableVal = tempAmount + calculatedInterestVal;

      setState(() {
        totalInterest = calculatedInterestVal;
        totalPayable = calculatedPayableVal;
        yourEmi = (calculatedPayableVal / tempTenure).round();
      });
    } else {
      setState(() {
        yourEmi = 0;
        totalInterest = 0;
        totalPayable = 0;
      });
    }
  }

  void incrementAmount(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(amountController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      amountController.text = next == 0 ? "" : next.toInt().toString();
      _persistedAmount = next;
      calculateEmi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.purple;

    // Get current values safely for sliders
    double currentInterest = double.tryParse(interestController.text) ?? 0.0;
    double currentTenure = double.tryParse(tenureController.text) ?? 1.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EMI Calculator',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (amountController.text.isNotEmpty ||
                  tenureController.text.isNotEmpty ||
                  interestController.text.isNotEmpty)
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
                      decimal: false,
                      signed: false,
                    ),
                    controller: amountController,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: "Enter Loan Amount",
                      border: OutlineInputBorder(),
                      labelText: 'Loan Amount (₹)',
                      prefixIcon: Icon(Icons.currency_rupee, size: 18),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        _persistedAmount = double.tryParse(value);
                        calculateEmi();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 38,
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [-50000, -10000, -5000, 5000, 10000, 50000].map((val) {
                        final sign = val > 0 ? "+" : "";
                        final label = "$sign${(val.abs() >= 1000 ? '${(val / 1000).toInt()}k' : val.toInt())}";
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
                                  label,
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
                  // Interest Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Interest Rate (%)",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
                      ),
                      Text(
                        "${currentInterest.toStringAsFixed(1)} %",
                        style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                  Slider(
                    value: currentInterest.clamp(0.0, 50.0),
                    min: 0.0,
                    max: 50.0,
                    divisions: 100,
                    activeColor: primaryColor,
                    inactiveColor: primaryColor.withValues(alpha: 0.2),
                    onChanged: (val) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        interestController.text = val.toStringAsFixed(1);
                        _persistedInterest = val;
                        calculateEmi();
                      });
                    },
                  ),
                  // Tenure Slider
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tenure (Months)",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
                      ),
                      Text(
                        "${currentTenure.toInt()} Months",
                        style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                  Slider(
                    value: currentTenure.clamp(1.0, 60.0),
                    min: 1.0,
                    max: 60.0,
                    divisions: 59,
                    activeColor: primaryColor,
                    inactiveColor: primaryColor.withValues(alpha: 0.2),
                    onChanged: (val) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        tenureController.text = val.toInt().toString();
                        _persistedTenure = val;
                        calculateEmi();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (yourEmi > 0) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Colors.red.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: isDark ? Colors.red.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Monthly EMI Amount',
                      style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹$yourEmi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: isDark ? Colors.red.shade300 : Colors.red.shade800,
                      ),
                    ),
                    Text(
                      'per month',
                      style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryCol('Principal', '₹${double.tryParse(amountController.text)?.toInt() ?? 0}', isDark),
                        _buildSummaryCol('Total Interest', '₹${totalInterest.toInt()}', isDark),
                        _buildSummaryCol('Total Payable', '₹${totalPayable.toInt()}', isDark),
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
