import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/category.dart' as models;

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService;
  
  List<models.Category> _categories = [];
  List<models.Category> _expenseCategories = [];
  List<models.Category> _incomeCategories = [];
  bool _isLoading = false;
  String? _error;

  CategoryProvider(this._apiService);

  // Getters
  List<models.Category> get categories => _categories;
  List<models.Category> get expenseCategories => _expenseCategories;
  List<models.Category> get incomeCategories => _incomeCategories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Cargar todas las categorías
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/categories');
      
      if (response is List) {
        _categories = (response)
            .map<models.Category>((json) => models.Category.fromJson(json as Map<String, dynamic>))
            .toList();
        _expenseCategories = _categories.where((c) => !c.isIncome).toList();
        _incomeCategories = _categories.where((c) => c.isIncome).toList();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtener categoría por ID
  models.Category? getCategoryById(int id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Obtener subcategorías de una categoría
  List<models.Category> getSubcategories(int parentId) {
    return _categories.where((c) => c.parentId == parentId).toList();
  }

  /// Crear categoría
  Future<models.Category?> createCategory(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/categories', data);
      final category = models.Category.fromJson(response);
      _categories.add(category);
      _updateFilteredLists();
      notifyListeners();
      return category;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
    return null;
  }

  /// Actualizar categoría
  Future<models.Category?> updateCategory(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put('/categories/$id', data);
      final category = models.Category.fromJson(response);
      final index = _categories.indexWhere((c) => c.id == id);
      if (index != -1) {
        _categories[index] = category;
        _updateFilteredLists();
        notifyListeners();
      }
      return category;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
    return null;
  }

  /// Eliminar categoría
  Future<bool> deleteCategory(int id) async {
    try {
      await _apiService.delete('/categories/$id');
      _categories.removeWhere((c) => c.id == id);
      _updateFilteredLists();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _updateFilteredLists() {
    _expenseCategories = _categories.where((c) => !c.isIncome).toList();
    _incomeCategories = _categories.where((c) => c.isIncome).toList();
  }

  /// Limpiar estado
  void clear() {
    _categories = [];
    _expenseCategories = [];
    _incomeCategories = [];
    _error = null;
    notifyListeners();
  }
}
