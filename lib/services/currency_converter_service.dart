import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exchange_rates_model.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterService {
  //test api response
  final staticApiResponse = {
    "success": true,
    "timestamp": 1690709404,
    "base": "EUR",
    "date": "2023-07-30",
    "rates": {
      "AED": 4.051944,
      "AFN": 93.916493,
      "ALL": 105.75101,
      "AMD": 426.202559,
      "ANG": 1.980383,
      "AOA": 909.742272,
      "ARS": 301.329707,
      "AUD": 1.659105,
      "AWG": 1.98565,
      "AZN": 1.879716,
      "BAM": 1.954894,
      "BBD": 2.218672,
      "BDT": 119.244759,
      "BGN": 1.957083,
      "BHD": 0.414208,
      "BIF": 3111.158737,
      "BMD": 1.103139,
      "BND": 1.463322,
      "BOB": 7.593482,
      "BRL": 5.219396,
      "BSD": 1.098891,
      "BTC": 3.7653432e-5,
      "BTN": 90.348146,
      "BWP": 14.364346,
      "BYN": 2.773615,
      "BYR": 21621.523702,
      "BZD": 2.214974,
      "CAD": 1.461715,
      "CDF": 2729.166197,
      "CHF": 0.959901,
      "CLF": 0.033073,
      "CLP": 912.34735,
      "CNY": 7.885573,
      "COP": 4346.986233,
      "CRC": 593.625,
      "CUC": 1.103139,
      "CUP": 29.233183,
      "CVE": 110.213943,
      "CZK": 24.015229,
      "DJF": 195.649364,
      "DKK": 7.461857,
      "DOP": 61.67143,
      "DZD": 149.772119,
      "EGP": 34.022239,
      "ERN": 16.547084,
      "ETB": 60.16063,
      "EUR": 1,
      "FJD": 2.447098,
      "FKP": 0.858601,
      "GBP": 0.858741,
      "GEL": 2.857561,
      "GGP": 0.858601,
      "GHS": 12.516202,
      "GIP": 0.858601,
      "GMD": 65.861647,
      "GNF": 9453.620555,
      "GTQ": 8.631002,
      "GYD": 230.073417,
      "HKD": 8.604209,
      "HNL": 27.041473,
      "HRK": 7.417351,
      "HTG": 150.540261,
      "HUF": 384.907675,
      "IDR": 16665.671905,
      "ILS": 4.085038,
      "IMP": 0.858601,
      "INR": 90.743936,
      "IQD": 1439.433174,
      "IRR": 46717.935531,
      "ISK": 145.096294,
      "JEP": 0.858601,
      "JMD": 169.771352,
      "JOD": 0.781137,
      "JPY": 155.702593,
      "KES": 156.257613,
      "KGS": 96.67789,
      "KHR": 4535.898718,
      "KMF": 492.335108,
      "KPW": 992.843445,
      "KRW": 1404.715518,
      "KWD": 0.338642,
      "KYD": 0.915676,
      "KZT": 489.343309,
      "LAK": 21257.152499,
      "LBP": 16493.559262,
      "LKR": 362.651999,
      "LRD": 205.184232,
      "LSL": 19.448761,
      "LTL": 3.257283,
      "LVL": 0.667278,
      "LYD": 5.232576,
      "MAD": 10.701343,
      "MDL": 19.417005,
      "MGA": 4953.705167,
      "MKD": 61.581472,
      "MMK": 2307.531023,
      "MNT": 3812.627776,
      "MOP": 8.826911,
      "MRO": 393.820421,
      "MUR": 50.527894,
      "MVR": 16.933601,
      "MWK": 1158.263428,
      "MXN": 18.410952,
      "MYR": 5.023148,
      "MZN": 69.773956,
      "NAD": 19.448756,
      "NGN": 855.793562,
      "NIO": 40.201376,
      "NOK": 11.249154,
      "NPR": 144.557033,
      "NZD": 1.789648,
      "OMR": 0.424751,
      "PAB": 1.098791,
      "PEN": 3.954868,
      "PGK": 3.942174,
      "PHP": 60.581125,
      "PKR": 314.735497,
      "PLN": 4.418454,
      "PYG": 8004.291965,
      "QAR": 4.016571,
      "RON": 4.938795,
      "RSD": 117.250683,
      "RUB": 101.555385,
      "RWF": 1313.091703,
      "SAR": 4.138116,
      "SBD": 9.208813,
      "SCR": 14.943163,
      "SDG": 663.542145,
      "SEK": 11.634161,
      "SGD": 1.468172,
      "SHP": 1.342245,
      "SLE": 23.127198,
      "SLL": 21786.99492,
      "SOS": 628.241683,
      "SRD": 42.390363,
      "STD": 22832.749334,
      "SVC": 9.614546,
      "SYP": 14514.996212,
      "SZL": 19.447991,
      "THB": 37.422928,
      "TJS": 12.026829,
      "TMT": 3.860986,
      "TND": 3.393811,
      "TOP": 2.592763,
      "TRY": 29.697498,
      "TTD": 7.465542,
      "TWD": 34.561127,
      "TZS": 2703.147751,
      "UAH": 40.5818,
      "UGX": 3972.159874,
      "USD": 1.103139,
      "UYU": 41.420812,
      "UZS": 12747.094833,
      "VEF": 3229158.540929,
      "VES": 32.287329,
      "VND": 26138.877761,
      "VUV": 130.013218,
      "WST": 2.959845,
      "XAF": 655.653265,
      "XAG": 0.045303,
      "XAU": 0.000563,
      "XCD": 2.981289,
      "XDR": 0.814623,
      "XOF": 655.653265,
      "XPF": 119.746136,
      "YER": 276.171241,
      "ZAR": 19.05281,
      "ZMK": 9929.578405,
      "ZMW": 20.410545,
      "ZWL": 355.210296
    }
  };
  List<Map<String, double>>? apiExchangeRates = [];

  Future<List<Map<String, double>>> getExchangeRates() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ExchangeRatesModel? newApiResponse;
    ExchangeRatesModel savedApiResponse;

    final savedData = prefs.getString("lastSavedApiResponse");

    if (savedData != null) {
      final prefData = json.decode(savedData);
      savedApiResponse = ExchangeRatesModel.fromJson(prefData);

      final DateTime savedTimestamp = DateTime.fromMillisecondsSinceEpoch(
          savedApiResponse.timestamp * 1000);

      final int daysDifference =
          DateTime.now().difference(savedTimestamp).inDays;

      if (daysDifference <= 30) {
        return getRatesFromResponse(savedApiResponse);
      }
    }

    newApiResponse = await fetchFromApi(); // Fetch new data from API

    if (newApiResponse != null) {
      return getRatesFromResponse(newApiResponse); // Return new data
    }

    // If fetching from API failed or no valid saved data, use default staticApiResponse
    return getRatesFromResponse(ExchangeRatesModel.fromJson(staticApiResponse));
  }

  Future<ExchangeRatesModel?> fetchFromApi() async {
    //fetch
    try {
      final http.Response response = await http.get(
          Uri.parse(
              "http://api.exchangeratesapi.io/v1/latest?access_key=d98ffb6de4fa5bddb1eec3363cc4f55e"),
          headers: null);
      if (response.statusCode == 200) {
        final parsed = await compute(jsonDecode, response.body);
        //save to shared preference
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("lastSavedApiResponse", json.encode(parsed));
        return ExchangeRatesModel.fromJson(parsed);
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  //RETURN RATES FROM EXCHANGE RATES RESPONSE
  List<Map<String, double>> getRatesFromResponse(ExchangeRatesModel res) {
    List<Map<String, double>> exchangeRates = [];
    for (var currency in res.rates.keys) {
      exchangeRates.add({currency: res.rates[currency]!});
    }
    return exchangeRates;
  }

  //RETURN TIMESTAMP OF SAVED EXCHANGE RATES
  Future<String> getSavedRatesLastUpdateDuration() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ExchangeRatesModel savedExchangeRates;
    if (prefs.getString("lastSavedApiResponse") != null) {
      final prefData =
          await json.decode(prefs.getString("lastSavedApiResponse")!);
      savedExchangeRates = ExchangeRatesModel.fromJson(prefData);
    } else {
      savedExchangeRates = ExchangeRatesModel.fromJson(staticApiResponse);
    }

    int timestamp = savedExchangeRates.timestamp;
    DateTime lastUpdated =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime now = DateTime.now();

    Duration difference = now.difference(lastUpdated);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just Now';
    }
  }
}
