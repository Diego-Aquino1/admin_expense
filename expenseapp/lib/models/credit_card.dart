/// Modelo de Tarjeta de Crédito
class CreditCard {
  final int id;
  final int userId;
  final int accountId;
  final String cardName;
  final String? lastFourDigits;
  final double creditLimit;
  final int cutoffDay;
  final int paymentDueDay;
  final double annualInterestRate;
  final double minimumPaymentPercentage;
  final String? color;
  final String? icon;
  final int alertDaysBeforeCutoff;
  final int alertDaysBeforePayment;
  final bool isActive;
  final DateTime createdAt;
  
  // Campos calculados
  final double? balanceAtCutoff;
  final double? postCutoffBalance;
  final double? availableCredit;
  final double? totalDebt;
  final double? minimumPayment;
  final double? installmentDebt;
  final DateTime? nextCutoffDate;
  final DateTime? nextPaymentDate;

  CreditCard({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.cardName,
    this.lastFourDigits,
    required this.creditLimit,
    required this.cutoffDay,
    required this.paymentDueDay,
    required this.annualInterestRate,
    this.minimumPaymentPercentage = 5.0,
    this.color,
    this.icon,
    this.alertDaysBeforeCutoff = 3,
    this.alertDaysBeforePayment = 5,
    this.isActive = true,
    required this.createdAt,
    this.balanceAtCutoff,
    this.postCutoffBalance,
    this.availableCredit,
    this.totalDebt,
    this.minimumPayment,
    this.installmentDebt,
    this.nextCutoffDate,
    this.nextPaymentDate,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['id'],
      userId: json['user_id'],
      accountId: json['account_id'],
      cardName: json['card_name'],
      lastFourDigits: json['last_four_digits'],
      creditLimit: (json['credit_limit'] ?? 0).toDouble(),
      cutoffDay: json['cutoff_day'] ?? 1,
      paymentDueDay: json['payment_due_day'] ?? 15,
      annualInterestRate: (json['annual_interest_rate'] ?? 0).toDouble(),
      minimumPaymentPercentage: (json['minimum_payment_percentage'] ?? 5.0).toDouble(),
      color: json['color'],
      icon: json['icon'],
      alertDaysBeforeCutoff: json['alert_days_before_cutoff'] ?? 3,
      alertDaysBeforePayment: json['alert_days_before_payment'] ?? 5,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      balanceAtCutoff: json['balance_at_cutoff']?.toDouble(),
      postCutoffBalance: json['post_cutoff_balance']?.toDouble(),
      availableCredit: json['available_credit']?.toDouble(),
      totalDebt: json['total_debt']?.toDouble(),
      minimumPayment: json['minimum_payment']?.toDouble(),
      installmentDebt: json['installment_debt']?.toDouble(),
      nextCutoffDate: json['next_cutoff_date'] != null 
          ? DateTime.parse(json['next_cutoff_date']) 
          : null,
      nextPaymentDate: json['next_payment_date'] != null 
          ? DateTime.parse(json['next_payment_date']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'account_id': accountId,
      'card_name': cardName,
      'last_four_digits': lastFourDigits,
      'credit_limit': creditLimit,
      'cutoff_day': cutoffDay,
      'payment_due_day': paymentDueDay,
      'annual_interest_rate': annualInterestRate,
      'minimum_payment_percentage': minimumPaymentPercentage,
      'color': color,
      'icon': icon,
      'alert_days_before_cutoff': alertDaysBeforeCutoff,
      'alert_days_before_payment': alertDaysBeforePayment,
    };
  }

  /// Porcentaje de uso de la línea de crédito
  double get usagePercentage {
    if (creditLimit == 0) return 0;
    final totalUsed = (balanceAtCutoff ?? 0) + (postCutoffBalance ?? 0);
    return (totalUsed / creditLimit) * 100;
  }

  /// Días hasta el próximo corte
  int? get daysToCutoff {
    if (nextCutoffDate == null) return null;
    return nextCutoffDate!.difference(DateTime.now()).inDays;
  }

  /// Días hasta el próximo pago
  int? get daysToPayment {
    if (nextPaymentDate == null) return null;
    return nextPaymentDate!.difference(DateTime.now()).inDays;
  }

  /// Nombre formateado
  String get displayName {
    if (lastFourDigits != null) {
      return '$cardName •••• $lastFourDigits';
    }
    return cardName;
  }
}

/// Compra a Meses Sin Intereses
class InstallmentPurchase {
  final int id;
  final int creditCardId;
  final double totalAmount;
  final int totalInstallments;
  final int currentInstallment;
  final double installmentAmount;
  final String description;
  final DateTime purchaseDate;
  final DateTime? startDate;
  final bool isActive;
  final double remainingAmount;

  InstallmentPurchase({
    required this.id,
    required this.creditCardId,
    required this.totalAmount,
    required this.totalInstallments,
    required this.currentInstallment,
    required this.installmentAmount,
    required this.description,
    required this.purchaseDate,
    this.startDate,
    this.isActive = true,
    required this.remainingAmount,
  });

  factory InstallmentPurchase.fromJson(Map<String, dynamic> json) {
    return InstallmentPurchase(
      id: json['id'],
      creditCardId: json['credit_card_id'],
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      totalInstallments: json['total_installments'] ?? 1,
      currentInstallment: json['current_installment'] ?? 1,
      installmentAmount: (json['installment_amount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      purchaseDate: DateTime.parse(json['purchase_date']),
      startDate: json['start_date'] != null 
          ? DateTime.parse(json['start_date']) 
          : null,
      isActive: json['is_active'] ?? true,
      remainingAmount: (json['remaining_amount'] ?? 0).toDouble(),
    );
  }

  /// Cuotas restantes
  int get remainingInstallments => totalInstallments - currentInstallment + 1;

  /// Progreso de pago
  double get paymentProgress => (currentInstallment / totalInstallments) * 100;
}

