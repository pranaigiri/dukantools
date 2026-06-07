enum FieldType {
  number,
  decimal,
  dropdown,
  date,
  toggle,
  slider,
}

class FieldConfig {
  final String fieldId;
  final String label;
  final FieldType type;
  final List<String>? options;
  final String? hint;
  final String? defaultValue;
  final double? minValue;
  final double? maxValue;
  final int? divisions;

  const FieldConfig({
    required this.fieldId,
    required this.label,
    required this.type,
    this.options,
    this.hint,
    this.defaultValue,
    this.minValue,
    this.maxValue,
    this.divisions,
  });
}
