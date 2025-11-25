/// Modelo de Cuenta
class Account {
  final int id;
  final int userId;
  final String name;
  final String type;
  final double initialBalance;
  final String currency;
  final String color;
  final String icon;
  final bool isDefault;
  final bool isArchived;
  final bool excludeFromTotals;
  final int displayOrder;
  final DateTime createdAt;
  double? currentBalance;

  Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.initialBalance,
    required this.currency,
    required this.color,
    required this.icon,
    required this.isDefault,
    required this.isArchived,
    required this.excludeFromTotals,
    required this.displayOrder,
    required this.createdAt,
    this.currentBalance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      type: json['type'],
      initialBalance: (json['initial_balance'] ?? 0).toDouble(),
      currency: json['currency'],
      color: json['color'],
      icon: json['icon'],
      isDefault: json['is_default'],
      isArchived: json['is_archived'],
      excludeFromTotals: json['exclude_from_totals'],
      displayOrder: json['display_order'],
      createdAt: DateTime.parse(json['created_at']),
      currentBalance: json['current_balance']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type,
      'initial_balance': initialBalance,
      'currency': currency,
      'color': color,
      'icon': icon,
      'is_default': isDefault,
      'is_archived': isArchived,
      'exclude_from_totals': excludeFromTotals,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'current_balance': currentBalance,
    };
  }
}

