/// Modelo de Alerta/Notificación
class Alert {
  final int id;
  final int userId;
  final String type;
  final String priority; // low, medium, high
  final String title;
  final String message;
  final bool isRead;
  final String? actionUrl;
  final int? relatedTransactionId;
  final int? relatedBudgetId;
  final int? relatedGoalId;
  final int? relatedCreditCardId;
  final DateTime createdAt;
  final DateTime? readAt;

  Alert({
    required this.id,
    required this.userId,
    required this.type,
    required this.priority,
    required this.title,
    required this.message,
    this.isRead = false,
    this.actionUrl,
    this.relatedTransactionId,
    this.relatedBudgetId,
    this.relatedGoalId,
    this.relatedCreditCardId,
    required this.createdAt,
    this.readAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      priority: json['priority'] ?? 'medium',
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'] ?? false,
      actionUrl: json['action_url'],
      relatedTransactionId: json['related_transaction_id'],
      relatedBudgetId: json['related_budget_id'],
      relatedGoalId: json['related_goal_id'],
      relatedCreditCardId: json['related_credit_card_id'],
      createdAt: DateTime.parse(json['created_at']),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
    );
  }

  /// Icono según tipo
  String get iconName {
    switch (type) {
      case 'credit_card_cutoff':
        return 'credit_card';
      case 'credit_card_payment':
        return 'payment';
      case 'budget_warning':
      case 'budget_exceeded':
        return 'pie_chart';
      case 'goal_contribution':
      case 'goal_completed':
        return 'flag';
      case 'anomaly_detected':
        return 'warning';
      case 'weekly_summary':
      case 'monthly_report':
        return 'assessment';
      default:
        return 'notifications';
    }
  }

  /// Tiempo relativo desde creación
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours} horas';
    } else if (diff.inDays < 7) {
      return 'Hace ${diff.inDays} días';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

