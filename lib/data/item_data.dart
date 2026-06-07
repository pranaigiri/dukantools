import 'package:flutter/material.dart';
import 'package:dukan_tools/models/item.dart';
import 'package:dukan_tools/screens/currency_convert.dart';
import 'package:dukan_tools/screens/emi_calculate.dart';
import 'package:dukan_tools/screens/gram_or_price.dart';
import 'package:dukan_tools/screens/interest_calculate.dart';
import 'package:dukan_tools/screens/margin_calculate.dart';
import 'package:dukan_tools/screens/percentage_discount.dart';
import 'package:dukan_tools/screens/profit_calculate.dart';
import 'package:dukan_tools/screens/weight_convert.dart';
import 'package:dukan_tools/screens/gst_calculate.dart';
import 'package:dukan_tools/screens/cash_tally.dart';
import 'package:dukan_tools/screens/bulk_discount.dart';

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
  ),
  Item(
    id: 9,
    name: 'GST Tax',
    iconData: Icons.receipt_long,
    color: Colors.teal,
    widget: GstCalculate(),
  ),
  Item(
    id: 10,
    name: 'Cash Tally',
    iconData: Icons.calculate,
    color: Colors.blueGrey,
    widget: CashTally(),
  ),
  Item(
    id: 11,
    name: 'Bulk Savings',
    iconData: Icons.grid_view,
    color: Colors.cyan,
    widget: BulkDiscount(),
  ),
];
