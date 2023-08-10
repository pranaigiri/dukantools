import 'package:flutter/material.dart';
import 'package:gram_or_price/models/item.dart';
import 'package:gram_or_price/screens/currency_convert.dart';
import 'package:gram_or_price/screens/emi_calculate.dart';
import 'package:gram_or_price/screens/gram_or_price.dart';
import 'package:gram_or_price/screens/interest_calculate.dart';
import 'package:gram_or_price/screens/margin_calculate.dart';
import 'package:gram_or_price/screens/percentage_discount.dart';
import 'package:gram_or_price/screens/profit_calculate.dart';
import 'package:gram_or_price/screens/weight_convert.dart';

const List<Item> itemData = [
  Item(
    id: 1,
    name: 'Gram or Price',
    iconData: Icons.change_circle,
    color: Colors.orange,
    widget: GramOrPrice(),
  ),
  Item(
    id: 2,
    name: 'Weight Convert',
    iconData: Icons.scale,
    color: Colors.redAccent,
    widget: WeightConvert(),
  ),
  Item(
    id: 3,
    name: 'EMI Calculate',
    iconData: Icons.add_chart_sharp,
    color: Colors.purple,
    widget: EmiCalculate(),
  ),
  Item(
    id: 4,
    name: 'Profit Calculate',
    iconData: Icons.trending_up_sharp,
    color: Colors.green,
    widget: ProfitCalculate(),
  ),
  Item(
    id: 5,
    name: 'Margin Calculate',
    iconData: Icons.difference_sharp,
    color: Colors.indigo,
    widget: MarginCalculate(),
  ),
  Item(
    id: 6,
    name: 'Interest Calculate',
    iconData: Icons.currency_rupee_rounded,
    color: Colors.lightBlue,
    widget: InterestCalculate(),
  ),
  Item(
    id: 7,
    name: 'Currency Convert',
    iconData: Icons.attach_money_rounded,
    color: Colors.lightGreen,
    widget: CurrencyConvert(),
  ),
  Item(
    id: 8,
    name: 'Percent Off',
    iconData: Icons.percent,
    color: Colors.amber,
    widget: PercentageDiscount(),
  )
  // Add more items as needed
];
