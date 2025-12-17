import 'package:laundry_app/src/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });
  Future<AuthResponse> verifyOTP(String otp);
  Future<bool> resendOTP(String email);
  Future<User> getProfile();
  Future<AuthResponse> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    String? imagePath,
  });
  Future<AuthResponse> logout();
}