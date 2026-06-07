import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_tools/common/helper.dart';

class WeightConvert extends StatefulWidget {
  const WeightConvert({super.key});

  @override
  State<WeightConvert> createState() => _WeightConvertState();
}

const List<String> list = <String>['Mg', 'G', 'Kg', 'Tonne'];
const List<String> listFullName = <String>[
  'Milligram (Mg)',
  'Gram (G)',
  'Kilogram (Kg)',
  'Tonne (Tonne)'
];

const Map<String, Map<String, double>> conversionFactors = {
  'Mg': {'G': 0.001, 'Kg': 0.000001, 'Tonne': 0.000000001, 'Mg': 1},
  'G': {'Mg': 1000, 'Kg': 0.001, 'Tonne': 0.000001, 'G': 1},
  'Kg': {'Mg': 1000000, 'G': 1000, 'Tonne': 0.001, 'Kg': 1},
  'Tonne': {'Mg': 1000000000, 'G': 1000000, 'Kg': 1000, 'Tonne': 1},
};

final helper = Helper();

class _WeightConvertState extends State<WeightConvert> {
  // Static fields for state persistence
  static String? _persistedWeightX;
  static String? _persistedWeightY;
  static String? _persistedMxVal;
  static String? _persistedMyVal;

  String weightX = list.first;
  String weightY = list[1];

  final TextEditingController mxController = TextEditingController();
  final TextEditingController myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Restore state
    if (_persistedWeightX != null) weightX = _persistedWeightX!;
    if (_persistedWeightY != null) weightY = _persistedWeightY!;
    if (_persistedMxVal != null) mxController.text = _persistedMxVal!;
    if (_persistedMyVal != null) myController.text = _persistedMyVal!;
  }

  @override
  void dispose() {
    mxController.dispose();
    myController.dispose();
    super.dispose();
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      mxController.clear();
      myController.clear();
      _persistedMxVal = null;
      _persistedMyVal = null;
    });
  }

  void incrementX(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(mxController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      mxController.text = next == 0 ? "" : helper.formatDouble(next);
      _persistedMxVal = mxController.text;
      calculateY();
    });
  }

  void incrementY(double val) {
    HapticFeedback.lightImpact();
    double current = double.tryParse(myController.text) ?? 0;
    double next = (current + val).clamp(0.0, 99999999.0);
    setState(() {
      myController.text = next == 0 ? "" : helper.formatDouble(next);
      _persistedMyVal = myController.text;
      calculateX();
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

  Widget _buildUnitChips({
    required String selectedValue,
    required Function(String) onSelected,
    required Color color,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: list.map((unit) {
          final isSelected = selectedValue == unit;
          return Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: ChoiceChip(
              label: Text(
                unit,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : color,
                ),
              ),
              selected: isSelected,
              selectedColor: color,
              backgroundColor: color.withValues(alpha: 0.08),
              side: BorderSide(color: isSelected ? color : color.withValues(alpha: 0.3)),
              onSelected: (selected) {
                if (selected) {
                  HapticFeedback.lightImpact();
                  onSelected(unit);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight Converter',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (mxController.text.isNotEmpty || myController.text.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: Icon(Icons.refresh, size: 18, color: primaryColor),
                  label: Text('Reset', style: TextStyle(color: primaryColor)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Source Unit Card
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
                    "Source Unit",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
                  ),
                  const SizedBox(height: 6),
                  _buildUnitChips(
                    selectedValue: weightX,
                    color: primaryColor,
                    onSelected: (val) {
                      setState(() {
                        weightX = val;
                        _persistedWeightX = val;
                        if (mxController.text.isNotEmpty) {
                          calculateY();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    controller: mxController,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Enter value",
                      border: const OutlineInputBorder(),
                      labelText: listFullName[list.indexOf(weightX)],
                      suffixText: weightX,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,10}'))
                    ],
                    onChanged: (value) {
                      setState(() {
                        _persistedMxVal = value;
                        if (value.isNotEmpty) {
                          calculateY();
                        } else {
                          myController.clear();
                          _persistedMyVal = "";
                        }
                      });
                    },
                  ),
                  _buildQuickButtons(
                    onIncrement: incrementX,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Icon(
              Icons.swap_vert,
              color: Colors.redAccent,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          // Target Unit Card
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
                    "Target Unit",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800),
                  ),
                  const SizedBox(height: 6),
                  _buildUnitChips(
                    selectedValue: weightY,
                    color: Colors.blue,
                    onSelected: (val) {
                      setState(() {
                        weightY = val;
                        _persistedWeightY = val;
                        if (myController.text.isNotEmpty) {
                          calculateX();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    controller: myController,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Converted value",
                      border: const OutlineInputBorder(),
                      labelText: listFullName[list.indexOf(weightY)],
                      suffixText: weightY,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,10}'))
                    ],
                    onChanged: (value) {
                      setState(() {
                        _persistedMyVal = value;
                        if (value.isNotEmpty) {
                          calculateX();
                        } else {
                          mxController.clear();
                          _persistedMxVal = "";
                        }
                      });
                    },
                  ),
                  _buildQuickButtons(
                    onIncrement: incrementY,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void calculateY() {
    double? valueX = double.tryParse(mxController.text);
    if (valueX == null) return;
    if (weightX != weightY) {
      double? convFactor = conversionFactors[weightX]![weightY];
      if (convFactor != null) {
        double result = (valueX * convFactor).toDouble();
        setState(() {
          if (result > 1e+9 || result < 1e-6) {
            myController.text = result.toStringAsExponential(4);
          } else {
            myController.text = helper.formatDouble(result);
          }
          _persistedMyVal = myController.text;
        });
      }
    } else {
      setState(() {
        myController.text = mxController.text;
        _persistedMyVal = myController.text;
      });
    }
  }

  void calculateX() {
    double? valueY = double.tryParse(myController.text);
    if (valueY == null) return;
    if (weightX != weightY) {
      double? convFactor = conversionFactors[weightY]![weightX];
      if (convFactor != null) {
        double result = (valueY * convFactor).toDouble();
        setState(() {
          if (result > 1e+9 || result < 1e-6) {
            mxController.text = result.toStringAsExponential(4);
          } else {
            mxController.text = helper.formatDouble(result);
          }
          _persistedMxVal = mxController.text;
        });
      }
    } else {
      setState(() {
        mxController.text = myController.text;
        _persistedMxVal = mxController.text;
      });
    }
  }
}
