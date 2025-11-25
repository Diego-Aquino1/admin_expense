import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class AnalyticsProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  Map<String, dynamic>? _dashboardSummary;
  List<Map<String, dynamic>> _expensesByCategory = [];
  List<Map<String, dynamic>> _monthlyTrend = [];
  Map<String, dynamic>? _netWorth;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get dashboardSummary => _dashboardSummary;
  List<Map<String, dynamic>> get expensesByCategory => _expensesByCategory;
  List<Map<String, dynamic>> get monthlyTrend => _monthlyTrend;
  Map<String, dynamic>? get netWorth => _netWorth;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateAuth(AuthProvider auth) {
    if (!auth.isAuthenticated) {
      _dashboardSummary = null;
      _expensesByCategory = [];
      _monthlyTrend = [];
      _netWorth = null;
      notifyListeners();
    }
  }

  Future<void> loadDashboardSummary() async {
    _isLoading = true;
    notifyListeners();

    try {
      _dashboardSummary = await _api.get('/analytics/dashboard');
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadExpensesByCategory(DateTime startDate, DateTime endDate) async {
    try {
      final start = startDate.toIso8601String().split('T')[0];
      final end = endDate.toIso8601String().split('T')[0];
      
      final response = await _api.get('/analytics/expenses-by-category?start_date=$start&end_date=$end');
      _expensesByCategory = (response as List).map((e) => e as Map<String, dynamic>).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadMonthlyTrend({int months = 6}) async {
    try {
      final response = await _api.get('/analytics/monthly-trend?months=$months');
      _monthlyTrend = (response as List).map((e) => e as Map<String, dynamic>).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadNetWorth() async {
    try {
      _netWorth = await _api.get('/analytics/net-worth');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

