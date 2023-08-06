import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gram_or_price/common/banner_ad.dart';
import 'package:gram_or_price/common/helper.dart';

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
  String weightX = list.first;
  String weightY = list[1];

  final TextEditingController mxController = TextEditingController();
  final TextEditingController myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    mxController.dispose();
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Weight Converter',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 24,
                fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  controller: mxController,
                  decoration: InputDecoration(
                    hintText: listFullName[list.indexOf(weightX)],
                    border: const OutlineInputBorder(),
                    labelText: listFullName[list.indexOf(weightX)],
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,10}'))
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      calculateY();
                    } else {
                      myController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 1,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: weightX,
                  elevation: 16,
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      weightX = value!;
                    });
                    if (mxController.text.isNotEmpty) {
                      calculateY();
                    }
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  controller: myController,
                  decoration: InputDecoration(
                    hintText: listFullName[list.indexOf(weightY)],
                    border: const OutlineInputBorder(),
                    labelText: listFullName[list.indexOf(weightY)],
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,10}'))
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      calculateX();
                    } else {
                      mxController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 1,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: weightY,
                  elevation: 16,
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      weightY = value!;
                    });
                    if (myController.text.isNotEmpty) {
                      calculateX();
                    }
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            '1e+10 means 10 0\'s after 1, That is 10000000000. There could be any number in place of 10.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }

  void calculateY() {
    double? valueX = double.tryParse(mxController.text);
    if (weightX != weightY && valueX != null) {
      double? convFactor = conversionFactors[weightX]![weightY];
      if (convFactor != null) {
        double? result = (valueX * convFactor).toDouble();

        if (result > 1e+9 || result < 1e-6) {
          myController.text = result.toStringAsExponential(0);
        } else {
          myController.text = helper.formatDouble(result);
        }
      }
    } else {
      myController.text = mxController.text;
    }
  }

  void calculateX() {
    double? valueY = double.tryParse(myController.text);
    if (weightX != weightY && valueY != null) {
      double? convFactor = conversionFactors[weightY]![weightX];
      if (convFactor != null) {
        double? result = (valueY * convFactor).toDouble();

        if (result > 1e+9 || result < 1e-6) {
          mxController.text = result.toStringAsExponential(0);
        } else {
          mxController.text = helper.formatDouble(result);
        }
      }
    } else {
      mxController.text = myController.text;
    }
  }
}
