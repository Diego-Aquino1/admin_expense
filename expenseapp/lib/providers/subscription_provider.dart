import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/subscription.dart';

class SubscriptionProvider with ChangeNotifier {
  final ApiService _apiService;
  
  List<Subscription> _subscriptions = [];
  List<DetectedSubscription> _detectedSubscriptions = [];
  double _monthlyTotal = 0;
  double _annualTotal = 0;
  bool _isLoading = false;
  String? _error;

  SubscriptionProvider(this._apiService);

  // Getters
  List<Subscription> get subscriptions => _subscriptions;
  List<Subscription> get activeSubscriptions => 
      _subscriptions.where((s) => s.isActive).toList();
  List<DetectedSubscription> get detectedSubscriptions => _detectedSubscriptions;
  double get monthlyTotal => _monthlyTotal;
  double get annualTotal => _annualTotal;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Cargar suscripciones
  Future<void> loadSubscriptions({bool activeOnly = true}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final params = activeOnly ? '?active_only=true' : '';
      final response = await _apiService.get('/subscriptions$params');
      
      if (response is List) {
        _subscriptions = (response)
            .map<Subscription>((json) => Subscription.fromJson(json as Map<String, dynamic>))
            .toList();
        _calculateTotals();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar resumen de suscripciones
  Future<void> loadSummary() async {
    try {
      final response = await _apiService.get('/subscriptions/summary');
      
      if (response != null && response is Map) {
        _monthlyTotal = (response['monthly_total'] ?? 0).toDouble();
        _annualTotal = (response['annual_total'] ?? 0).toDouble();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Detectar suscripciones
  Future<void> detectSubscriptions({int months = 3}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/subscriptions/detect?months=$months');
      
      if (response != null && response is Map && response['detected'] != null) {
        _detectedSubscriptions = (response['detected'] as List)
            .map<DetectedSubscription>((json) => DetectedSubscription.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crear suscripción
  Future<Subscription?> createSubscription(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/subscriptions', data);
      final subscription = Subscription.fromJson(response);
      _subscriptions.add(subscription);
      _calculateTotals();
      notifyListeners();
      return subscription;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
    return null;
  }

  /// Confirmar suscripción detectada
  Future<Subscription?> confirmDetectedSubscription(DetectedSubscription detected) async {
    try {
      final data = {
        'merchant': detected.merchant,
        'amount': detected.amount,
        'frequency': detected.frequency,
      };
      
      final response = await _apiService.post('/subscriptions/confirm-detected', data);
      final subscription = Subscription.fromJson(response);
      _subscriptions.add(subscription);
      _detectedSubscriptions.removeWhere((d) => d.merchant == detected.merchant);
      _calculateTotals();
      notifyListeners();
      return subscription;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
    return null;
  }

  /// Actualizar suscripción
  Future<Subscription?> updateSubscription(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put('/subscriptions/$id', data);
      final subscription = Subscription.fromJson(response);
      final index = _subscriptions.indexWhere((s) => s.id == id);
      if (index != -1) {
        _subscriptions[index] = subscription;
        _calculateTotals();
        notifyListeners();
      }
      return subscription;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
    return null;
  }

  /// Cancelar suscripción
  Future<bool> cancelSubscription(int id) async {
    try {
      await _apiService.delete('/subscriptions/$id');
      _subscriptions.removeWhere((s) => s.id == id);
      _calculateTotals();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _calculateTotals() {
    _monthlyTotal = activeSubscriptions.fold(0, (sum, s) => sum + s.monthlyAmount);
    _annualTotal = _monthlyTotal * 12;
  }

  /// Limpiar estado
  void clear() {
    _subscriptions = [];
    _detectedSubscriptions = [];
    _monthlyTotal = 0;
    _annualTotal = 0;
    _error = null;
    notifyListeners();
  }
}
