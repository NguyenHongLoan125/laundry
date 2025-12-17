import 'package:laundry_app/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:laundry_app/src/features/auth/domain/entities/user.dart';
import 'package:laundry_app/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);
      return response.toEntity();
    } catch (e) {
      throw Exception('Đăng nhập thất bại: $e');
    }
  }

  @override
  Future<AuthResponse> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      return response.toEntity();
    } catch (e) {
      throw Exception('Đăng ký thất bại: $e');
    }
  }

  @override
  Future<AuthResponse> verifyOTP(String otp) async {
    try {
      final response = await remoteDataSource.verifyOTP(otp);
      return response.toEntity();
    } catch (e) {
      throw Exception('Xác thực OTP thất bại: $e');
    }
  }

  @override
  Future<bool> resendOTP(String email) async {
    try {
      return await remoteDataSource.resendOTP(email);
    } catch (e) {
      throw Exception('Gửi lại OTP thất bại: $e');
    }
  }

  @override
  Future<User> getProfile() async {
    try {
      final user = await remoteDataSource.getProfile();
      return user.toEntity();
    } catch (e) {
      throw Exception('Lấy thông tin thất bại: $e');
    }
  }

  @override
  Future<AuthResponse> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    String? imagePath,
  }) async {
    try {
      final response = await remoteDataSource.updateProfile(
        fullName: fullName,
        email: email,
        phone: phone,
        imagePath: imagePath,
      );
      return response.toEntity();
    } catch (e) {
      throw Exception('Cập nhật thông tin thất bại: $e');
    }
  }

  @override
  Future<AuthResponse> logout() async {
    try {
      final response = await remoteDataSource.logout();
      return response.toEntity();
    } catch (e) {
      throw Exception('Đăng xuất thất bại: $e');
    }
  }
}