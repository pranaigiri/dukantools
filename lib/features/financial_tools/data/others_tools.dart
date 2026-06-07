import 'package:flutter/material.dart';
import '../models/tool_config.dart';
import '../models/field_config.dart';
import '../models/calculate_result.dart';
import '../models/legacy_card_config.dart';
import 'package:dukan_tools/screens/gram_or_price.dart';
import 'package:dukan_tools/screens/currency_convert.dart';

final List<ToolConfig> othersTools = [
  // 1. Interest Calculator
  ToolConfig(
    toolId: 'interest_calculator',
    name: 'Interest Calculator',
    description: 'Calculate simple interest and total amount for months or years',
    icon: Icons.percent,
    category: ShopCategory.others,
    fields: const [
      FieldConfig(fieldId: 'principal', label: 'Principal Amount (₹)', type: FieldType.decimal, hint: 'e.g. 10000'),
      FieldConfig(
        fieldId: 'interest_rate',
        label: 'Rate of Interest (% P.A.)',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 30.0,
        divisions: 60,
        defaultValue: '12.0',
      ),
      FieldConfig(fieldId: 'time_period', label: 'Time Period', type: FieldType.number, hint: 'e.g. 18'),
      FieldConfig(
        fieldId: 'time_unit',
        label: 'Time Period Unit',
        type: FieldType.toggle,
        options: ['Months', 'Years'],
        defaultValue: 'Months',
      ),
    ],
    formulaText: 'Simple Interest (SI) = (P * R * T) / 100\nT = Time in Years (Months / 12)',
    calculate: (inputs) {
      final p = (inputs['principal'] as num?)?.toDouble() ?? 0.0;
      final r = (inputs['interest_rate'] as num?)?.toDouble() ?? 12.0;
      final tVal = (inputs['time_period'] as num?)?.toInt() ?? 0;
      final unit = inputs['time_unit'] as String? ?? 'Months';

      final double t = unit == 'Months' ? tVal / 12.0 : tVal.toDouble();
      final si = (p * r * t) / 100.0;
      final total = p + si;

      return CalculateResult(
        primaryResult: '₹${total.toStringAsFixed(2)}',
        primaryLabel: 'Total Repayment Amount',
        secondaryResults: [
          SecondaryResult(label: 'Interest Earned (SI)', value: '₹${si.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Principal Amount', value: '₹${p.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Time Period Equivalent', value: '${t.toStringAsFixed(2)} Years ($tVal $unit)'),
        ],
      );
    },
  ),
];

final List<LegacyCardConfig> othersLegacyCards = [
  LegacyCardConfig(
    toolId: 'gram_or_price',
    name: 'Gram or Price',
    description: 'Convert between weight in grams and pricing in real-time',
    icon: Icons.change_circle,
    widget: const GramOrPrice(),
    color: Colors.orange,
  ),
  LegacyCardConfig(
    toolId: 'currency_converter',
    name: 'Currency Converter',
    description: 'Convert currencies with live API rates and offline manual mode',
    icon: Icons.currency_exchange,
    widget: const CurrencyConvert(),
    color: Colors.lightGreen,
  ),
];
