import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gram_or_price/common/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exchange_rates_model.dart';
import 'package:gram_or_price/services/currency_converter_service.dart';

class CurrencyConvert extends StatefulWidget {
  const CurrencyConvert({super.key});

  @override
  State<CurrencyConvert> createState() => _CurrencyConvertState();
}

List<Map<String, double>> currencies = [];

class _CurrencyConvertState extends State<CurrencyConvert> {
  String? currencyA = "INR";
  String? currencyB = "USD";

  final TextEditingController caController = TextEditingController();
  final TextEditingController cbController = TextEditingController();

  final _helper = Helper();
  final _currencyConvertService = CurrencyConverterService();

  @override
  void initState() {
    super.initState();
    currencies = _currencyConvertService.getRatesFromResponse(
        ExchangeRatesModel.fromJson(_currencyConvertService.staticApiResponse));

    updateExchangeRates();

    //Select last used dropdown
    getDropdownA();
    getDropdownB();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    caController.dispose();
    cbController.dispose();
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
            'Currency Converter',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey.shade700,
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
                  controller: caController,
                  decoration: InputDecoration(
                    hintText: currencyA,
                    border: const OutlineInputBorder(),
                    labelText: currencyA,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,10}'))
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      calculateB();
                    } else {
                      cbController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              //DROPDOWN - A
              Flexible(
                flex: 1,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: currencies.any((e) => e.keys.first == currencyA)
                      ? currencyA!
                      : currencies[0].keys.first,
                  elevation: 16,
                  onChanged: (String? value) async {
                    setState(() {
                      currencyA = value!;
                    });

                    if (caController.text.isNotEmpty) {
                      calculateB();
                    }
                    await saveDropdownA();
                  },
                  items: currencies.map<DropdownMenuItem<String>>(
                      (Map<String, double> currency) {
                    String currencyName = currency.keys.first;
                    return DropdownMenuItem<String>(
                      value: currencyName,
                      child: Text(currencyName),
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
                  controller: cbController,
                  decoration: InputDecoration(
                    hintText: currencyB,
                    border: const OutlineInputBorder(),
                    labelText: currencyB,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,10}'))
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      calculateA();
                    } else {
                      caController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              //DROPDOWN - B
              Flexible(
                flex: 1,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: currencies.any((e) => e.keys.first == currencyB)
                      ? currencyB!
                      : currencies[1].keys.first,
                  elevation: 16,
                  onChanged: (String? value) async {
                    setState(() {
                      currencyB = value!;
                    });
                    if (cbController.text.isNotEmpty) {
                      calculateA();
                    }

                    await saveDropdownB();
                  },
                  items: currencies.map<DropdownMenuItem<String>>(
                      (Map<String, double> currency) {
                    String currencyName = currency.keys.first;
                    return DropdownMenuItem<String>(
                      value: currencyName,
                      child: Text(currencyName),
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
            '(Rates)',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w100),
          ),
          FutureBuilder<String?>(
            future: _currencyConvertService.getNextUpdateDuration(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // If the future is still waiting, display a loading indicator or some placeholder text
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              } else if (snapshot.hasError) {
                // If there was an error while getting the duration, display an error message
                return const Text(
                  'N/A',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                  ),
                );
              } else {
                // If the future has completed successfully, display the formatted duration
                return Text(
                  snapshot.data.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                  ),
                );
              }
            },
          ),
          // ElevatedButton(
          //     onPressed: updateExchangeRates, child: const Text("Update Rates"))
        ],
      ),
    );
  }

// ---------------------------------------------------------- HELPER METHODS -------------------------------------------------

  double caRate = 0;
  double cbRate = 0;
  void initValues() {
    for (var currency in currencies) {
      if (currency.keys.first == currencyA) {
        caRate = currency.values.first;
      }
      if (currency.keys.first == currencyB) {
        cbRate = currency.values.first;
      }
    }
  }

  void calculateA() {
    initValues();
    double tempCbValue = double.tryParse(cbController.text)!;
    double? caVal = (caRate / cbRate) * tempCbValue;
    caController.text = _helper.formatDouble(caVal);
  }

  void calculateB() {
    initValues();
    double tempCaValue = double.tryParse(caController.text)!;
    double? cbVal = (cbRate / caRate) * tempCaValue;
    cbController.text = _helper.formatDouble(cbVal);
  }

  Future<void> updateExchangeRates() async {
    _currencyConvertService.getExchangeRates().then((value) => {
          setState(() {
            currencies = value;
          })
        });
  }

  Future<void> getDropdownA() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dropdownA = prefs.getString("dropdownA");

    if (dropdownA != null) {
      setState(() {
        currencyA = dropdownA;
      });
    }
  }

  Future<void> getDropdownB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dropdownB = prefs.getString("dropdownB");
    if (dropdownB != null) {
      setState(() {
        currencyB = dropdownB;
      });
    }
  }

  Future<void> saveDropdownA() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("dropdownA", currencyA!);
  }

  Future<void> saveDropdownB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("dropdownB", currencyB!);
  }
}
