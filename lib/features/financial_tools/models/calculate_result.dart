enum AlertLevel {
  none,
  green,
  yellow,
  red,
}

class SecondaryResult {
  final String label;
  final String value;

  const SecondaryResult({
    required this.label,
    required this.value,
  });
}

class CalculateResult {
  final String primaryResult;
  final String primaryLabel;
  final List<SecondaryResult> secondaryResults;
  final AlertLevel alertLevel;

  const CalculateResult({
    required this.primaryResult,
    required this.primaryLabel,
    this.secondaryResults = const [],
    this.alertLevel = AlertLevel.none,
  });
}
