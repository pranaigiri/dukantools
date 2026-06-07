import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dukan_tools/providers/data_provider.dart';
import 'package:dukan_tools/models/pl_entry.dart';
import 'package:intl/intl.dart';

class DayBookTab extends StatefulWidget {
  const DayBookTab({super.key});

  @override
  State<DayBookTab> createState() => _DayBookTabState();
}

class _DayBookTabState extends State<DayBookTab> {
  DateTime _selectedDate = DateTime.now();
  String _filterType = 'all'; // 'all', 'income', 'expense'
  String _viewMode = 'daily'; // 'daily' or 'monthly'

  final List<String> _incomeCategories = [
    'Sales',
    'Services',
    'Interest',
    'Rental',
    'Cashback',
    'Others',
  ];

  final List<String> _expenseCategories = [
    'Purchase',
    'Rent',
    'Salary',
    'Bills/Utilities',
    'Travel',
    'Food',
    'Marketing',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final theme = Theme.of(context);

    if (dataProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Column(
        children: [
          // View Mode Switcher
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SegmentedButton<String>(
                  style: SegmentedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                      value: 'daily',
                      label: Text('Daily Book'),
                      icon: Icon(Icons.calendar_today_outlined),
                    ),
                    ButtonSegment<String>(
                      value: 'monthly',
                      label: Text('Monthly Overview'),
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                  ],
                  selected: <String>{_viewMode},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _viewMode = newSelection.first;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _viewMode == 'daily'
                ? _buildDailyView(theme, dataProvider)
                : _buildMonthlyOverview(theme, dataProvider),
          ),
        ],
      ),
      floatingActionButton: _viewMode == 'daily'
          ? FloatingActionButton.extended(
              heroTag: 'daybook_add_transaction_fab',
              onPressed: () => _showAddEntrySheet(context, dataProvider),
              icon: const Icon(Icons.add),
              label: const Text("Add Transaction"),
            )
          : null,
    );
  }

  Widget _buildDailyView(ThemeData theme, DataProvider dataProvider) {
    // Filter entries based on selection
    final filteredEntries = dataProvider.plEntries.where((e) {
      final matchesDate = e.date.year == _selectedDate.year &&
          e.date.month == _selectedDate.month &&
          e.date.day == _selectedDate.day;

      if (!matchesDate) return false;

      if (_filterType == 'income') return e.type == 'income';
      if (_filterType == 'expense') return e.type == 'expense';
      return true;
    }).toList();

    // Calculate daily totals
    double dailyIncome = 0.0;
    double dailyExpense = 0.0;

    for (var e in dataProvider.plEntries) {
      if (e.date.year == _selectedDate.year &&
          e.date.month == _selectedDate.month &&
          e.date.day == _selectedDate.day) {
        if (e.type == 'income') {
          dailyIncome += e.amount;
        } else {
          dailyExpense += e.amount;
        }
      }
    }
    double dailyNet = dailyIncome - dailyExpense;

    return Column(
      children: [
        // Date Selector and Daily Overview
        _buildDayHeaderCard(theme, dailyIncome, dailyExpense, dailyNet),

        // Filters row
        _buildFiltersRow(theme),

        // List of entries
        Expanded(
          child: filteredEntries.isEmpty
              ? _buildEmptyState(theme)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredEntries.length,
                  itemBuilder: (context, index) {
                    final entry = filteredEntries[index];
                    return _buildEntryItem(theme, entry, dataProvider);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMonthlyOverview(ThemeData theme, DataProvider dataProvider) {
    // Group all P&L entries by month and year
    final Map<String, List<PLEntry>> monthlyGroups = {};
    for (var entry in dataProvider.plEntries) {
      final key = DateFormat('MMMM yyyy').format(entry.date);
      monthlyGroups.putIfAbsent(key, () => []).add(entry);
    }

    if (monthlyGroups.isEmpty) {
      final key = DateFormat('MMMM yyyy').format(DateTime.now());
      monthlyGroups[key] = [];
    }

    final sortedKeys = monthlyGroups.keys.toList()
      ..sort((a, b) {
        try {
          final dateA = DateFormat('MMMM yyyy').parse(a);
          final dateB = DateFormat('MMMM yyyy').parse(b);
          return dateB.compareTo(dateA); // Newest month first
        } catch (_) {
          return 0;
        }
      });

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final key = sortedKeys[index];
        final entries = monthlyGroups[key] ?? [];

        double monthlyIncome = 0.0;
        double monthlyExpense = 0.0;

        for (var e in entries) {
          if (e.type == 'income') {
            monthlyIncome += e.amount;
          } else {
            monthlyExpense += e.amount;
          }
        }
        double monthlyNet = monthlyIncome - monthlyExpense;
        final netColor = monthlyNet >= 0 ? Colors.teal : Colors.deepOrangeAccent;

        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: theme.dividerColor.withOpacity(0.08)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // Extract date from month key to set _selectedDate and switch view
              try {
                final date = DateFormat('MMMM yyyy').parse(key);
                setState(() {
                  // Set to first day of that month, or current day if it's the current month/year
                  final now = DateTime.now();
                  if (date.month == now.month && date.year == now.year) {
                    _selectedDate = now;
                  } else {
                    _selectedDate = date;
                  }
                  _viewMode = 'daily';
                });
              } catch (_) {}
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        key,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${entries.length} txs",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Total Income", style: TextStyle(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(
                              "₹${monthlyIncome.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Total Expense", style: TextStyle(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(
                              "₹${monthlyExpense.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Net Balance", style: TextStyle(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(
                              "${monthlyNet >= 0 ? '+' : ''}₹${monthlyNet.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: netColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayHeaderCard(ThemeData theme, double income, double expense, double net) {
    final dateStr = DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1E1E2C)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  dateStr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDailyStatColumn("Income", "₹${income.toStringAsFixed(2)}", Colors.green, theme),
              Container(width: 1, height: 40, color: theme.dividerColor.withOpacity(0.2)),
              _buildDailyStatColumn("Expense", "₹${expense.toStringAsFixed(2)}", Colors.red, theme),
              Container(width: 1, height: 40, color: theme.dividerColor.withOpacity(0.2)),
              _buildDailyStatColumn(
                "Net Profit",
                "${net >= 0 ? '+' : ''}₹${net.toStringAsFixed(2)}",
                net >= 0 ? Colors.teal : Colors.deepOrangeAccent,
                theme,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDailyStatColumn(String label, String value, Color color, ThemeData theme) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          Text(
            "Transactions",
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          _buildFilterChip('All', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('Income', 'income'),
          const SizedBox(width: 8),
          _buildFilterChip('Expense', 'expense'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterType == value;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        setState(() {
          _filterType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? theme.colorScheme.primary : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notes_outlined, size: 48, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(
            "No entries for this day",
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          const Text(
            "Tap 'Add Transaction' to log cash flow.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryItem(ThemeData theme, PLEntry entry, DataProvider provider) {
    final color = entry.type == 'income' ? Colors.green : Colors.red;

    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        provider.deletePLEntry(entry.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction deleted')),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.08),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(
                entry.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
                color: color,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        entry.category,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          entry.type.toUpperCase(),
                          style: TextStyle(fontSize: 8, color: color, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.description.isNotEmpty ? entry.description : 'No description',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "${entry.type == 'income' ? '+' : '-'}₹${entry.amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEntrySheet(BuildContext context, DataProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return _AddEntryForm(
          incomeCategories: _incomeCategories,
          expenseCategories: _expenseCategories,
          initialDate: _selectedDate,
          onSave: (entry) {
            provider.addPLEntry(entry);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class _AddEntryForm extends StatefulWidget {
  final List<String> incomeCategories;
  final List<String> expenseCategories;
  final DateTime initialDate;
  final Function(PLEntry) onSave;

  const _AddEntryForm({
    required this.incomeCategories,
    required this.expenseCategories,
    required this.initialDate,
    required this.onSave,
  });

  @override
  State<_AddEntryForm> createState() => _AddEntryFormState();
}

class _AddEntryFormState extends State<_AddEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();

  String _type = 'income'; // 'income' or 'expense'
  late String _category;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _category = widget.incomeCategories.first;
    _date = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = _type == 'income';
    final categories = isIncome ? widget.incomeCategories : widget.expenseCategories;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Add Transaction",
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Center(
                child: SegmentedButton<String>(
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: isIncome ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    selectedForegroundColor: isIncome ? Colors.green : Colors.red,
                  ),
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                      value: 'income',
                      label: Text('Income (Got)'),
                      icon: Icon(Icons.arrow_downward, color: Colors.green),
                    ),
                    ButtonSegment<String>(
                      value: 'expense',
                      label: Text('Expense (Paid)'),
                      icon: Icon(Icons.arrow_upward, color: Colors.red),
                    ),
                  ],
                  selected: <String>{_type},
                  onSelectionChanged: (val) {
                    setState(() {
                      _type = val.first;
                      _category = (val.first == 'income'
                          ? widget.incomeCategories
                          : widget.expenseCategories)
                      .first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount (₹)',
                  prefixIcon: const Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(val) == null || double.parse(val) <= 0) {
                    return 'Please enter a valid positive amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _category = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _date = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        "Date: ${DateFormat('dd MMMM yyyy').format(_date)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final entry = PLEntry(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            amount: double.parse(_amountController.text),
                            type: _type,
                            category: _category,
                            description: _descController.text.trim(),
                            date: _date,
                          );
                          widget.onSave(entry);
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
