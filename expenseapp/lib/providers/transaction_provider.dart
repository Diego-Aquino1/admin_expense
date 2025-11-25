import 'package:flutter/foundation.dart';

import '../services/api_service.dart';
import '../models/transaction.dart';
import 'auth_provider.dart';

class TransactionProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateAuth(AuthProvider auth) {
    if (!auth.isAuthenticated) {
      _transactions = [];
      notifyListeners();
    }
  }

  Future<void> loadTransactions({
    int? accountId,
    int? categoryId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };

      if (accountId != null) queryParams['account_id'] = accountId.toString();
      if (categoryId != null) queryParams['category_id'] = categoryId.toString();
      if (type != null) queryParams['type'] = type;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

      final query = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');

      final response = await _api.get('/transactions?$query');

      _transactions = (response as List)
          .map((json) => Transaction.fromJson(json))
          .toList();

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Transaction?> createTransaction(Map<String, dynamic> transactionData) async {
    try {
      final response = await _api.post('/transactions', transactionData);
      final transaction = Transaction.fromJson(response);
      
      _transactions.insert(0, transaction);
      notifyListeners();
      
      return transaction;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateTransaction(int id, Map<String, dynamic> updates) async {
    try {
      final response = await _api.put('/transactions/$id', updates);
      final updatedTransaction = Transaction.fromJson(response);
      
      final index = _transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transactions[index] = updatedTransaction;
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTransaction(int id) async {
    try {
      await _api.delete('/transactions/$id');
      
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Estadísticas rápidas
  double getTotalByType(String type) {
    return _transactions
        .where((t) => t.type == type)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  List<Transaction> getRecentTransactions(int count) {
    return _transactions.take(count).toList();
  }
}

