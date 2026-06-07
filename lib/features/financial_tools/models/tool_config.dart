import 'package:flutter/material.dart';
import 'field_config.dart';
import 'calculate_result.dart';

enum ShopCategory {
  kirana,
  chai,
  saree,
  medical,
  hardware,
  mobile,
  others,
}

class ToolConfig {
  final String toolId;
  final String name;
  final String description;
  final IconData icon;
  final ShopCategory category;
  final List<FieldConfig> fields;
  final String formulaText;
  final CalculateResult Function(Map<String, dynamic> inputs) calculate;
  final void Function(String fieldId, dynamic value, Map<String, dynamic> inputs, Map<String, TextEditingController> controllers)? onFieldChanged;

  const ToolConfig({
    required this.toolId,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.fields,
    required this.formulaText,
    required this.calculate,
    this.onFieldChanged,
  });
}
