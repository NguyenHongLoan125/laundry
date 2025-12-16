class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.token,
  });
}

class AuthResponse {
  final User user;
  final String message;
  final bool success;

  AuthResponse({
    required this.user,
    required this.message,
    required this.success,
  });
}