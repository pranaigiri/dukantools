import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Denomination {
  final int value;
  final Color color;
  final bool isNote;

  const Denomination(this.value, this.color, {this.isNote = true});
}

class CashTally extends StatefulWidget {
  const CashTally({super.key});

  @override
  State<CashTally> createState() => _CashTallyState();
}

class _CashTallyState extends State<CashTally> {
  // Static map to persist note counts
  static final Map<int, int> _persistedCounts = {};

  final List<Denomination> denominations = const [
    Denomination(2000, Color(0xFFE8B4F8), isNote: true), // Pinkish Purple
    Denomination(500, Color(0xFFA2D3C2), isNote: true),  // Stone Green
    Denomination(200, Color(0xFFF9C093), isNote: true),  // Orange/Yellow
    Denomination(100, Color(0xFFB1C4EB), isNote: true),  // Lavender Blue
    Denomination(50, Color(0xFF96E6E6), isNote: true),   // Fluorescent Cyan
    Denomination(20, Color(0xFFCBEAA6), isNote: true),   // Yellow Green
    Denomination(10, Color(0xFFDDD0C2), isNote: true),   // Chocolate Brown
    Denomination(5, Color(0xFFCCCCCC), isNote: false),   // Coin Gray
    Denomination(2, Color(0xFFDDDDDD), isNote: false),
    Denomination(1, Color(0xFFEEEEEE), isNote: false),
  ];

  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var denom in denominations) {
      final val = _persistedCounts[denom.value] ?? 0;
      _controllers[denom.value] = TextEditingController(
        text: val == 0 ? "" : val.toString(),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      _persistedCounts.clear();
      for (var denom in denominations) {
        _controllers[denom.value]?.clear();
      }
    });
  }

  int getCount(int denominationValue) {
    return _persistedCounts[denominationValue] ?? 0;
  }

  void updateCount(int denominationValue, int newCount) {
    final clampedCount = newCount.clamp(0, 999999);
    setState(() {
      _persistedCounts[denominationValue] = clampedCount;
      _controllers[denominationValue]?.text = clampedCount == 0 ? "" : clampedCount.toString();
    });
  }

  int get totalNotes {
    int sum = 0;
    for (var denom in denominations) {
      if (denom.isNote) {
        sum += getCount(denom.value);
      }
    }
    return sum;
  }

  int get totalCoins {
    int sum = 0;
    for (var denom in denominations) {
      if (!denom.isNote) {
        sum += getCount(denom.value);
      }
    }
    return sum;
  }

  int get grandTotal {
    int total = 0;
    for (var denom in denominations) {
      total += denom.value * getCount(denom.value);
    }
    return total;
  }

  void _copyToClipboard() {
    HapticFeedback.mediumImpact();
    final buffer = StringBuffer();
    buffer.writeln("=== CASH TALLY REPORT ===");
    for (var denom in denominations) {
      final count = getCount(denom.value);
      if (count > 0) {
        buffer.writeln("₹${denom.value} x $count = ₹${denom.value * count}");
      }
    }
    buffer.writeln("-------------------------");
    buffer.writeln("Total Notes: $totalNotes");
    buffer.writeln("Total Coins: $totalCoins");
    buffer.writeln("Grand Total: ₹$grandTotal");
    buffer.writeln("=========================");

    Clipboard.setData(ClipboardData(text: buffer.toString())).then((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tally report copied to clipboard!"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.teal,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0), // Padding leaves room for the sticky bottom bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Digital Cash Drawer',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (grandTotal > 0)
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.refresh, size: 18, color: Colors.blueGrey),
                  label: const Text('Reset', style: TextStyle(color: Colors.blueGrey)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Denominations List
          ...denominations.map((denom) {
            final count = getCount(denom.value);
            final subtotal = denom.value * count;

            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: (isDark ? Colors.grey.shade800 : Colors.grey.shade300), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Denomination Tag
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: denom.color.withValues(alpha: isDark ? 0.3 : 1.0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: denom.color.withValues(alpha: 0.8),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "₹${denom.value}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("×", style: TextStyle(fontSize: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade800)),
                    const SizedBox(width: 8),
                    // Counter Controls
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        updateCount(denom.value, count - 1);
                      },
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          controller: _controllers[denom.value],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(),
                            hintText: "0",
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (val) {
                            final newCount = int.tryParse(val) ?? 0;
                            _persistedCounts[denom.value] = newCount;
                            setState(() {}); // Rebuild to update subtotal
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        updateCount(denom.value, count + 1);
                      },
                    ),
                    // Subtotal
                    SizedBox(
                      width: 90,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          subtotal > 0 ? "₹$subtotal" : "₹0",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: subtotal > 0
                                ? (isDark ? Colors.green.shade300 : Colors.green.shade800)
                                : (isDark ? Colors.grey.shade500 : Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          // Sticky Bottom Summary Bar
          if (grandTotal > 0)
            Card(
              color: Colors.blueGrey.withValues(alpha: 0.15),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.blueGrey.withValues(alpha: 0.4), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Notes: $totalNotes | Coins: $totalCoins",
                          style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade800, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Total Cash: ₹$grandTotal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: isDark ? Colors.blueGrey.shade300 : Colors.blueGrey.shade800,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _copyToClipboard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text("Share"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
