import '../config/constants.dart';

/// Modelo de Suscripción
class Subscription {
  final int id;
  final int userId;
  final String name;
  final double amount;
  final String currency;
  final String frequency; // monthly, annual, weekly, biweekly
  final int? billingDay;
  final int? categoryId;
  final int? accountId;
  final String? url;
  final String? notes;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? nextBillingDate;
  final bool isActive;
  final bool isDetected;
  final DateTime createdAt;

  Subscription({
    required this.id,
    required this.userId,
    required this.name,
    required this.amount,
    this.currency = AppConstants.defaultCurrency,
    this.frequency = 'monthly',
    this.billingDay,
    this.categoryId,
    this.accountId,
    this.url,
    this.notes,
    this.startDate,
    this.endDate,
    this.nextBillingDate,
    this.isActive = true,
    this.isDetected = false,
    required this.createdAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? AppConstants.defaultCurrency,
      frequency: json['frequency'] ?? 'monthly',
      billingDay: json['billing_day'],
      categoryId: json['category_id'],
      accountId: json['account_id'],
      url: json['url'],
      notes: json['notes'],
      startDate: json['start_date'] != null 
          ? DateTime.parse(json['start_date']) 
          : null,
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date']) 
          : null,
      nextBillingDate: json['next_billing_date'] != null 
          ? DateTime.parse(json['next_billing_date']) 
          : null,
      isActive: json['is_active'] ?? true,
      isDetected: json['is_detected'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'currency': currency,
      'frequency': frequency,
      'billing_day': billingDay,
      'category_id': categoryId,
      'account_id': accountId,
      'url': url,
      'notes': notes,
      'start_date': startDate?.toIso8601String(),
      'next_billing_date': nextBillingDate?.toIso8601String(),
    };
  }

  /// Frecuencia como texto
  String get frequencyText {
    switch (frequency) {
      case 'weekly':
        return 'Semanal';
      case 'biweekly':
        return 'Quincenal';
      case 'monthly':
        return 'Mensual';
      case 'annual':
        return 'Anual';
      default:
        return frequency;
    }
  }

  /// Monto mensualizado
  double get monthlyAmount {
    switch (frequency) {
      case 'weekly':
        return amount * 4.33;
      case 'biweekly':
        return amount * 2;
      case 'monthly':
        return amount;
      case 'annual':
        return amount / 12;
      default:
        return amount;
    }
  }

  /// Días hasta próximo cargo
  int? get daysUntilNextBilling {
    if (nextBillingDate == null) return null;
    return nextBillingDate!.difference(DateTime.now()).inDays;
  }
}

/// Suscripción detectada (antes de confirmar)
class DetectedSubscription {
  final String merchant;
  final double amount;
  final String frequency;
  final int occurrences;
  final double avgIntervalDays;
  final double confidence;
  final String lastCharge;
  final String nextChargeEstimate;

  DetectedSubscription({
    required this.merchant,
    required this.amount,
    required this.frequency,
    required this.occurrences,
    required this.avgIntervalDays,
    required this.confidence,
    required this.lastCharge,
    required this.nextChargeEstimate,
  });

  factory DetectedSubscription.fromJson(Map<String, dynamic> json) {
    return DetectedSubscription(
      merchant: json['merchant'],
      amount: (json['amount'] ?? 0).toDouble(),
      frequency: json['frequency'] ?? 'monthly',
      occurrences: json['occurrences'] ?? 0,
      avgIntervalDays: (json['avg_interval_days'] ?? 0).toDouble(),
      confidence: (json['confidence'] ?? 0).toDouble(),
      lastCharge: json['last_charge'] ?? '',
      nextChargeEstimate: json['next_charge_estimate'] ?? '',
    );
  }

  /// Confianza como porcentaje
  int get confidencePercentage => (confidence * 100).round();
}

