import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class CreditCardProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _creditCards = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get creditCards => _creditCards;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateAuth(AuthProvider auth) {
    if (!auth.isAuthenticated) {
      _creditCards = [];
      notifyListeners();
    }
  }

  Future<void> loadCreditCards() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get('/credit-cards');
      _creditCards = (response as List).map((e) => e as Map<String, dynamic>).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCreditCard(Map<String, dynamic> cardData) async {
    try {
      await _api.post('/credit-cards', cardData);
      await loadCreditCards();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>?> simulateMinimumPayment(int cardId) async {
    try {
      return await _api.get('/credit-cards/$cardId/simulate-minimum');
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}

