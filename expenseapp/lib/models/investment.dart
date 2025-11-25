import '../config/constants.dart';

/// Modelo de Inversión
class Investment {
  final int id;
  final int userId;
  final String name;
  final String type; // stocks, etf, crypto, bonds, real_estate, other
  final String? ticker;
  final double quantity;
  final double purchasePrice;
  final double currentPrice;
  final String currency;
  final DateTime purchaseDate;
  final String? broker;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  
  // Campos calculados
  final double? marketValue;
  final double? costBasis;
  final double? unrealizedGain;
  final double? unrealizedGainPercentage;
  final double? realizedGain;
  final double? totalDividends;

  Investment({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.ticker,
    required this.quantity,
    required this.purchasePrice,
    required this.currentPrice,
    this.currency = AppConstants.defaultCurrency,
    required this.purchaseDate,
    this.broker,
    this.notes,
    this.isActive = true,
    required this.createdAt,
    this.marketValue,
    this.costBasis,
    this.unrealizedGain,
    this.unrealizedGainPercentage,
    this.realizedGain,
    this.totalDividends,
  });

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      type: json['type'] ?? 'other',
      ticker: json['ticker'],
      quantity: (json['quantity'] ?? 0).toDouble(),
      purchasePrice: (json['purchase_price'] ?? 0).toDouble(),
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      currency: json['currency'] ?? AppConstants.defaultCurrency,
      purchaseDate: DateTime.parse(json['purchase_date']),
      broker: json['broker'],
      notes: json['notes'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      marketValue: json['market_value']?.toDouble(),
      costBasis: json['cost_basis']?.toDouble(),
      unrealizedGain: json['unrealized_gain']?.toDouble(),
      unrealizedGainPercentage: json['unrealized_gain_percentage']?.toDouble(),
      realizedGain: json['realized_gain']?.toDouble(),
      totalDividends: json['total_dividends']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'ticker': ticker,
      'quantity': quantity,
      'purchase_price': purchasePrice,
      'current_price': currentPrice,
      'currency': currency,
      'purchase_date': purchaseDate.toIso8601String(),
      'broker': broker,
      'notes': notes,
    };
  }

  /// Valor de mercado calculado
  double get calculatedMarketValue => marketValue ?? (quantity * currentPrice);

  /// Costo base calculado
  double get calculatedCostBasis => costBasis ?? (quantity * purchasePrice);

  /// Ganancia/Pérdida no realizada
  double get calculatedUnrealizedGain => 
      unrealizedGain ?? (calculatedMarketValue - calculatedCostBasis);

  /// Porcentaje de ganancia/pérdida
  double get calculatedGainPercentage {
    if (unrealizedGainPercentage != null) return unrealizedGainPercentage!;
    if (calculatedCostBasis == 0) return 0;
    return (calculatedUnrealizedGain / calculatedCostBasis) * 100;
  }

  /// Es ganancia o pérdida
  bool get isProfit => calculatedUnrealizedGain >= 0;

  /// Tipo como texto
  String get typeText {
    switch (type) {
      case 'stocks':
        return 'Acciones';
      case 'etf':
        return 'ETF';
      case 'crypto':
        return 'Criptomonedas';
      case 'bonds':
        return 'Bonos';
      case 'real_estate':
        return 'Bienes Raíces';
      default:
        return 'Otro';
    }
  }
}

/// Dividendo o rendimiento de inversión
class InvestmentDividend {
  final int id;
  final int investmentId;
  final double amount;
  final DateTime date;
  final String? notes;

  InvestmentDividend({
    required this.id,
    required this.investmentId,
    required this.amount,
    required this.date,
    this.notes,
  });

  factory InvestmentDividend.fromJson(Map<String, dynamic> json) {
    return InvestmentDividend(
      id: json['id'],
      investmentId: json['investment_id'],
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }
}

