import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:laundry_app/src/core/config/app_config.dart';
import 'package:laundry_app/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:laundry_app/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:laundry_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/register_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:laundry_app/src/presentation/controllers/auth_controller.dart';

class AuthDI {
  // CookieJar để lưu cookies
  static final CookieJar _cookieJar = CookieJar();

  // Dio Instance với CookieManager
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.addAll([
    CookieManager(_cookieJar), // Thêm CookieManager
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      logPrint: (obj) => print('[Auth API] $obj'),
    ),
  ]);

  // SINGLETON AuthController instance
  static AuthController? _authControllerInstance;

  // Data Sources
  static late AuthRemoteDataSource _remoteDataSource;

  // Repository
  static late AuthRepository _repository;

  // Use Cases
  static late LoginUseCase _loginUseCase;
  static late RegisterUseCase _registerUseCase;
  static late VerifyOTPUseCase _verifyOTPUseCase;
  static late ResendOTPUseCase _resendOTPUseCase;

  // Initialize flag
  static bool _initialized = false;

  // Initialize tất cả dependencies
  static void init({String? customBaseUrl}) {
    if (_initialized) return;

    // Nếu có custom base URL, set environment
    if (customBaseUrl != null) {
      EnvironmentConfig.setEnvironment(EnvironmentConfig.development);
    }

    // Khởi tạo Data Source
    _remoteDataSource = AuthRemoteDataSourceImpl(dio: _dio);

    // Khởi tạo Repository
    _repository = AuthRepositoryImpl(remoteDataSource: _remoteDataSource);

    // Khởi tạo Use Cases
    _loginUseCase = LoginUseCase(_repository);
    _registerUseCase = RegisterUseCase(_repository);
    _verifyOTPUseCase = VerifyOTPUseCase(_repository);
    _resendOTPUseCase = ResendOTPUseCase(_repository);

    // Khởi tạo AuthController SINGLETON
    _authControllerInstance = AuthController(
      loginUseCase: _loginUseCase,
      registerUseCase: _registerUseCase,
      verifyOTPUseCase: _verifyOTPUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      authRepository: _repository,
    );

    _initialized = true;
  }

  // Trả về SINGLETON AuthController
  static AuthController getAuthController() {
    if (!_initialized) {
      init();
    }
    return _authControllerInstance!;
  }

  // Thêm method để restore user từ storage
  static Future<void> restoreUserSession() async {
    try {
      // Gọi API getProfile để lấy user data từ cookie
      final userProfile = await _repository.getProfile();

      // Sử dụng public method hoặc setter nếu có
      // Nếu không có setter, cần thêm vào AuthController
      _authControllerInstance?.setCurrentUser(userProfile);

      print('User session restored: ${userProfile.id}');
    } catch (e) {
      print('No user session to restore: $e');
    }
  }

  // Getter cho Dio
  static Dio get dio {
    if (!_initialized) {
      init();
    }
    return _dio;
  }

  // Getter cho CookieJar
  static CookieJar get cookieJar {
    return _cookieJar;
  }

  // Getter cho AuthRepository
  static AuthRepository get authRepository {
    if (!_initialized) {
      init();
    }
    return _repository;
  }

  // Method để thay đổi environment
  static void setEnvironment(String environment) {
    EnvironmentConfig.setEnvironment(environment);
    _initialized = false;
    init();
  }

  // Method để cấu hình custom base URL
  static void configureBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    _remoteDataSource = AuthRemoteDataSourceImpl(dio: _dio);
    _repository = AuthRepositoryImpl(remoteDataSource: _remoteDataSource);
    _loginUseCase = LoginUseCase(_repository);
    _registerUseCase = RegisterUseCase(_repository);
    _verifyOTPUseCase = VerifyOTPUseCase(_repository);
    _resendOTPUseCase = ResendOTPUseCase(_repository);
  }

  // Method để set custom Dio instance
  static void configureDio(Dio customDio) {
    _remoteDataSource = AuthRemoteDataSourceImpl(dio: customDio);
    _repository = AuthRepositoryImpl(remoteDataSource: _remoteDataSource);
    _loginUseCase = LoginUseCase(_repository);
    _registerUseCase = RegisterUseCase(_repository);
    _verifyOTPUseCase = VerifyOTPUseCase(_repository);
    _resendOTPUseCase = ResendOTPUseCase(_repository);
    _initialized = true;
  }

  // Reset tất cả
  static void reset() {
    _initialized = false;
    _cookieJar.deleteAll(); // Xóa cookies khi reset
  }
}