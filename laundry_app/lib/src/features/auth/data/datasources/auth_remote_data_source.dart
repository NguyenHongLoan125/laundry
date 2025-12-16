import 'package:laundry_app/src/features/auth/data/models/user_model.dart';
// import 'package:dio/dio.dart'; // Uncomment khi dùng API thật

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
  Future<bool> verifyOTP(String email, String otp);
  Future<bool> resendOTP(String email);
}

// CÁCH 1: Lấy dữ liệu từ API thật
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // final Dio dio;
  // AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      // CÁCH LẤY TỪ API THẬT (Uncomment khi có API):
      /*
      final response = await dio.post('/api/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Đăng nhập thất bại');
      }
      */

      // Tạm thời dùng mock data
      await Future.delayed(Duration(seconds: 1));

      // Giả lập login thành công
      if (email == "test@gmail.com" && password == "123456") {
        return AuthResponseModel.fromJson({
          'success': true,
          'message': 'Đăng nhập thành công',
          'user': {
            'id': '1',
            'name': 'Test User',
            'email': email,
            'phone': '0123456789',
            'token': 'mock_token_12345',
          }
        });
      } else {
        throw Exception('Email hoặc mật khẩu không đúng');
      }
    } catch (e) {
      throw Exception('Lỗi đăng nhập: $e');
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // CÁCH LẤY TỪ API THẬT (Uncomment khi có API):
      /*
      final response = await dio.post('/api/auth/register', data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Đăng ký thất bại');
      }
      */

      // Tạm thời dùng mock data
      await Future.delayed(Duration(seconds: 1));

      return AuthResponseModel.fromJson({
        'success': true,
        'message': 'Đăng ký thành công. Vui lòng kiểm tra email để xác thực.',
        'user': {
          'id': '2',
          'name': name,
          'email': email,
          'phone': phone,
          'token': null,
        }
      });
    } catch (e) {
      throw Exception('Lỗi đăng ký: $e');
    }
  }

  @override
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      // CÁCH LẤY TỪ API THẬT (Uncomment khi có API):
      /*
      final response = await dio.post('/api/auth/verify-otp', data: {
        'email': email,
        'otp': otp,
      });

      if (response.statusCode == 200) {
        return response.data['success'] ?? false;
      } else {
        throw Exception('Xác thực OTP thất bại');
      }
      */

      // Tạm thời dùng mock data
      await Future.delayed(Duration(seconds: 1));

      // Giả lập OTP đúng là "123456"
      if (otp == "123456") {
        return true;
      } else {
        throw Exception('Mã OTP không đúng');
      }
    } catch (e) {
      throw Exception('Lỗi xác thực OTP: $e');
    }
  }

  @override
  Future<bool> resendOTP(String email) async {
    try {
      // CÁCH LẤY TỪ API THẬT (Uncomment khi có API):
      /*
      final response = await dio.post('/api/auth/resend-otp', data: {
        'email': email,
      });

      if (response.statusCode == 200) {
        return response.data['success'] ?? false;
      } else {
        throw Exception('Gửi lại OTP thất bại');
      }
      */

      // Tạm thời dùng mock data
      await Future.delayed(Duration(milliseconds: 500));
      return true;
    } catch (e) {
      throw Exception('Lỗi gửi lại OTP: $e');
    }
  }
}

// CÁCH 2: Lấy dữ liệu giả (Mock)
class AuthMockDataSource implements AuthRemoteDataSource {
  @override
  Future<AuthResponseModel> login(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 800));

    if (email == "test@gmail.com" && password == "123456") {
      return AuthResponseModel.fromJson({
        'success': true,
        'message': 'Đăng nhập thành công',
        'user': {
          'id': '1',
          'name': 'Nguyễn Văn A',
          'email': email,
          'phone': '0987654321',
          'token': 'mock_token_abc123',
        }
      });
    } else {
      throw Exception('Email hoặc mật khẩu không đúng');
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(Duration(milliseconds: 800));

    return AuthResponseModel.fromJson({
      'success': true,
      'message': 'Đăng ký thành công',
      'user': {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'email': email,
        'phone': phone,
        'token': null,
      }
    });
  }

  @override
  Future<bool> verifyOTP(String email, String otp) async {
    await Future.delayed(Duration(milliseconds: 800));

    // Mock: OTP luôn là "123456"
    if (otp == "123456") {
      return true;
    } else {
      throw Exception('Mã OTP không đúng');
    }
  }

  @override
  Future<bool> resendOTP(String email) async {
    await Future.delayed(Duration(milliseconds: 500));
    return true;
  }
}