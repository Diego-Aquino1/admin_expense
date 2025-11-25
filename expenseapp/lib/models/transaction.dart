/// Modelo de Transacción
class Transaction {
  final int id;
  final int userId;
  final int accountId;
  final int? categoryId;
  final String type;
  final double amount;
  final String currency;
  final DateTime date;
  final String? time;
  final String? merchant;
  final String? notes;
  final String? tags;
  final int? toAccountId;
  final bool isReimbursable;
  final bool reimbursed;
  final bool isSplit;
  final bool isInstallment;
  final DateTime createdAt;
  final DateTime? updatedAt;
  String? accountName;
  String? categoryName;

  Transaction({
    required this.id,
    required this.userId,
    required this.accountId,
    this.categoryId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.date,
    this.time,
    this.merchant,
    this.notes,
    this.tags,
    this.toAccountId,
    required this.isReimbursable,
    required this.reimbursed,
    required this.isSplit,
    required this.isInstallment,
    required this.createdAt,
    this.updatedAt,
    this.accountName,
    this.categoryName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['user_id'],
      accountId: json['account_id'],
      categoryId: json['category_id'],
      type: json['type'],
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      merchant: json['merchant'],
      notes: json['notes'],
      tags: json['tags'],
      toAccountId: json['to_account_id'],
      isReimbursable: json['is_reimbursable'],
      reimbursed: json['reimbursed'],
      isSplit: json['is_split'],
      isInstallment: json['is_installment'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      accountName: json['account_name'],
      categoryName: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'account_id': accountId,
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'currency': currency,
      'date': date.toIso8601String(),
      'time': time,
      'merchant': merchant,
      'notes': notes,
      'tags': tags,
      'to_account_id': toAccountId,
      'is_reimbursable': isReimbursable,
      'reimbursed': reimbursed,
      'is_split': isSplit,
      'is_installment': isInstallment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'account_name': accountName,
      'category_name': categoryName,
    };
  }
}

