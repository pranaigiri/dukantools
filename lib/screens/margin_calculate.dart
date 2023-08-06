import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gram_or_price/common/banner_ad.dart';
import 'package:gram_or_price/common/helper.dart';

class MarginCalculate extends StatefulWidget {
  const MarginCalculate({super.key});

  @override
  State<MarginCalculate> createState() => _MarginCalculateState();
}

enum MarginType { percent, amount }

class _MarginCalculateState extends State<MarginCalculate> {
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemQtyController = TextEditingController();
  TextEditingController itemMarginController = TextEditingController();

  double rawTotal = 0;
  double marginTotal = 0;

  MarginType? _marginType = MarginType.percent;

  final helper = Helper();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    itemPriceController.dispose();
    itemQtyController.dispose();
    itemMarginController.dispose();
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
                    'Item Details',
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
                          controller: itemPriceController,
                          decoration: const InputDecoration(
                            hintText: "Single Item Price",
                            border: OutlineInputBorder(),
                            labelText: 'Single Item Price',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'))
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              calculateRawAndMarginTotal();
                            } else {
                              setState(() {});
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
                          controller: itemQtyController,
                          decoration: const InputDecoration(
                            hintText: "Qty.",
                            border: OutlineInputBorder(),
                            labelText: 'Qty.',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              calculateRawAndMarginTotal();
                            } else {}
                          },
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: itemPriceController.text.isNotEmpty &&
                          itemQtyController.text.isNotEmpty,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Raw Total'),
                          Text(
                            helper.formatDouble(rawTotal),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Add Margin Details',
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
                                value: MarginType.percent,
                                groupValue: _marginType,
                                onChanged: (value) => setState(() {
                                  _marginType = value;
                                  calculateRawAndMarginTotal();
                                }),
                              ),
                              const Text("Percent"),
                              Radio(
                                value: MarginType.amount,
                                groupValue: _marginType,
                                onChanged: (value) => setState(() {
                                  _marginType = value;
                                  calculateRawAndMarginTotal();
                                }),
                              ),
                              const Text("Amount"),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: TextFormField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: false,
                                  ),
                                  controller: itemMarginController,
                                  decoration: InputDecoration(
                                    hintText: _marginType == MarginType.percent
                                        ? 'Percent'
                                        : 'Margin Per Item',
                                    border: const OutlineInputBorder(),
                                    labelText: _marginType == MarginType.percent
                                        ? 'Percent'
                                        : 'Margin Per Item',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'))
                                  ],
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      calculateRawAndMarginTotal();
                                    } else {
                                      setState(() {
                                        itemMarginController.clear();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                              visible: itemMarginController.text.isNotEmpty,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text('After adding margin'),
                                  Text(
                                    helper.formatDouble(marginTotal),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //CALCULATE RAW TOTAL
  void calculateRawAndMarginTotal() {
    double? tempPrice = double.tryParse(itemPriceController.text);
    double? tempQty = double.tryParse(itemQtyController.text);

    if (tempPrice != null && tempQty != null) {
      setState(() {
        rawTotal = tempPrice * tempQty;
      });

      if (itemMarginController.text.isNotEmpty) {
        double? tempMargin = double.tryParse(itemMarginController.text);

        setState(() {
          if (_marginType == MarginType.percent) {
            marginTotal = (rawTotal * tempMargin! / 100) + rawTotal;
          } else {
            marginTotal = (tempPrice + tempMargin!) * tempQty;
          }
        });
      }
    }
  }
}
