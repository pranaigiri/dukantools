import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gram_or_price/common/banner_ad.dart';

class EmiCalculate extends StatefulWidget {
  const EmiCalculate({super.key});

  @override
  State<EmiCalculate> createState() => _EmiCalculateState();
}

class _EmiCalculateState extends State<EmiCalculate> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();
  final TextEditingController interestController = TextEditingController();

  int yourEmi = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    amountController.dispose();
    tenureController.dispose();
    interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Text(
                    'Calculate EMI',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 24,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    controller: amountController,
                    decoration: const InputDecoration(
                      hintText: "Amount",
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        calculateEmi();
                      } else {
                        setState(() {
                          // afterOff = 0;
                          // remAmount = 0;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          controller: tenureController,
                          decoration: const InputDecoration(
                            hintText: "Tenure in Months",
                            border: OutlineInputBorder(),
                            labelText: 'Tenure in Months',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              calculateEmi();
                            } else {
                              setState(() {
                                // afterOff = 0;
                                // remAmount = 0;
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
                          controller: interestController,
                          decoration: const InputDecoration(
                            hintText: "Interest Rate(%)",
                            border: OutlineInputBorder(),
                            labelText: 'Interest Rate(%)',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'))
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              calculateEmi();
                            } else {
                              setState(() {
                                // afterOff = 0;
                                // remAmount = 0;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: amountController.text.isNotEmpty &&
                        tenureController.text.isNotEmpty &&
                        interestController.text.isNotEmpty,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'You EMI ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              // TextSpan(
                              //   text: '20%',
                              //   style: TextStyle(
                              //       color: yourProfit < 0 ? Colors.red : Colors.green,
                              //       fontWeight: FontWeight.bold),
                              // ),
                              // TextSpan(
                              //   text: ' of ${yourProfit < 0 ? "Loss" : "Profit"}',
                              //   style: const TextStyle(color: Colors.black),
                              // ),
                            ],
                          ),
                        ),
                        Text(
                          yourEmi.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        const Text('per month')
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void calculateEmi() {
    double? tempAmount = double.tryParse(amountController.text);
    double? tempTenure = double.tryParse(tenureController.text);
    double? tempInterest = double.tryParse(interestController.text);

    if (tempAmount != null && tempTenure != null && tempInterest != null) {
      double? tempAmountWithInterest =
          tempAmount + ((tempAmount * tempInterest) / 100);

      setState(() {
        yourEmi = (tempAmountWithInterest / tempTenure).round();
      });
    }
  }
}
