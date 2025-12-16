import 'package:laundry_app/src/features/auth/domain/repositories/auth_repository.dart';

class VerifyOTPUseCase {
  final AuthRepository repository;

  VerifyOTPUseCase(this.repository);

  Future<bool> call(String email, String otp) async {
    if (otp.isEmpty || otp.length != 6) {
      throw Exception('Mã OTP phải có 6 chữ số');
    }

    return await repository.verifyOTP(email, otp);
  }
}

class ResendOTPUseCase {
  final AuthRepository repository;

  ResendOTPUseCase(this.repository);

  Future<bool> call(String email) async {
    if (email.isEmpty) {
      throw Exception('Email không được để trống');
    }

    return await repository.resendOTP(email);
  }
}