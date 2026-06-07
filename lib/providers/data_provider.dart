import 'package:flutter/foundation.dart';
import 'package:dukan_tools/models/ledger_account.dart';
import 'package:dukan_tools/models/pl_entry.dart';
import 'package:dukan_tools/services/backup_service.dart';
import 'package:dukan_tools/services/database_service.dart';

class DataProvider with ChangeNotifier {
  List<PLEntry> _plEntries = [];
  List<LedgerAccount> _ledgerAccounts = [];
  bool _isLoading = true;
  String? _restoreMessage;

  List<PLEntry> get plEntries => _plEntries;
  List<LedgerAccount> get ledgerAccounts => _ledgerAccounts;
  bool get isLoading => _isLoading;
  String? get restoreMessage => _restoreMessage;

  DataProvider() {
    _loadInitialData();
  }

  /// First load from constructor — avoids the initial notifyListeners with
  /// isLoading=true since the widget tree hasn't mounted yet.
  Future<void> _loadInitialData() async {
    try {
      await _loadFromDatabase();
    } catch (e) {
      debugPrint("Error during initial data load: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Called from pull-to-refresh.
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadFromDatabase();
    } catch (e) {
      debugPrint("Error loading data from Hive: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Core data loading logic shared by constructor and pull-to-refresh.
  Future<void> _loadFromDatabase() async {
    final plBox = DatabaseService.plBox;
    final ledgerBox = DatabaseService.ledgerBox;

    // Check if DB is empty to run auto-restore
    if (plBox.isEmpty && ledgerBox.isEmpty) {
      try {
        final backupData = await BackupService.scanAndRestore();
        if (backupData != null) {
          // Restore P&L Entries
          final plList = backupData['p_and_l'] as List? ?? [];
          for (var item in plList) {
            final entry = PLEntry.fromJson(item as Map);
            await plBox.put(entry.id, entry.toJson());
          }

          // Restore Ledger Accounts
          final ledgerList = backupData['ledger'] as List? ?? [];
          for (var item in ledgerList) {
            final acc = LedgerAccount.fromJson(item as Map);
            await ledgerBox.put(acc.id, acc.toJson());
          }

          _restoreMessage = "Successfully auto-restored from public backup!";
        }
      } catch (e) {
        debugPrint("Backup restore failed (non-fatal): $e");
      }
    }

    // Load P&L Entries
    _plEntries = plBox.values
        .map((e) => PLEntry.fromJson(Map<dynamic, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Newest first

    // Load Ledger Accounts
    _ledgerAccounts = ledgerBox.values
        .map((e) => LedgerAccount.fromJson(Map<dynamic, dynamic>.from(e as Map)))
        .toList();
  }

  // Clear restore message after showing it
  void clearRestoreMessage() {
    _restoreMessage = null;
    notifyListeners();
  }

  // --- Day Book CRUD ---
  Future<void> addPLEntry(PLEntry entry) async {
    _plEntries.insert(0, entry);
    await DatabaseService.plBox.put(entry.id, entry.toJson());
    notifyListeners();
    _triggerBackup();
  }

  Future<void> updatePLEntry(PLEntry entry) async {
    final idx = _plEntries.indexWhere((e) => e.id == entry.id);
    if (idx != -1) {
      _plEntries[idx] = entry;
      await DatabaseService.plBox.put(entry.id, entry.toJson());
      notifyListeners();
      _triggerBackup();
    }
  }

  Future<void> deletePLEntry(String id) async {
    _plEntries.removeWhere((e) => e.id == id);
    await DatabaseService.plBox.delete(id);
    notifyListeners();
    _triggerBackup();
  }

  // --- Ledger Accounts CRUD ---
  Future<void> addLedgerAccount(String name, String phone) async {
    final newAcc = LedgerAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      createdAt: DateTime.now(),
      transactions: [],
    );
    _ledgerAccounts.add(newAcc);
    await DatabaseService.ledgerBox.put(newAcc.id, newAcc.toJson());
    notifyListeners();
    _triggerBackup();
  }

  Future<void> deleteLedgerAccount(String accountId) async {
    _ledgerAccounts.removeWhere((a) => a.id == accountId);
    await DatabaseService.ledgerBox.delete(accountId);
    notifyListeners();
    _triggerBackup();
  }

  Future<void> updateLedgerAccount(String accountId, String name, String phone) async {
    final idx = _ledgerAccounts.indexWhere((a) => a.id == accountId);
    if (idx != -1) {
      final account = _ledgerAccounts[idx];
      final updatedAccount = account.copyWith(name: name, phone: phone);
      _ledgerAccounts[idx] = updatedAccount;
      await DatabaseService.ledgerBox.put(accountId, updatedAccount.toJson());
      notifyListeners();
      _triggerBackup();
    }
  }

  // --- Ledger Transactions CRUD ---
  Future<void> addLedgerTransaction({
    required String accountId,
    required double amount,
    required String type, // 'debit' (gave) or 'credit' (got)
    required String description,
  }) async {
    final idx = _ledgerAccounts.indexWhere((a) => a.id == accountId);
    if (idx != -1) {
      final account = _ledgerAccounts[idx];
      final newTx = LedgerTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        type: type,
        description: description,
        date: DateTime.now(),
      );

      final updatedTxs = List<LedgerTransaction>.from(account.transactions)..add(newTx);
      final updatedAccount = account.copyWith(transactions: updatedTxs);

      _ledgerAccounts[idx] = updatedAccount;
      await DatabaseService.ledgerBox.put(accountId, updatedAccount.toJson());
      notifyListeners();
      _triggerBackup();
    }
  }

  Future<void> deleteLedgerTransaction(String accountId, String txId) async {
    final idx = _ledgerAccounts.indexWhere((a) => a.id == accountId);
    if (idx != -1) {
      final account = _ledgerAccounts[idx];
      final updatedTxs = List<LedgerTransaction>.from(account.transactions)
        ..removeWhere((tx) => tx.id == txId);
      final updatedAccount = account.copyWith(transactions: updatedTxs);

      _ledgerAccounts[idx] = updatedAccount;
      await DatabaseService.ledgerBox.put(accountId, updatedAccount.toJson());
      notifyListeners();
      _triggerBackup();
    }
  }

  // Manual Backup trigger
  Future<bool> manualBackup() async {
    return await BackupService.backupData(
      accounts: _ledgerAccounts,
      plEntries: _plEntries,
    );
  }

  // Auto-backup triggered asynchronously in the background
  void _triggerBackup() {
    BackupService.backupData(
      accounts: _ledgerAccounts,
      plEntries: _plEntries,
    );
  }

  // --- Statistics & Aggregations for Dashboard ---

  // P&L Stats
  double get totalIncome {
    return _plEntries
        .where((e) => e.type == 'income')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return _plEntries
        .where((e) => e.type == 'expense')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get netProfit => totalIncome - totalExpense;

  // Ledger Stats
  // Receivables: sum of positive balances (where customer owes us money)
  double get totalReceivables {
    return _ledgerAccounts
        .where((a) => a.balance > 0)
        .fold(0.0, (sum, item) => sum + item.balance);
  }

  // Payables: sum of absolute negative balances (where we owe customer money)
  double get totalPayables {
    return _ledgerAccounts
        .where((a) => a.balance < 0)
        .fold(0.0, (sum, item) => sum + item.balance.abs());
  }

  List<LedgerAccount> get topActiveAccounts {
    final list = List<LedgerAccount>.from(_ledgerAccounts);
    // Sort by transaction count, then by balance magnitude
    list.sort((a, b) {
      int cmp = b.transactions.length.compareTo(a.transactions.length);
      if (cmp != 0) return cmp;
      return b.balance.abs().compareTo(a.balance.abs());
    });
    return list.take(5).toList();
  }

  // --- Monthly Sales / Income Helpers ---
  double getIncomeForMonth(int month, int year) {
    return _plEntries.where((e) {
      return e.date.month == month && e.date.year == year && e.type == 'income';
    }).fold(0.0, (sum, item) => sum + item.amount);
  }

  double get currentMonthSales {
    final now = DateTime.now();
    return getIncomeForMonth(now.month, now.year);
  }

  double get previousMonthSales {
    final now = DateTime.now();
    final prevMonth = now.month == 1 ? 12 : now.month - 1;
    final prevYear = now.month == 1 ? now.year - 1 : now.year;
    return getIncomeForMonth(prevMonth, prevYear);
  }

  double getSalesCategoryForMonth(int month, int year) {
    return _plEntries.where((e) {
      return e.date.month == month && e.date.year == year && e.type == 'income' && e.category == 'Sales';
    }).fold(0.0, (sum, item) => sum + item.amount);
  }

  double get currentMonthSalesCategory {
    final now = DateTime.now();
    return getSalesCategoryForMonth(now.month, now.year);
  }

  double get previousMonthSalesCategory {
    final now = DateTime.now();
    final prevMonth = now.month == 1 ? 12 : now.month - 1;
    final prevYear = now.month == 1 ? now.year - 1 : now.year;
    return getSalesCategoryForMonth(prevMonth, prevYear);
  }
}
