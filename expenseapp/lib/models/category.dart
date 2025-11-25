/// Modelo de Categoría
class Category {
  final int id;
  final int userId;
  final int? parentId;
  final String name;
  final String type;
  final String? icon;
  final String? color;
  final bool isSystem;
  final bool isHidden;
  final bool isIncome;
  final int displayOrder;
  final DateTime createdAt;
  final List<Category>? subcategories;

  Category({
    required this.id,
    required this.userId,
    this.parentId,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    this.isSystem = false,
    this.isHidden = false,
    this.isIncome = false,
    this.displayOrder = 0,
    required this.createdAt,
    this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      parentId: json['parent_id'],
      name: json['name'] ?? '',
      type: json['type'] ?? 'expense',
      icon: json['icon'],
      color: json['color'],
      isSystem: json['is_system'] ?? false,
      isHidden: json['is_hidden'] ?? false,
      isIncome: json['is_income'] ?? json['type'] == 'income',
      displayOrder: json['display_order'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List).map((e) => Category.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'parent_id': parentId,
      'name': name,
      'type': type,
      'icon': icon,
      'color': color,
      'is_system': isSystem,
      'is_hidden': isHidden,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'subcategories': subcategories?.map((e) => e.toJson()).toList(),
    };
  }
}

