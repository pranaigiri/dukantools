import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gram_or_price/common/helper.dart';

class InterestCalculate extends StatefulWidget {
  const InterestCalculate({super.key});

  @override
  State<InterestCalculate> createState() => _InterestCalculateState();
}

enum InterestType { add, sub }

class _InterestCalculateState extends State<InterestCalculate> {
  InterestType? _interestType = InterestType.add;

  var helper = Helper();

  //DEFINE CONTROLLERS
  final TextEditingController amountController = TextEditingController();
  final TextEditingController percentController = TextEditingController();

  double calculatedAmount = 0;
  double calculatedInterest = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    amountController.dispose();
    percentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text(
            'Calculate Interest',
            style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 24,
                fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: InterestType.add,
                groupValue: _interestType,
                onChanged: (value) => setState(() {
                  _interestType = value;
                  calculateInterest();
                }),
              ),
              const Text("Add"),
              Radio(
                value: InterestType.sub,
                groupValue: _interestType,
                onChanged: (value) => setState(() {
                  _interestType = value;
                  calculateInterest();
                }),
              ),
              const Text("Subtract"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  controller: amountController,
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
                      calculateInterest();
                    } else {
                      setState(() {
                        amountController.clear();
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
                    decimal: true,
                    signed: false,
                  ),
                  controller: percentController,
                  decoration: const InputDecoration(
                    hintText: "Interest Rate (%)",
                    border: OutlineInputBorder(),
                    labelText: 'Interest Rate (%)',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      calculateInterest();
                    } else {
                      setState(() {
                        percentController.clear();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          Visibility(
            visible: (amountController.text.isNotEmpty &&
                percentController.text.isNotEmpty),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${_interestType == InterestType.add ? 'Adding' : 'Subtracting'} ',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: '${percentController.text}%',
                        style: TextStyle(
                            color: _interestType == InterestType.add
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ' ${_interestType == InterestType.add ? 'to' : 'from'} ${amountController.text} ',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  helper.formatDouble(calculatedAmount),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Interest Amount"),
                Text(
                  helper.formatDouble(calculatedInterest),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void calculateInterest() {
    double? tempAmount = double.tryParse(amountController.text);
    double? tempPercent = double.tryParse(percentController.text);
    double? tempCalculatedAmount = 0;
    double? tempCalculatedInterest = 0;

    if (tempAmount != null && tempPercent != null) {
      if (_interestType == InterestType.add) {
        tempCalculatedAmount = tempAmount + (tempAmount * tempPercent / 100);
      } else {
        tempCalculatedAmount = tempAmount - (tempAmount * tempPercent / 100);
      }
      tempCalculatedInterest = tempCalculatedAmount - tempAmount;
    }
    setState(() {
      calculatedAmount = tempCalculatedAmount!;
      calculatedInterest = tempCalculatedInterest!;
    });
  }
}
