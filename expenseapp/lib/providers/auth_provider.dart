import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../models/user.dart';
import '../config/constants.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(AppConstants.userKey);
      final token = await _api.getToken();

      if (userData != null && token != null) {
        _user = User.fromJson(json.decode(userData));
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.post(
        '/auth/login',
        {'username': username, 'password': password},
        withAuth: false,
      );

      await _api.setToken(response['access_token']);
      _user = User.fromJson(response['user']);
      _isAuthenticated = true;

      // Guardar usuario
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.userKey,
        json.encode(_user!.toJson()),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.post(
        '/auth/register',
        {
          'email': email,
          'username': username,
          'password': password,
        },
        withAuth: false,
      );

      await _api.setToken(response['access_token']);
      _user = User.fromJson(response['user']);
      _isAuthenticated = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.userKey,
        json.encode(_user!.toJson()),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    await _api.clearToken();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userKey);

    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    try {
      final response = await _api.put('/auth/me', updates);
      _user = User.fromJson(response);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.userKey,
        json.encode(_user!.toJson()),
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}

