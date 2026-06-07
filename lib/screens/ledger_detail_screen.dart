import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dukan_tools/providers/data_provider.dart';
import 'package:dukan_tools/models/ledger_account.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LedgerDetailScreen extends StatelessWidget {
  final String accountId;

  const LedgerDetailScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final theme = Theme.of(context);

    final accountIndex = dataProvider.ledgerAccounts.indexWhere((a) => a.id == accountId);
    if (accountIndex == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text("Account Details")),
        body: const Center(child: Text("Account not found")),
      );
    }
    final account = dataProvider.ledgerAccounts[accountIndex];
    final balance = account.balance;
    final transactions = List<LedgerTransaction>.from(account.transactions)
      ..sort((a, b) => b.date.compareTo(a.date)); // Newest first

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareReminder(context, account),
            tooltip: "Share Reminder",
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDeleteAccount(context, dataProvider, account),
            tooltip: "Delete Account",
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBalanceCard(theme, balance),
          _buildContactActionBar(context, theme, dataProvider, account),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  "Transaction History",
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  "${transactions.length} entries",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          Expanded(
            child: transactions.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return _buildTransactionItem(theme, tx, dataProvider, account.id, context);
                    },
                  ),
          ),

          _buildGivingGettingButtons(context, dataProvider, account.id),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(ThemeData theme, double balance) {
    Color cardColor = Colors.grey;
    String statusText = "Settled";
    String title = "Account Balance";

    if (balance > 0) {
      cardColor = Colors.green;
      statusText = "You Will Get ₹${balance.toStringAsFixed(2)}";
      title = "Outstanding Receivable";
    } else if (balance < 0) {
      cardColor = Colors.red;
      statusText = "You Will Give ₹${balance.abs().toStringAsFixed(2)}";
      title = "Outstanding Payable";
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: cardColor, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: cardColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactActionBar(BuildContext context, ThemeData theme, DataProvider provider, LedgerAccount account) {
    final balance = account.balance;
    String message = '';
    if (balance > 0) {
      message = "Dear ${account.name},\n\nYour outstanding balance on DukanTools is ₹${balance.toStringAsFixed(2)}. Please settle this receivable soon.\n\nThank you!";
    } else if (balance < 0) {
      message = "Dear ${account.name},\n\nWe have a pending payable amount of ₹${balance.abs().toStringAsFixed(2)} to you. We will settle it soon.\n\nThank you!";
    } else {
      message = "Dear ${account.name},\n\nYour account is settled with DukanTools.\n\nThank you!";
    }

    if (account.phone.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? Colors.white.withOpacity(0.02)
              : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.phone_disabled, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text("No phone number registered", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            TextButton.icon(
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              onPressed: () => _showEditContactDialog(context, provider, account),
              icon: const Icon(Icons.add, size: 14),
              label: const Text("Add", style: TextStyle(fontSize: 12)),
            )
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1E1E2C)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.contact_phone_outlined, size: 14, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                "Contact: ${account.phone}",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _showEditContactDialog(context, provider, account),
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 12, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      "Edit",
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildContactButton(
                icon: FontAwesomeIcons.phone,
                label: "Call Dial",
                color: Colors.blue,
                onTap: () => _makeCall(context, account.phone),
              ),
              const SizedBox(width: 10),
              _buildContactButton(
                icon: FontAwesomeIcons.commentSms,
                label: "SMS Share",
                color: Colors.orange,
                onTap: () => _sendSMS(context, account.phone, message),
              ),
              const SizedBox(width: 10),
              _buildContactButton(
                icon: FontAwesomeIcons.whatsapp,
                label: "WhatsApp",
                color: Colors.green,
                onTap: () => _sendWhatsApp(context, account.phone, message),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required dynamic icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(icon, size: 18, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditContactDialog(BuildContext context, DataProvider provider, LedgerAccount account) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: account.name);
    final phoneController = TextEditingController(text: account.phone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Edit Customer Profile", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name *",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  provider.updateLedgerAccount(
                    account.id,
                    nameController.text.trim(),
                    phoneController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _makeCall(BuildContext context, String phoneNumber) async {
    final sanitizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final url = 'tel:$sanitizedPhone';
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone dialer not available on this device / emulator. ($e)')),
        );
      }
    }
  }

  Future<void> _sendSMS(BuildContext context, String phoneNumber, String message) async {
    final sanitizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: sanitizedPhone,
      queryParameters: <String, String>{
        'body': message,
      },
    );
    try {
      await launchUrl(smsUri);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open SMS application. ($e)')),
        );
      }
    }
  }

  Future<void> _sendWhatsApp(BuildContext context, String phoneNumber, String message) async {
    final formattedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final url = "https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}";
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch WhatsApp. ($e)')),
        );
      }
    }
  }

  Widget _buildEmptyState(ThemeData theme) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "No transactions logged yet",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "Use buttons below to log credit (Got) or debit (Gave).",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    ThemeData theme,
    LedgerTransaction tx,
    DataProvider provider,
    String accountId,
    BuildContext context,
  ) {
    final isGave = tx.type == 'debit';
    final color = isGave ? Colors.red : Colors.green;
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(tx.date);

    return Dismissible(
      key: Key(tx.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        provider.deleteLedgerTransaction(accountId, tx.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction deleted')),
        );
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.dividerColor.withOpacity(0.08)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(
                  isGave ? Icons.remove : Icons.add,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.description.isNotEmpty ? tx.description : (isGave ? "Gave credit" : "Got payment"),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateStr,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${tx.amount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isGave ? "Gave" : "Got",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGivingGettingButtons(BuildContext context, DataProvider provider, String accountId) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showLogTxSheet(context, provider, accountId, 'debit'),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove, size: 16),
                    SizedBox(width: 6),
                    Text("YOU GAVE", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showLogTxSheet(context, provider, accountId, 'credit'),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 16),
                    SizedBox(width: 6),
                    Text("YOU GOT", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogTxSheet(BuildContext context, DataProvider provider, String accountId, String type) {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final descController = TextEditingController();
    final theme = Theme.of(context);
    final isGave = type == 'debit';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Form(
            key: formKey,
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
                  isGave ? "Record You Gave (Debit)" : "Record You Got (Credit)",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isGave ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Amount (₹)',
                    prefixIcon: const Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: const Icon(Icons.description),
                    hintText: isGave ? 'e.g., Materials, Rice packet' : 'e.g., Cash, Online Transfer',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                          backgroundColor: isGave ? Colors.red : Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            provider.addLedgerTransaction(
                              accountId: accountId,
                              amount: double.parse(amountController.text),
                              type: type,
                              description: descController.text.trim(),
                            );
                            Navigator.pop(context);
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
        );
      },
    );
  }

  void _shareReminder(BuildContext context, LedgerAccount account) {
    final balance = account.balance;
    if (balance == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account is settled. No reminder needed.')),
      );
      return;
    }

    String message = '';
    if (balance > 0) {
      message = "Dear ${account.name},\n\nYour outstanding balance on DukanTools is ₹${balance.toStringAsFixed(2)}. Please settle this receivable soon.\n\nThank you!";
    } else {
      message = "Dear ${account.name},\n\nWe have a pending payable amount of ₹${balance.abs().toStringAsFixed(2)} to you. We will settle it soon.\n\nThank you!";
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Share Balance Reminder"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Copy and send this message to the customer:", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                importCopy(message, context);
              },
              child: const Text("Copy Text"),
            ),
          ],
        );
      },
    );
  }

  void importCopy(String text, BuildContext context) {
    // Write copy logic here
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder copied to clipboard!')),
    );
  }

  void _confirmDeleteAccount(BuildContext context, DataProvider provider, LedgerAccount account) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Delete Account?", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to delete ${account.name}? All of their ledger transaction history will be lost permanently."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                provider.deleteLedgerAccount(account.id);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to Ledger list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted successfully')),
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
