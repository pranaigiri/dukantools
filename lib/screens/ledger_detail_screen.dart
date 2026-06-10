import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dukan_tools/providers/data_provider.dart';
import 'package:dukan_tools/models/ledger_account.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dukan_tools/l10n/app_localizations.dart';

class LedgerDetailScreen extends StatelessWidget {
  final String accountId;

  const LedgerDetailScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final account = dataProvider.getAccountById(accountId);
    if (account == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.accountDetails)),
        body: Center(child: Text(l10n.accountNotFound)),
      );
    }
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
            tooltip: l10n.shareReminder,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDeleteAccount(context, dataProvider, account),
            tooltip: l10n.deleteAccount,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBalanceCard(theme, balance, context),
          _buildContactActionBar(context, theme, dataProvider, account),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  l10n.transactionHistory,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  "${transactions.length} ${l10n.entries}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          Expanded(
            child: transactions.isEmpty
                ? _buildEmptyState(theme, context)
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

  Widget _buildBalanceCard(ThemeData theme, double balance, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color cardColor = Colors.grey;
    String statusText = l10n.settled;
    String title = l10n.accountBalance;

    if (balance > 0) {
      cardColor = Colors.green;
      statusText = "${l10n.youWillGet} ₹${balance.toStringAsFixed(2)}";
      title = l10n.outstandingReceivable;
    } else if (balance < 0) {
      cardColor = Colors.red;
      statusText = "${l10n.youWillGive} ₹${balance.abs().toStringAsFixed(2)}";
      title = l10n.outstandingPayable;
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
    final shopName = provider.getShopNameForAccount(account);
    final l10n = AppLocalizations.of(context)!;
    String message = '';
    if (balance > 0) {
      message = l10n.reminderReceivableTemplate(balance.toStringAsFixed(2), account.name, shopName);
    } else if (balance < 0) {
      message = l10n.reminderPayableTemplate(balance.abs().toStringAsFixed(2), account.name);
    } else {
      message = l10n.reminderSettledTemplate(account.name, shopName);
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
            Row(
              children: [
                const Icon(Icons.phone_disabled, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(l10n.noPhoneNumberRegistered, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            TextButton.icon(
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              onPressed: () => _showEditContactDialog(context, provider, account),
              icon: const Icon(Icons.add, size: 14),
              label: Text(l10n.add, style: const TextStyle(fontSize: 12)),
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
                "${l10n.contact}: ${account.phone}",
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
                      l10n.edit,
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
                label: l10n.callDial,
                color: Colors.blue,
                onTap: () => _makeCall(context, account.phone),
              ),
              const SizedBox(width: 10),
              _buildContactButton(
                icon: FontAwesomeIcons.commentSms,
                label: l10n.smsShare,
                color: Colors.orange,
                onTap: () => _sendSMS(context, account.phone, message),
              ),
              const SizedBox(width: 10),
              _buildContactButton(
                icon: FontAwesomeIcons.whatsapp,
                label: l10n.whatsapp,
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
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.editCustomerProfile, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.name,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return l10n.pleaseEnterAName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.phoneNumber,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
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
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _makeCall(BuildContext context, String phoneNumber) async {
    final sanitizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final url = 'tel:$sanitizedPhone';
    final l10n = AppLocalizations.of(context)!;
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.phoneDialerNotAvailable(e.toString()))),
        );
      }
    }
  }

  Future<void> _sendSMS(BuildContext context, String phoneNumber, String message) async {
    final sanitizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final l10n = AppLocalizations.of(context)!;
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
          SnackBar(content: Text(l10n.couldNotOpenSMSApp(e.toString()))),
        );
      }
    }
  }

  Future<void> _sendWhatsApp(BuildContext context, String phoneNumber, String message) async {
    final formattedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final url = "https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}";
    final l10n = AppLocalizations.of(context)!;
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.couldNotLaunchWhatsApp(e.toString()))),
        );
      }
    }
  }

  Widget _buildEmptyState(ThemeData theme, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            l10n.noTransactionsLoggedYet,
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.useButtonsBelowToLogCreditGotOrDebitGave,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
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
    final l10n = AppLocalizations.of(context)!;
    final isGave = tx.type == 'debit';
    final color = isGave ? Colors.red : Colors.green;
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a', Localizations.localeOf(context).toString()).format(tx.date);

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
          SnackBar(content: Text(l10n.transactionDeleted)),
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
                      tx.description.isNotEmpty ? tx.description : (isGave ? l10n.gaveCredit : l10n.gotPayment),
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
                    isGave ? l10n.gave : l10n.got,
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
    final l10n = AppLocalizations.of(context)!;
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.remove, size: 16),
                    const SizedBox(width: 6),
                    Text(l10n.youGave, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, size: 16),
                    const SizedBox(width: 6),
                    Text(l10n.youGot, style: const TextStyle(fontWeight: FontWeight.bold)),
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
        final l10n = AppLocalizations.of(context)!;
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
                  isGave ? l10n.recordYouGave : l10n.recordYouGot,
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
                    labelText: l10n.amount,
                    prefixIcon: const Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return l10n.pleaseEnterAnAmount;
                    }
                    if (double.tryParse(val) == null || double.parse(val) <= 0) {
                      return l10n.pleaseEnterAValidPositiveAmount;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: l10n.description,
                    prefixIcon: const Icon(Icons.description),
                    hintText: isGave ? l10n.descHintGave : l10n.descHintGot,
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
                        child: Text(l10n.cancel),
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
                        child: Text(l10n.save),
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
    final provider = Provider.of<DataProvider>(context, listen: false);
    final shopName = provider.getShopNameForAccount(account);
    final balance = account.balance;
    final l10n = AppLocalizations.of(context)!;
    if (balance == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.accountIsSettledNoReminderNeeded)),
      );
      return;
    }

    String message = '';
    if (balance > 0) {
      message = l10n.reminderReceivableTemplate(balance.toStringAsFixed(2), account.name, shopName);
    } else {
      message = l10n.reminderPayableTemplate(balance.abs().toStringAsFixed(2), account.name);
    }

    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.shareBalanceReminder),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.copyAndSendThisMessageToTheCustomer, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
              child: Text(l10n.close),
            ),
            ElevatedButton(
              onPressed: () {
                importCopy(message, context);
              },
              child: Text(l10n.copyText),
            ),
          ],
        );
      },
    );
  }

  void importCopy(String text, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: text));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.reminderCopiedToClipboard)),
    );
  }

  void _confirmDeleteAccount(BuildContext context, DataProvider provider, LedgerAccount account) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.deleteAccount, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(l10n.deleteAccountConfirmation(account.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                provider.deleteLedgerAccount(account.id);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to Ledger list
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.accountDeletedSuccessfully)),
                );
              },
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}
