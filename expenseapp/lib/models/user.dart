/// Modelo de Usuario
class User {
  final int id;
  final String email;
  final String username;
  final String? fullName;
  final String baseCurrency;
  final String dateFormat;
  final String theme;
  final String accentColor;
  final DateTime createdAt;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    required this.baseCurrency,
    required this.dateFormat,
    required this.theme,
    required this.accentColor,
    required this.createdAt,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      fullName: json['full_name'],
      baseCurrency: json['base_currency'],
      dateFormat: json['date_format'],
      theme: json['theme'],
      accentColor: json['accent_color'],
      createdAt: DateTime.parse(json['created_at']),
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'base_currency': baseCurrency,
      'date_format': dateFormat,
      'theme': theme,
      'accent_color': accentColor,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };
  }
}

