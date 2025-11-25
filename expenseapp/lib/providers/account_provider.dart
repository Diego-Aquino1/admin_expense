import 'package:flutter/foundation.dart';

import '../services/api_service.dart';
import '../models/account.dart';
import 'auth_provider.dart';

class AccountProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  
  List<Account> _accounts = [];
  bool _isLoading = false;
  String? _error;

  List<Account> get accounts => _accounts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalBalance {
    return _accounts
        .where((a) => !a.excludeFromTotals && !a.isArchived)
        .fold(0.0, (sum, account) => sum + (account.currentBalance ?? 0));
  }

  void updateAuth(AuthProvider auth) {
    if (!auth.isAuthenticated) {
      _accounts = [];
      notifyListeners();
    }
  }

  Future<void> loadAccounts({bool includeArchived = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.get(
        '/accounts?include_archived=$includeArchived',
      );

      _accounts = (response as List)
          .map((json) => Account.fromJson(json))
          .toList();

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Account?> createAccount(Map<String, dynamic> accountData) async {
    try {
      final response = await _api.post('/accounts', accountData);
      final account = Account.fromJson(response);
      
      _accounts.add(account);
      notifyListeners();
      
      return account;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateAccount(int id, Map<String, dynamic> updates) async {
    try {
      final response = await _api.put('/accounts/$id', updates);
      final updatedAccount = Account.fromJson(response);
      
      final index = _accounts.indexWhere((a) => a.id == id);
      if (index != -1) {
        _accounts[index] = updatedAccount;
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Account? getAccountById(int id) {
    try {
      return _accounts.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Account> getAccountsByType(String type) {
    return _accounts.where((a) => a.type == type && !a.isArchived).toList();
  }
}

