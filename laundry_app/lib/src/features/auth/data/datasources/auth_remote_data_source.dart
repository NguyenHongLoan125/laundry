import 'package:dio/dio.dart';
import 'package:laundry_app/src/core/config/app_config.dart';
import 'package:laundry_app/src/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });
  Future<AuthResponseModel> verifyOTP(String otp);
  Future<bool> resendOTP(String email);
  Future<UserModel> getProfile();
  Future<AuthResponseModel> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    String? imagePath,
  });
  Future<AuthResponseModel> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio}) {
    _configureDio();
  }

  void _configureDio() {
    dio.options.baseUrl = EnvironmentConfig.getBaseUrl();
    dio.options.connectTimeout = AppConfig.connectTimeout;
    dio.options.receiveTimeout = AppConfig.receiveTimeout;
    dio.options.sendTimeout = AppConfig.sendTimeout;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (AppConfig.enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => print(obj),
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (AppConfig.enableLogging) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (AppConfig.enableLogging) {
            print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (AppConfig.enableLogging) {
            print('ERROR[${error.response?.statusCode}] => MESSAGE: ${error.message}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/authentication/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final cookies = response.headers['set-cookie'];
        if (cookies != null && AppConfig.enableLogging) {
          print('Cookies received: $cookies');
        }

        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Đăng nhập thất bại');
      }
    } on DioException catch (e) {
      return _handleDioError(e, 'Đăng nhập thất bại');
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/authentication/register',
        data: {
          'fullName': fullName,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Đăng ký thất bại');
      }
    } on DioException catch (e) {
      return _handleDioError(e, 'Đăng ký thất bại');
    }
  }

  @override
  Future<AuthResponseModel> verifyOTP(String otp) async {
    try {
      final response = await dio.post(
        '/authentication/otp',
        data: {
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Xác thực OTP thất bại');
      }
    } on DioException catch (e) {
      return _handleDioError(e, 'Xác thực OTP thất bại');
    }
  }

  @override
  Future<bool> resendOTP(String email) async {
    try {
      final response = await dio.post(
        '/authentication/register',
        data: {
          'email': email,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (AppConfig.enableLogging) {
        print('Resend OTP error: ${e.message}');
      }
      throw Exception('Gửi lại OTP thất bại');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await dio.get('/authentication/profile');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Lấy thông tin thất bại');
      }
    } on DioException catch (e) {
      return _handleDioError(e, 'Lấy thông tin thất bại');
    }
  }

  @override
  Future<AuthResponseModel> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    String? imagePath,
  }) async {
    try {
      FormData formData;

      if (imagePath != null && imagePath.isNotEmpty) {
        formData = FormData.fromMap({
          'fullName': fullName,
          'email': email,
          'phone': phone,
          'image': await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
        });
      } else {
        formData = FormData.fromMap({
          'fullName': fullName,
          'email': email,
          'phone': phone,
        });
      }

      final response = await dio.put(
        '/authentication/profile/edit',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Cập nhật thông tin thất bại');
      }
    } on DioException catch (e) {
      return _handleDioError(e, 'Cập nhật thông tin thất bại');
    }
  }

  @override
  Future<AuthResponseModel> logout() async {
    try {
      final response = await dio.get('/authentication/logout');

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Đăng xuất thất bại');
      }
    } on DioException catch (e) {
      return _handleDioError(e, 'Đăng xuất thất bại');
    }
  }

  // QUAN TRỌNG: Xử lý lỗi từ backend validation
  T _handleDioError<T>(DioException e, String defaultMessage) {
    if (e.response != null) {
      final errorData = e.response!.data;

      // Backend trả về: { "code": "error", "message": "..." }
      if (errorData is Map<String, dynamic>) {
        final message = errorData['message'];

        // Nếu có message từ backend, ném lỗi với message đó
        if (message != null && message is String && message.isNotEmpty) {
          throw Exception(message);
        }
      }

      // Nếu không parse được, dùng message mặc định
      throw Exception(defaultMessage);
    }

    // Xử lý các loại lỗi khác
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        throw Exception('Hết thời gian kết nối');
      case DioExceptionType.sendTimeout:
        throw Exception('Hết thời gian gửi dữ liệu');
      case DioExceptionType.receiveTimeout:
        throw Exception('Hết thời gian nhận dữ liệu');
      case DioExceptionType.connectionError:
        throw Exception('Lỗi kết nối. Vui lòng kiểm tra internet');
      default:
        throw Exception('$defaultMessage: ${e.message}');
    }
  }
}