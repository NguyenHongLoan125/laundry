import 'package:laundry_app/src/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
  Future<bool> verifyOTP(String email, String otp);
  Future<bool> resendOTP(String email);
}