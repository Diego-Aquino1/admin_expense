/// Modelo de Presupuesto
class Budget {
  final int id;
  final int userId;
  final String name;
  final double amount;
  final String period; // weekly, biweekly, monthly, annual
  final int? categoryId;
  final String? categoryName;
  final String? tagFilter;
  final int? accountId;
  final bool isGlobal;
  final bool rolloverEnabled;
  final double? rolloverAmount;
  final int alertAtPercentage;
  final bool alertOnExceed;
  final DateTime startDate;
  final bool isActive;
  final DateTime createdAt;
  
  // Campos calculados
  final double? spent;
  final double? available;
  final double? percentageUsed;
  final DateTime? depletionDate;

  Budget({
    required this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.period,
    this.categoryId,
    this.categoryName,
    this.tagFilter,
    this.accountId,
    this.isGlobal = false,
    this.rolloverEnabled = false,
    this.rolloverAmount,
    this.alertAtPercentage = 80,
    this.alertOnExceed = true,
    required this.startDate,
    this.isActive = true,
    required this.createdAt,
    this.spent,
    this.available,
    this.percentageUsed,
    this.depletionDate,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      amount: (json['amount'] ?? 0).toDouble(),
      period: json['period'] ?? 'monthly',
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      tagFilter: json['tag_filter'],
      accountId: json['account_id'],
      isGlobal: json['is_global'] ?? false,
      rolloverEnabled: json['rollover_enabled'] ?? false,
      rolloverAmount: json['rollover_amount']?.toDouble(),
      alertAtPercentage: json['alert_at_percentage'] ?? 80,
      alertOnExceed: json['alert_on_exceed'] ?? true,
      startDate: DateTime.parse(json['start_date']),
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      spent: json['spent']?.toDouble(),
      available: json['available']?.toDouble(),
      percentageUsed: json['percentage_used']?.toDouble(),
      depletionDate: json['depletion_date'] != null 
          ? DateTime.parse(json['depletion_date']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'amount': amount,
      'period': period,
      'category_id': categoryId,
      'tag_filter': tagFilter,
      'account_id': accountId,
      'is_global': isGlobal,
      'rollover_enabled': rolloverEnabled,
      'rollover_amount': rolloverAmount,
      'alert_at_percentage': alertAtPercentage,
      'alert_on_exceed': alertOnExceed,
      'start_date': startDate.toIso8601String(),
      'is_active': isActive,
    };
  }

  /// Obtener estado del presupuesto como texto
  String get statusText {
    if (percentageUsed == null) return 'Sin datos';
    if (percentageUsed! >= 100) return 'Excedido';
    if (percentageUsed! >= alertAtPercentage) return 'Precaución';
    return 'En control';
  }

  /// Obtener el límite efectivo (con rollover)
  double get effectiveLimit => amount + (rolloverAmount ?? 0);
}

