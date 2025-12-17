import 'package:laundry_app/src/features/auth/domain/entities/user.dart';
import 'package:laundry_app/src/features/auth/domain/repositories/auth_repository.dart';

class VerifyOTPUseCase {
  final AuthRepository repository;

  VerifyOTPUseCase(this.repository);

  Future<AuthResponse> call(String otp) async {
    if (otp.isEmpty || otp.length != 6) {
      throw Exception('Vui lòng nhập đủ 6 chữ số OTP');
    }

    return await repository.verifyOTP(otp);
  }
}

class ResendOTPUseCase {
  final AuthRepository repository;

  ResendOTPUseCase(this.repository);

  Future<bool> call(String email) async {
    if (email.isEmpty) {
      throw Exception('Email không hợp lệ');
    }

    return await repository.resendOTP(email);
  }
}