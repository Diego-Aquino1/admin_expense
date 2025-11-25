import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/alert.dart';

class AlertProvider with ChangeNotifier {
  final ApiService _apiService;
  
  List<Alert> _alerts = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  AlertProvider(this._apiService);

  // Getters
  List<Alert> get alerts => _alerts;
  List<Alert> get unreadAlerts => _alerts.where((a) => !a.isRead).toList();
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Cargar alertas
  Future<void> loadAlerts({bool unreadOnly = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final params = unreadOnly ? '?unread_only=true' : '';
      final response = await _apiService.get('/alerts$params');
      
      if (response is List) {
        _alerts = (response)
            .map<Alert>((json) => Alert.fromJson(json as Map<String, dynamic>))
            .toList();
        _unreadCount = _alerts.where((a) => !a.isRead).length;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtener conteo de no leídas
  Future<void> loadUnreadCount() async {
    try {
      final response = await _apiService.get('/alerts/unread-count');
      
      if (response != null && response is Map) {
        _unreadCount = response['count'] ?? 0;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading unread count: $e');
    }
  }

  /// Marcar alerta como leída
  Future<void> markAsRead(int alertId) async {
    try {
      await _apiService.put('/alerts/$alertId/read', {});
      
      final index = _alerts.indexWhere((a) => a.id == alertId);
      if (index != -1) {
        // Recrear la alerta con isRead = true
        final oldAlert = _alerts[index];
        _alerts[index] = Alert(
          id: oldAlert.id,
          userId: oldAlert.userId,
          type: oldAlert.type,
          priority: oldAlert.priority,
          title: oldAlert.title,
          message: oldAlert.message,
          isRead: true,
          actionUrl: oldAlert.actionUrl,
          relatedTransactionId: oldAlert.relatedTransactionId,
          relatedBudgetId: oldAlert.relatedBudgetId,
          relatedGoalId: oldAlert.relatedGoalId,
          relatedCreditCardId: oldAlert.relatedCreditCardId,
          createdAt: oldAlert.createdAt,
          readAt: DateTime.now(),
        );
        _unreadCount = _alerts.where((a) => !a.isRead).length;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Marcar todas como leídas
  Future<void> markAllAsRead() async {
    try {
      await _apiService.put('/alerts/read-all', {});
      
      // Actualizar todas las alertas localmente
      _alerts = _alerts.map((a) => Alert(
        id: a.id,
        userId: a.userId,
        type: a.type,
        priority: a.priority,
        title: a.title,
        message: a.message,
        isRead: true,
        actionUrl: a.actionUrl,
        relatedTransactionId: a.relatedTransactionId,
        relatedBudgetId: a.relatedBudgetId,
        relatedGoalId: a.relatedGoalId,
        relatedCreditCardId: a.relatedCreditCardId,
        createdAt: a.createdAt,
        readAt: DateTime.now(),
      )).toList();
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Generar alertas (trigger manual)
  Future<int> generateAlerts() async {
    try {
      final response = await _apiService.post('/alerts/generate', {});
      
      final generated = response['generated'] ?? 0;
      await loadAlerts();
      return generated is int ? generated : 0;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
    return 0;
  }

  /// Limpiar estado
  void clear() {
    _alerts = [];
    _unreadCount = 0;
    _error = null;
    notifyListeners();
  }
}
