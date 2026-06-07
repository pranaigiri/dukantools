import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/field_config.dart';

class FieldWidget extends StatelessWidget {
  final FieldConfig config;
  final TextEditingController? controller;
  final dynamic currentValue;
  final ValueChanged<dynamic> onChanged;

  const FieldWidget({
    super.key,
    required this.config,
    this.controller,
    required this.currentValue,
    required this.onChanged,
  });

  bool _isTextField() {
    final id = config.fieldId.toLowerCase();
    final label = config.label.toLowerCase();
    return id.contains('name') || id.contains('batch') || label.contains('name') || label.contains('batch');
  }

  bool _isCurrencyField() {
    final id = config.fieldId.toLowerCase();
    final label = config.label.toLowerCase();
    return label.contains('₹') ||
        id.contains('price') ||
        id.contains('cost') ||
        id.contains('rate') ||
        id.contains('spend') ||
        id.contains('mrp') ||
        id.contains('ptr') ||
        id.contains('pts') ||
        id.contains('fee') ||
        id.contains('quote') ||
        id.contains('charge') ||
        id.contains('revenue') ||
        id.contains('target') ||
        id.contains('bill') ||
        id.contains('principal') ||
        id.contains('earned') ||
        id.contains('refund') ||
        id.contains('saving') ||
        id.contains('profit') ||
        id.contains('tally') ||
        id.contains('amount');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (config.type) {
      case FieldType.number:
        final isText = _isTextField();
        if (isText) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              decoration: InputDecoration(
                labelText: config.label,
                hintText: config.hint,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onChanged: onChanged,
            ),
          );
        }

        // For non-text numeric inputs, render counter buttons (+ / -)
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                onPressed: () {
                  final curVal = int.tryParse(controller?.text ?? '') ?? 0;
                  final newVal = (curVal - 1).clamp(0, 9999999);
                  controller?.text = newVal == 0 ? '' : newVal.toString();
                  onChanged(newVal);
                },
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: config.label,
                    hintText: config.hint ?? '0',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  onChanged: (val) {
                    onChanged(int.tryParse(val) ?? 0);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: () {
                  final curVal = int.tryParse(controller?.text ?? '') ?? 0;
                  final newVal = (curVal + 1).clamp(0, 9999999);
                  controller?.text = newVal.toString();
                  onChanged(newVal);
                },
              ),
            ],
          ),
        );

      case FieldType.decimal:
        final isCurrency = _isCurrencyField();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            decoration: InputDecoration(
              labelText: config.label,
              hintText: config.hint,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              prefixIcon: isCurrency ? const Icon(Icons.currency_rupee, size: 18) : null,
            ),
            onChanged: (val) {
              onChanged(double.tryParse(val) ?? 0.0);
            },
          ),
        );

      case FieldType.dropdown:
        final options = config.options ?? const [];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: DropdownButtonFormField<String>(
            value: currentValue as String?,
            decoration: InputDecoration(
              labelText: config.label,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            items: options.map((opt) {
              return DropdownMenuItem<String>(
                value: opt,
                child: Text(opt, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        );

      case FieldType.toggle:
        final options = config.options ?? const [];
        if (options.isEmpty) return const SizedBox.shrink();

        final String activeVal = currentValue as String? ?? options.first;

        // Render standard Yes/No toggles as SwitchListTile for better native interactivity
        final isYesNo = options.length == 2 &&
            options.contains('Yes') &&
            options.contains('No');

        if (isYesNo) {
          final isSwitched = activeVal == 'Yes';
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              color: Colors.transparent,
              child: SwitchListTile(
                title: Text(
                  config.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                  ),
                ),
                value: isSwitched,
                onChanged: (bool value) {
                  onChanged(value ? 'Yes' : 'No');
                },
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<String>(
                  segments: options.map((opt) {
                    return ButtonSegment<String>(
                      value: opt,
                      label: Text(opt, style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  selected: {activeVal},
                  onSelectionChanged: (Set<String> selection) {
                    onChanged(selection.first);
                  },
                  style: SegmentedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
          ),
        );

      case FieldType.date:
        final date = currentValue as DateTime?;
        final dateStr = date != null ? '${date.day}/${date.month}/${date.year}' : 'Select Date';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TextFormField(
            key: ValueKey(dateStr),
            initialValue: dateStr,
            readOnly: true,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            decoration: InputDecoration(
              labelText: config.label,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              suffixIcon: const Icon(Icons.calendar_today, size: 18),
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                onChanged(picked);
              }
            },
          ),
        );

      case FieldType.slider:
        final double minVal = config.minValue ?? 0.0;
        final double maxVal = config.maxValue ?? 100.0;
        
        // Safely parse double value
        double value = minVal;
        if (currentValue is num) {
          value = currentValue.toDouble();
        } else if (currentValue is String) {
          value = double.tryParse(currentValue) ?? minVal;
        } else if (config.defaultValue != null) {
          value = double.tryParse(config.defaultValue!) ?? minVal;
        }
        value = value.clamp(minVal, maxVal);

        final isPercent = config.label.toLowerCase().contains('%') || config.fieldId.toLowerCase().contains('pct') || config.fieldId.toLowerCase().contains('rate');
        final valueLabel = isPercent ? '${value.toStringAsFixed(1)}%' : value.toStringAsFixed(1);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    config.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    valueLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: value,
                min: minVal,
                max: maxVal,
                divisions: config.divisions,
                label: valueLabel,
                onChanged: (double val) {
                  onChanged(val);
                },
              ),
            ],
          ),
        );
    }
  }
}
