import 'package:dio/dio.dart';
import 'package:laundry_app/src/core/config/app_config.dart';
import 'package:laundry_app/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:laundry_app/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:laundry_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/register_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:laundry_app/src/presentation/controllers/auth_controller.dart';

class AuthDI {
  // Dio Instance với cấu hình từ AppConfig
  static final Dio _dio = Dio();

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

    _initialized = true;
  }

  // Controller
  static AuthController getAuthController() {
    if (!_initialized) {
      init();
    }

    return AuthController(
      loginUseCase: _loginUseCase,
      registerUseCase: _registerUseCase,
      verifyOTPUseCase: _verifyOTPUseCase,
      resendOTPUseCase: _resendOTPUseCase,
    );
  }

  // Method để thay đổi environment
  static void setEnvironment(String environment) {
    EnvironmentConfig.setEnvironment(environment);
    _initialized = false; // Reset để init lại với environment mới
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

  // Method để set custom Dio instance (nếu cần thêm interceptors, etc)
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
  }
}