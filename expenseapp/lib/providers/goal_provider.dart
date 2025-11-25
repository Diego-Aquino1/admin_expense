import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class GoalProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _goals = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get goals => _goals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateAuth(AuthProvider auth) {
    if (!auth.isAuthenticated) {
      _goals = [];
      notifyListeners();
    }
  }

  Future<void> loadGoals({bool includeCompleted = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get('/goals?include_completed=$includeCompleted');
      _goals = (response as List).map((e) => e as Map<String, dynamic>).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createGoal(Map<String, dynamic> goalData) async {
    try {
      await _api.post('/goals', goalData);
      await loadGoals();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> addContribution(int goalId, double amount, String? notes) async {
    try {
      await _api.post('/goals/$goalId/contribute', {
        'goal_id': goalId,
        'amount': amount,
        'date': DateTime.now().toIso8601String(),
        'notes': notes,
      });
      await loadGoals();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

