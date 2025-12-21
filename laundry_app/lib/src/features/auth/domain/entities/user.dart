class User {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? image;
  final String? token;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.image,
    this.token,
  });
}

class AuthResponse {
  final User? user;
  final String message;
  final String code;
  final String? otp; // For register response

  AuthResponse({
    this.user,
    required this.message,
    required this.code,
    this.otp,
  });

  bool get success => code == "success";
}