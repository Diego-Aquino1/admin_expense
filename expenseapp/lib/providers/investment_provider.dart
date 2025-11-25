import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class InvestmentProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _investments = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get investments => _investments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalMarketValue {
    return _investments.fold(0.0, (sum, inv) => sum + (inv['market_value'] ?? 0.0));
  }

  double get totalGain {
    return _investments.fold(0.0, (sum, inv) => sum + (inv['unrealized_gain'] ?? 0.0));
  }

  void updateAuth(AuthProvider auth) {
    if (!auth.isAuthenticated) {
      _investments = [];
      notifyListeners();
    }
  }

  Future<void> loadInvestments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get('/investments');
      _investments = (response as List).map((e) => e as Map<String, dynamic>).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createInvestment(Map<String, dynamic> investmentData) async {
    try {
      await _api.post('/investments', investmentData);
      await loadInvestments();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

