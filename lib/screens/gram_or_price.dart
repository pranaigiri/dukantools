import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gram_or_price/common/banner_ad.dart';
import 'package:gram_or_price/common/helper.dart';

class GramOrPrice extends StatefulWidget {
  const GramOrPrice({super.key});

  @override
  State<GramOrPrice> createState() => _GramOrPriceState();
}

class _GramOrPriceState extends State<GramOrPrice> {
  var itemPriceController = TextEditingController();
  var itemGramController = TextEditingController();
  var itemCalculatedPriceController = TextEditingController();
  var itemCalculatedGramController = TextEditingController();

  final _helper = Helper();

  double? selectedPrice = 0;
  double? selectedGram = 0;
  double? calculatedPrice = 0;
  double? calculatedGram = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    itemPriceController.dispose();
    itemGramController.dispose();
    itemCalculatedGramController.dispose();
    itemCalculatedPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
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
                            hintText: "Item Price",
                            border: OutlineInputBorder(),
                            labelText: 'Item Price',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'))
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              selectedPrice = double.tryParse(value);
                              calculateGram();
                            } else {
                              setState(() {
                                itemCalculatedPriceController.clear();
                                itemCalculatedGramController.clear();
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
                          controller: itemGramController,
                          decoration: const InputDecoration(
                            hintText: "Gram (GM)",
                            border: OutlineInputBorder(),
                            labelText: 'Gram (GM)',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'))
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              selectedGram = double.tryParse(value);
                              calculatePrice();
                            } else {
                              setState(() {
                                itemCalculatedPriceController.clear();
                                itemCalculatedGramController.clear();
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
                      visible: itemPriceController.text.isNotEmpty &&
                          itemGramController.text.isNotEmpty,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const Text('Price per Gram(GM) : '),
                              Text(
                                _helper.formatDouble(pricePerGram),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Calculate',
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
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: false,
                                  ),
                                  controller: itemCalculatedPriceController,
                                  decoration: const InputDecoration(
                                    hintText: "Calc. Price",
                                    border: OutlineInputBorder(),
                                    labelText: 'Calc. Price',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'))
                                  ],
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      itemCalculatedGramController.clear();
                                    }
                                    if (value.isNotEmpty) {
                                      calculatedPrice = double.tryParse(value);
                                      calculateGram();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                child: Icon(
                                  Icons.multiple_stop_sharp,
                                  color: Colors.orange,
                                  size: 40,
                                ),
                              ),
                              Flexible(
                                child: TextFormField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: false,
                                  ),
                                  controller: itemCalculatedGramController,
                                  decoration: const InputDecoration(
                                    hintText: "Calc. Gram (GM)",
                                    border: OutlineInputBorder(),
                                    labelText: 'Calc. Gram (GM)',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'))
                                  ],
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      itemCalculatedPriceController.clear();
                                    }
                                    if (value.isNotEmpty) {
                                      calculatedGram = double.tryParse(value);
                                      calculatePrice();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
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

  calculateGram() {
    getPricePerGram();
    calculatedGram = (selectedGram! / selectedPrice!) * calculatedPrice!;
    itemCalculatedGramController.text = _helper.formatDouble(calculatedGram!);

    if (calculatedGram == 0) {
      setState(() {
        itemCalculatedGramController.clear();
        itemCalculatedPriceController.clear();
      });
    }
  }

  calculatePrice() {
    getPricePerGram();
    calculatedPrice = (selectedPrice! / selectedGram!) * calculatedGram!;
    itemCalculatedPriceController.text = _helper.formatDouble(calculatedGram!);

    if (calculatedPrice == 0) {
      setState(() {
        itemCalculatedGramController.clear();
        itemCalculatedPriceController.clear();
      });
    }
  }

  double pricePerGram = 0;
  getPricePerGram() {
    setState(() {
      pricePerGram = (selectedGram! / selectedPrice!);
    });
  }
}
