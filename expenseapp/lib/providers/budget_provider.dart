import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class BudgetProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _budgets = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get budgets => _budgets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateAuth(AuthProvider auth) {
    if (!auth.isAuthenticated) {
      _budgets = [];
      notifyListeners();
    }
  }

  Future<void> loadBudgets() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get('/budgets');
      _budgets = (response as List).map((e) => e as Map<String, dynamic>).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBudget(Map<String, dynamic> budgetData) async {
    try {
      await _api.post('/budgets', budgetData);
      await loadBudgets();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

