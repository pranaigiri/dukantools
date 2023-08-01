import 'dart:convert';

ExchangeRatesModel exchangeRatesModelFromJson(String str) =>
    ExchangeRatesModel.fromJson(json.decode(str));

String exchangeRatesModelToJson(ExchangeRatesModel data) =>
    json.encode(data.toJson());

class ExchangeRatesModel {
  bool success;
  int timestamp;
  String base;
  DateTime date;
  Map<String, double> rates;

  ExchangeRatesModel({
    required this.success,
    required this.timestamp,
    required this.base,
    required this.date,
    required this.rates,
  });

  factory ExchangeRatesModel.fromJson(Map<String, dynamic> json) =>
      ExchangeRatesModel(
        success: json["success"],
        timestamp: json["timestamp"],
        base: json["base"],
        date: DateTime.parse(json["date"]),
        rates: Map.from(json["rates"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "timestamp": timestamp,
        "base": base,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
