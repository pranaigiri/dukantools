import 'package:flutter/material.dart';

class Item {
  final int id;
  final String name;
  final IconData iconData;
  final dynamic color;
  final Widget widget;

  const Item(
      {required this.id,
      required this.name,
      required this.iconData,
      required this.color,
      required this.widget});
}
