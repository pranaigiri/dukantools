import 'package:flutter/material.dart';

class LegacyCardConfig {
  final String toolId;
  final String name;
  final String description;
  final IconData icon;
  final Widget widget;
  final Color color;

  const LegacyCardConfig({
    required this.toolId,
    required this.name,
    required this.description,
    required this.icon,
    required this.widget,
    required this.color,
  });
}
