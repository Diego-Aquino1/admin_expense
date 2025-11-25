import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/constants.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();
  String? _token;

  Future<void> setToken(String token) async {
    _token = token;
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    _token ??= await _storage.read(key: AppConstants.tokenKey);
    return _token;
  }

  Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: AppConstants.tokenKey);
  }

  Map<String, String> _headers({bool withAuth = true}) {
    final headers = {'Content-Type': 'application/json'};
    
    if (withAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  Future<dynamic> get(String endpoint, {bool withAuth = true}) async {
    try {
      await getToken();
      final response = await http
          .get(
            Uri.parse('${AppConstants.apiBaseUrl}$endpoint'),
            headers: _headers(withAuth: withAuth),
          )
          .timeout(AppConstants.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool withAuth = true,
  }) async {
    try {
      await getToken();
      final response = await http
          .post(
            Uri.parse('${AppConstants.apiBaseUrl}$endpoint'),
            headers: _headers(withAuth: withAuth),
            body: json.encode(body),
          )
          .timeout(AppConstants.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool withAuth = true,
  }) async {
    try {
      await getToken();
      final response = await http
          .put(
            Uri.parse('${AppConstants.apiBaseUrl}$endpoint'),
            headers: _headers(withAuth: withAuth),
            body: json.encode(body),
          )
          .timeout(AppConstants.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }

  Future<void> delete(String endpoint, {bool withAuth = true}) async {
    try {
      await getToken();
      final response = await http
          .delete(
            Uri.parse('${AppConstants.apiBaseUrl}$endpoint'),
            headers: _headers(withAuth: withAuth),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['detail'] ?? 'Error desconocido');
    }
  }
}

