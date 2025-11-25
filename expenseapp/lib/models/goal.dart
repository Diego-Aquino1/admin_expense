/// Modelo de Meta Financiera
class Goal {
  final int id;
  final int userId;
  final String name;
  final String type; // savings, debt, investment, net_worth
  final double targetAmount;
  final double currentAmount;
  final double? initialAmount;
  final DateTime? targetDate;
  final int? linkedAccountId;
  final double? autoContributionAmount;
  final String? autoContributionFrequency;
  final String? icon;
  final String? color;
  final String priority; // high, medium, low
  final bool isCompleted;
  final bool isArchived;
  final DateTime createdAt;
  
  // Campos calculados
  final double? progressPercentage;
  final DateTime? projectedCompletionDate;
  final double? requiredMonthlyContribution;

  Goal({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.targetAmount,
    required this.currentAmount,
    this.initialAmount,
    this.targetDate,
    this.linkedAccountId,
    this.autoContributionAmount,
    this.autoContributionFrequency,
    this.icon,
    this.color,
    this.priority = 'medium',
    this.isCompleted = false,
    this.isArchived = false,
    required this.createdAt,
    this.progressPercentage,
    this.projectedCompletionDate,
    this.requiredMonthlyContribution,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      type: json['type'] ?? 'savings',
      targetAmount: (json['target_amount'] ?? 0).toDouble(),
      currentAmount: (json['current_amount'] ?? 0).toDouble(),
      initialAmount: json['initial_amount']?.toDouble(),
      targetDate: json['target_date'] != null 
          ? DateTime.parse(json['target_date']) 
          : null,
      linkedAccountId: json['linked_account_id'],
      autoContributionAmount: json['auto_contribution_amount']?.toDouble(),
      autoContributionFrequency: json['auto_contribution_frequency'],
      icon: json['icon'],
      color: json['color'],
      priority: json['priority'] ?? 'medium',
      isCompleted: json['is_completed'] ?? false,
      isArchived: json['is_archived'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      progressPercentage: json['progress_percentage']?.toDouble(),
      projectedCompletionDate: json['projected_completion_date'] != null 
          ? DateTime.parse(json['projected_completion_date']) 
          : null,
      requiredMonthlyContribution: json['required_monthly_contribution']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'initial_amount': initialAmount,
      'target_date': targetDate?.toIso8601String(),
      'linked_account_id': linkedAccountId,
      'auto_contribution_amount': autoContributionAmount,
      'auto_contribution_frequency': autoContributionFrequency,
      'icon': icon,
      'color': color,
      'priority': priority,
    };
  }

  /// Calcular progreso
  double get progress {
    if (progressPercentage != null) return progressPercentage!;
    if (targetAmount == 0) return 0;
    return (currentAmount / targetAmount) * 100;
  }

  /// Monto restante
  double get remaining => targetAmount - currentAmount;

  /// Días restantes hasta la fecha límite
  int? get daysRemaining {
    if (targetDate == null) return null;
    return targetDate!.difference(DateTime.now()).inDays;
  }

  /// Tipo como texto legible
  String get typeText {
    switch (type) {
      case 'savings':
        return 'Ahorro';
      case 'debt':
        return 'Pago de Deuda';
      case 'investment':
        return 'Inversión';
      case 'net_worth':
        return 'Patrimonio';
      default:
        return 'Meta';
    }
  }
}

