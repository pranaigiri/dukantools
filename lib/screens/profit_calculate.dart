import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gram_or_price/common/banner_ad.dart';
import 'package:gram_or_price/common/helper.dart';

class ProfitCalculate extends StatefulWidget {
  const ProfitCalculate({super.key});

  @override
  State<ProfitCalculate> createState() => _ProfitCalculateState();
}

class _ProfitCalculateState extends State<ProfitCalculate> {
  final TextEditingController buyController = TextEditingController();
  final TextEditingController sellController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  double yourProfit = 0;

  final helper = Helper();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    buyController.dispose();
    sellController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text(
            'Add Buy / Sell Price',
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
                  controller: buyController,
                  decoration: const InputDecoration(
                    hintText: "Buy Price",
                    border: OutlineInputBorder(),
                    labelText: 'Buy Price',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      calculateBuySell();
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
                  controller: sellController,
                  decoration: const InputDecoration(
                    hintText: "Sell Price",
                    border: OutlineInputBorder(),
                    labelText: 'Sell Price',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      calculateBuySell();
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
          TextFormField(
            keyboardType: const TextInputType.numberWithOptions(
              decimal: false,
              signed: false,
            ),
            controller: qtyController,
            decoration: const InputDecoration(
              hintText: "Qty (Optional)",
              border: OutlineInputBorder(),
              labelText: 'Qty (Optional)',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            ],
            onChanged: (value) {
              if (value.isNotEmpty) {
                calculateBuySell();
              } else {
                setState(() {
                  // afterOff = 0;
                  // remAmount = 0;
                });
              }
            },
          ),
          Visibility(
            visible:
                buyController.text.isNotEmpty && sellController.text.isNotEmpty,
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'You have ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: '20%',
                        style: TextStyle(
                            color: yourProfit < 0 ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' of ${yourProfit < 0 ? "Loss" : "Profit"}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  helper.formatDouble(yourProfit),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void calculateBuySell() {
    double? buyPrice = double.tryParse(buyController.text);
    double? sellPrice = double.tryParse(sellController.text);
    double? qty = double.tryParse(qtyController.text);

    if (buyPrice != null && sellPrice != null) {
      setState(() {
        yourProfit = sellPrice - buyPrice;
        qty != null ? yourProfit = yourProfit * qty : null;
      });
    }
  }
}
