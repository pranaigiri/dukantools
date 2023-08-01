import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gram_or_price/common/helper.dart';

class PercentageDiscount extends StatefulWidget {
  const PercentageDiscount({super.key});

  @override
  State<PercentageDiscount> createState() => _PercentageDiscountState();
}

class _PercentageDiscountState extends State<PercentageDiscount> {
  var helper = Helper();

  //DEFINE CONTROLLERS
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();

  double afterOff = 0.00;
  double remAmount = 0.00;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _amountController.dispose();
    _percentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Text(
            'Calculate Discount',
            style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 24,
                fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  controller: _amountController,
                  decoration: const InputDecoration(
                    hintText: "Amount",
                    border: OutlineInputBorder(),
                    labelText: 'Amount',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      calculatePercentage();
                    } else {
                      setState(() {
                        afterOff = 0;
                        remAmount = 0;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  controller: _percentController,
                  decoration: const InputDecoration(
                    hintText: "Percent (%)",
                    border: OutlineInputBorder(),
                    labelText: 'Percent (%)',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      calculatePercentage();
                    } else {
                      setState(() {
                        afterOff = 0;
                        remAmount = 0;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Visibility(
            visible: _amountController.text.isNotEmpty &&
                _percentController.text.isNotEmpty,
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'After ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: '${_percentController.text}%',
                        style: const TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text: ' discount',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  helper.formatDouble(remAmount),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Remaining'),
                Text(
                  helper.formatDouble(afterOff),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
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
}
