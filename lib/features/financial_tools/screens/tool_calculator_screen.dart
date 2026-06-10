import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dukan_tools/l10n/app_localizations.dart';
import '../models/tool_config.dart';
import '../models/field_config.dart';
import '../models/calculate_result.dart';
import '../widgets/field_widget.dart';
import '../widgets/result_card.dart';

class ToolCalculatorScreen extends StatefulWidget {
  final ToolConfig config;

  const ToolCalculatorScreen({
    super.key,
    required this.config,
  });

  @override
  State<ToolCalculatorScreen> createState() => _ToolCalculatorScreenState();
}

class _ToolCalculatorScreenState extends State<ToolCalculatorScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _inputs = {};
  CalculateResult? _result;
  bool _isLoading = true;

  // For Expiry Tracker tools
  List<Map<String, dynamic>> _savedExpiries = [];

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();

    // Load inputs
    for (var f in widget.config.fields) {
      final key = 'tool_field_${widget.config.toolId}_${f.fieldId}';

      if (f.type == FieldType.number || f.type == FieldType.decimal) {
        final controller = TextEditingController();
        _controllers[f.fieldId] = controller;

        final savedVal = prefs.getString(key) ?? f.defaultValue ?? '';
        controller.text = savedVal;

        if (savedVal.isNotEmpty) {
          final isText = f.fieldId.contains('name') || f.fieldId.contains('batch');
          if (isText) {
            _inputs[f.fieldId] = savedVal;
          } else if (f.type == FieldType.number) {
            _inputs[f.fieldId] = int.tryParse(savedVal) ?? 0;
          } else {
            _inputs[f.fieldId] = double.tryParse(savedVal) ?? 0.0;
          }
        } else {
          final isText = f.fieldId.contains('name') || f.fieldId.contains('batch');
          if (isText) {
            _inputs[f.fieldId] = '';
          } else if (f.type == FieldType.number) {
            _inputs[f.fieldId] = 0;
          } else {
            _inputs[f.fieldId] = 0.0;
          }
        }
      } else if (f.type == FieldType.dropdown || f.type == FieldType.toggle || f.type == FieldType.slider) {
        final savedVal = prefs.getString(key) ?? f.defaultValue ?? '';
        if (f.type == FieldType.slider) {
          _inputs[f.fieldId] = double.tryParse(savedVal) ?? double.tryParse(f.defaultValue ?? '') ?? f.minValue ?? 0.0;
        } else {
          _inputs[f.fieldId] = savedVal;
        }
      } else if (f.type == FieldType.date) {
        final savedVal = prefs.getString(key) ?? '';
        if (savedVal.isNotEmpty) {
          _inputs[f.fieldId] = DateTime.tryParse(savedVal);
        } else if (f.defaultValue != null) {
          _inputs[f.fieldId] = DateTime.tryParse(f.defaultValue!);
        }
      }
    }

    // Load expiry logs if this is an expiry tracker
    if (widget.config.toolId.startsWith('expiry_tracker')) {
      final jsonStr = prefs.getString('expiry_tracker_entries') ?? '[]';
      try {
        final list = json.decode(jsonStr) as List;
        _savedExpiries = list.map((e) => Map<String, dynamic>.from(e)).toList();
      } catch (_) {
        _savedExpiries = [];
      }
    }

    _calculate();
    setState(() {
      _isLoading = false;
    });
  }

  void _calculate() {
    setState(() {
      _result = widget.config.calculate(_inputs);
    });
  }

  Future<void> _updateField(String fieldId, dynamic value, FieldType type) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'tool_field_${widget.config.toolId}_$fieldId';

    setState(() {
      _inputs[fieldId] = value;
    });

    // Save state
    if (value is DateTime) {
      await prefs.setString(key, value.toIso8601String());
    } else {
      await prefs.setString(key, value.toString());
    }

    // Run trigger logic if present
    if (widget.config.onFieldChanged != null) {
      widget.config.onFieldChanged!(fieldId, value, _inputs, _controllers);
    }

    _calculate();
  }

  // Expiry tracker operations
  Future<void> _saveExpiryEntry() async {
    final nameFieldId = widget.config.toolId == 'expiry_tracker_medical' ? 'medicine_name' : 'product_name';
    final batchFieldId = 'batch_number';
    final dateFieldId = 'expiry_date';

    final name = _inputs[nameFieldId] as String? ?? '';
    final batch = _inputs[batchFieldId] as String? ?? '';
    final expiryDate = _inputs[dateFieldId] as DateTime?;

    final l10n = AppLocalizations.of(context)!;

    if (name.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseEnterAValidName),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseSelectAnExpiryDate),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final entry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'toolId': widget.config.toolId,
      'name': name.trim(),
      'batch': batch.trim(),
      'expiryDate': expiryDate.toIso8601String(),
    };

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedExpiries.insert(0, entry);
    });

    await prefs.setString('expiry_tracker_entries', json.encode(_savedExpiries));

    // Clear name and batch fields after saving
    _controllers[nameFieldId]?.clear();
    _inputs[nameFieldId] = '';
    if (widget.config.toolId == 'expiry_tracker_medical') {
      _controllers[batchFieldId]?.clear();
      _inputs[batchFieldId] = '';
    }

    _calculate();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.expiryEntrySavedSuccessfully),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deleteExpiryEntry(String id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedExpiries.removeWhere((e) => e['id'] == id);
    });
    await prefs.setString('expiry_tracker_entries', json.encode(_savedExpiries));

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.entryRemoved),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Color _getExpiryBadgeColor(int days) {
    if (days < 60) return Colors.red;
    if (days < 90) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final isExpiryTracker = widget.config.toolId.startsWith('expiry_tracker');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dynamic fields form
          ...widget.config.fields.map((f) {
            return FieldWidget(
              config: f,
              controller: _controllers[f.fieldId],
              currentValue: _inputs[f.fieldId],
              onChanged: (val) => _updateField(f.fieldId, val, f.type),
            );
          }),
          const SizedBox(height: 12),

          // Output Result Card
          if (_result != null)
            ResultCard(
              result: _result!,
              formulaText: widget.config.formulaText,
            ),

          // Save Expiry Button
          if (isExpiryTracker) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveExpiryEntry,
              icon: const Icon(Icons.bookmark_add),
              label: Text(l10n.saveToExpiryLog),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.savedExpiryLog,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            if (_savedExpiries.isEmpty)
              Card(
                elevation: 0,
                color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      l10n.noEntriesRecordedYet,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _savedExpiries.length,
                itemBuilder: (context, index) {
                  final entry = _savedExpiries[index];
                  final String id = entry['id'] as String;
                  final String name = entry['name'] as String;
                  final String batch = entry['batch'] as String? ?? '';
                  final String dateStr = entry['expiryDate'] as String;
                  final expDate = DateTime.parse(dateStr);

                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final days = expDate.difference(today).inDays;
                  final badgeColor = _getExpiryBadgeColor(days);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (batch.isNotEmpty) Text('${l10n.batchLabel}: $batch', style: const TextStyle(fontSize: 12)),
                          Text(
                            '${l10n.expiryLabel}: ${expDate.day}/${expDate.month}/${expDate.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: badgeColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: badgeColor.withOpacity(0.5)),
                            ),
                            child: Text(
                              days >= 0 ? l10n.daysLeftText(days) : l10n.expiredText,
                              style: TextStyle(
                                color: badgeColor,
                                fontWeight: FontWeight.bold,
                                				fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _deleteExpiryEntry(id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}
