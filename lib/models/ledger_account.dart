class LedgerTransaction {
  final String id;
  final double amount;
  final String type; // 'debit' (gave) or 'credit' (got)
  final String description;
  final DateTime date;

  LedgerTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory LedgerTransaction.fromJson(Map<dynamic, dynamic> json) {
    return LedgerTransaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class LedgerAccount {
  final String id;
  final String name;
  final String phone;
  final DateTime createdAt;
  final List<LedgerTransaction> transactions;
  final String? shopId;

  LedgerAccount({
    required this.id,
    required this.name,
    required this.phone,
    required this.createdAt,
    required this.transactions,
    this.shopId,
  });

  double get balance {
    // gave (debit) increases the balance (customer owes us money)
    // got (credit) decreases the balance (customer paid us money)
    double bal = 0.0;
    for (var tx in transactions) {
      if (tx.type == 'debit') {
        bal += tx.amount;
      } else {
        bal -= tx.amount;
      }
    }
    return bal;
  }

  double get totalGave {
    double sum = 0.0;
    for (var tx in transactions) {
      if (tx.type == 'debit') {
        sum += tx.amount;
      }
    }
    return sum;
  }

  double get totalGot {
    double sum = 0.0;
    for (var tx in transactions) {
      if (tx.type == 'credit') {
        sum += tx.amount;
      }
    }
    return sum;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'shopId': shopId,
    };
  }

  factory LedgerAccount.fromJson(Map<dynamic, dynamic> json) {
    var txList = (json['transactions'] as List? ?? [])
        .map((t) => LedgerTransaction.fromJson(t as Map<dynamic, dynamic>))
        .toList();
    return LedgerAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      transactions: txList,
      shopId: json['shopId'] as String?,
    );
  }

  LedgerAccount copyWith({
    String? id,
    String? name,
    String? phone,
    DateTime? createdAt,
    List<LedgerTransaction>? transactions,
    String? shopId,
  }) {
    return LedgerAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      transactions: transactions ?? this.transactions,
      shopId: shopId ?? this.shopId,
    );
  }
}
