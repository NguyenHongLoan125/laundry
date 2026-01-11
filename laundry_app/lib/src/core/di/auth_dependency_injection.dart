// auth_dependency_injection.dart - FIXED VERSION with PROPER LOGOUT
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundry_app/src/core/config/app_config.dart';
import 'package:laundry_app/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:laundry_app/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:laundry_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/register_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:laundry_app/src/presentation/controllers/auth_controller.dart';
import 'package:path_provider/path_provider.dart';

class AuthDI {
  static PersistCookieJar? _cookieJar;
  static AuthController? _authControllerInstance;
  static bool _initialized = false;
  static Dio? _dio;

  static Future<void> init({String? customBaseUrl}) async {
    if (_initialized) {
      print('⚠️ Re-initializing after hot restart...');
      _initialized = false;
      _cookieJar = null;
      _dio = null;
    }

    await GetStorage.init();

    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = '${appDocDir.path}/.cookies/';

    _cookieJar = PersistCookieJar(
      storage: FileStorage(cookiePath),
      ignoreExpires: false,
    );

    print('🍪 Cookie jar initialized at: $cookiePath');

    try {
      final cookies = await _cookieJar!.loadForRequest(Uri.parse(AppConfig.baseUrl));
      print('🍪 Loaded ${cookies.length} cookie(s) from storage');
      for (var cookie in cookies) {
        print('   - Cookie: ${cookie.name}');
      }
    } catch (e) {
      print('⚠️ Could not load cookies: $e');
    }

    if (customBaseUrl != null) {
      EnvironmentConfig.setEnvironment(EnvironmentConfig.development);
    }

    _dio = Dio(
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
      CookieManager(_cookieJar!),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
        logPrint: (obj) => print('[Auth API] $obj'),
      ),
    ]);

    final _remoteDataSource = AuthRemoteDataSourceImpl(dio: _dio!);
    final _repository = AuthRepositoryImpl(remoteDataSource: _remoteDataSource);
    final _loginUseCase = LoginUseCase(_repository);
    final _registerUseCase = RegisterUseCase(_repository);
    final _verifyOTPUseCase = VerifyOTPUseCase(_repository);
    final _resendOTPUseCase = ResendOTPUseCase(_repository);

    _authControllerInstance = AuthController(
      loginUseCase: _loginUseCase,
      registerUseCase: _registerUseCase,
      verifyOTPUseCase: _verifyOTPUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      authRepository: _repository,
    );

    await _authControllerInstance!.loadUserFromStorage();

    if (_authControllerInstance!.currentUser != null) {
      print('📱 Found user in storage: ${_authControllerInstance!.currentUser!.email}');
    } else {
      print('📱 No user found in storage');
    }

    _initialized = true;
  }

  static AuthController getAuthController() {
    if (!_initialized) {
      throw Exception('AuthDI not initialized. Call AuthDI.init() first.');
    }
    return _authControllerInstance!;
  }

  static Future<void> restoreUserSession() async {
    try {
      print('🔄 AuthDI: Đang khôi phục session...');

      await Future.delayed(Duration(milliseconds: 100));

      final cookies = await _cookieJar?.loadForRequest(
        Uri.parse(AppConfig.baseUrl),
      );

      print('🍪 Checking cookies: ${cookies?.length ?? 0} cookie(s) found');

      if (cookies == null || cookies.isEmpty) {
        print('⚠️ Không có cookie → Cần đăng nhập lại');
        await _authControllerInstance?.logout();
        return;
      }

      print('✅ Tìm thấy ${cookies.length} cookie(s)');
      for (var cookie in cookies) {
        print('   - ${cookie.name}: ${cookie.value.substring(0, 20)}...');
      }

      await _authControllerInstance?.restoreSession();
      print('✅ AuthDI: Session restored successfully');
    } catch (e) {
      print('⚠️ AuthDI: Không thể restore session: $e');
      await _authControllerInstance?.logout();
    }
  }

  /// ✅ HÀM MỚI: Xóa hoàn toàn cookies
  static Future<void> clearAllCookies() async {
    try {
      print('🗑️ AuthDI: Đang xóa tất cả cookies...');

      if (_cookieJar != null) {
        // Xóa tất cả cookies
        await _cookieJar!.deleteAll();
        print('✅ Đã xóa tất cả cookies');

        // Kiểm tra lại
        final remainingCookies = await _cookieJar!.loadForRequest(
          Uri.parse(AppConfig.baseUrl),
        );
        print('🍪 Còn lại: ${remainingCookies.length} cookie(s)');
      }
    } catch (e) {
      print('❌ Lỗi khi xóa cookies: $e');
    }
  }

  static Dio get dio {
    if (!_initialized || _dio == null) {
      throw Exception('AuthDI not initialized. Call AuthDI.init() first.');
    }
    return _dio!;
  }

  static PersistCookieJar get cookieJar {
    if (_cookieJar == null) {
      throw Exception('CookieJar not initialized');
    }
    return _cookieJar!;
  }

  static Future<void> reset() async {
    _initialized = false;
    _authControllerInstance = null;
    await _cookieJar?.deleteAll();
  }
}