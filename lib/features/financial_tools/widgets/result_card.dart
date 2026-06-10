import 'package:flutter/material.dart';
import '../models/calculate_result.dart';
import 'package:dukan_tools/common/localizations_helper.dart';

class ResultCard extends StatelessWidget {
  final CalculateResult result;
  final String formulaText;

  const ResultCard({
    super.key,
    required this.result,
    required this.formulaText,
  });

  Color? _getAlertColor(AlertLevel alert, bool isDark) {
    switch (alert) {
      case AlertLevel.red:
        return Colors.red;
      case AlertLevel.yellow:
        return Colors.orange;
      case AlertLevel.green:
        return Colors.green;
      case AlertLevel.none:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final alertColor = _getAlertColor(result.alertLevel, isDark);

    return Card(
      elevation: 0,
      color: alertColor != null
          ? alertColor.withOpacity(isDark ? 0.08 : 0.05)
          : (isDark ? Colors.grey.shade900 : Colors.grey.shade50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: alertColor ?? (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
          width: alertColor != null ? 2.0 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    LocalizationsHelper.translate(context, result.primaryLabel),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: alertColor ?? (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    LocalizationsHelper.translate(context, result.primaryResult),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: alertColor ?? (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            if (result.secondaryResults.isNotEmpty) ...[
              const Divider(height: 24),
              ...result.secondaryResults.map((sec) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            LocalizationsHelper.translate(context, sec.label),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: Text(
                            LocalizationsHelper.translate(context, sec.value),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            if (formulaText.isNotEmpty) ...[
              const Divider(height: 24),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262626) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 16,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        LocalizationsHelper.translate(context, formulaText),
                        style: TextStyle(
                          fontSize: 10.5,
                          fontStyle: FontStyle.italic,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
