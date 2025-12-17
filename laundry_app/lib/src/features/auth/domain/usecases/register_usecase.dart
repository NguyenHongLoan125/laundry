import 'package:laundry_app/src/features/auth/domain/entities/user.dart';
import 'package:laundry_app/src/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthResponse> call({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    // Validate inputs
    if (fullName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      throw Exception('Vui lòng điền đầy đủ thông tin');
    }

    // Validate email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw Exception('Email không hợp lệ');
    }

    // Validate phone
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(phone)) {
      throw Exception('Số điện thoại phải có 10 chữ số');
    }

    // Validate password
    if (password.length < 6) {
      throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
    }

    return await repository.register(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    );
  }
}