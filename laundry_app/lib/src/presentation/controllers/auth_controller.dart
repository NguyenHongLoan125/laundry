import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundry_app/src/features/auth/domain/entities/user.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/register_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../core/di/auth_dependency_injection.dart';
import '../../core/di/home_dependency_injection.dart'; // ✅ THÊM import

class AuthController extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;
  final ResendOTPUseCase resendOTPUseCase;
  final AuthRepository authRepository;

  final GetStorage _storage = GetStorage();
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String? _currentOTP;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get currentOTP => _currentOTP;

  bool get isLoggedIn {
    final hasLoginFlag = _storage.read<bool>(_isLoggedInKey) ?? false;
    final hasUser = _currentUser != null;

    print('🔍 isLoggedIn check:');
    print('   - hasLoginFlag: $hasLoginFlag');
    print('   - hasUser: $hasUser');
    print('   - Result: ${hasLoginFlag && hasUser}');

    return hasLoginFlag && hasUser;
  }

  AuthController({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOTPUseCase,
    required this.resendOTPUseCase,
    required this.authRepository,
  });

  // ========== PUBLIC METHODS ==========

  void setCurrentUser(User user) {
    _currentUser = user;
    _saveUserToStorage(user);
    notifyListeners();
  }

  Future<void> restoreSession() async {
    try {
      print('🔄 Đang khôi phục session...');

      final isLoggedIn = _storage.read<bool>(_isLoggedInKey) ?? false;
      if (!isLoggedIn) {
        print('❌ Không có flag đăng nhập');
        return;
      }

      if (_currentUser == null) {
        print('⚠️ Không có user trong storage nhưng có flag login');
        await _loadUserFromStorage();

        if (_currentUser == null) {
          print('❌ Vẫn không load được user');
          await _storage.write(_isLoggedInKey, false);
          return;
        }
      }

      print('✅ Đã có user, đang verify với server...');

      try {
        final user = await authRepository.getProfile();

        _currentUser = User(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          phone: user.phone,
          image: user.image,
          token: _currentUser?.token,
        );

        await _saveUserToStorage(_currentUser!);
        print('✅ Session restored successfully: ${user.email}');
        notifyListeners();
      } catch (e) {
        print('⚠️ Session không hợp lệ hoặc hết hạn: $e');
        await _clearUserData();
        throw Exception('Session expired');
      }
    } catch (e) {
      print('❌ Không thể restore session: $e');
      rethrow;
    }
  }

  Future<void> loadUserFromStorage() async {
    await _loadUserFromStorage();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearMessages();

    try {
      print('🔐 Starting login process...');

      // ✅ QUAN TRỌNG: Xóa user cũ TRƯỚC KHI login
      await _clearUserData();
      print('🗑️ Cleared old user data before login');

      final response = await loginUseCase.call(email, password);

      print('🔐 Login response code: ${response.code}');
      print('🔐 Login response success: ${response.success}');

      if (response.success) {
        _setSuccess(response.message);

        await _storage.write(_isLoggedInKey, true);
        print('✅ Login flag saved');

        try {
          await Future.delayed(Duration(milliseconds: 800));
          final user = await authRepository.getProfile();

          _currentUser = user;
          await _saveUserToStorage(user);
          print('✅ Profile fetched and saved successfully');
          print('✅ New user email: ${user.email}');
        } catch (e) {
          print('⚠️ Profile fetch failed, using basic info: $e');
          _currentUser = User(
            id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
            fullName: email.split('@')[0],
            email: email,
            phone: '',
            token: null,
          );
          await _saveUserToStorage(_currentUser!);
        }

        notifyListeners();
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      print('❌ Login error: $e');
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await registerUseCase.call(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );

      if (response.success) {
        _currentOTP = response.otp;
        _setSuccess(response.message);
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyOTP(String otp) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await verifyOTPUseCase.call(otp);

      if (response.success) {
        _setSuccess(response.message);
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resendOTP(String email) async {
    _clearMessages();

    try {
      final success = await resendOTPUseCase.call(email);

      if (success) {
        _setSuccess('Đã gửi lại mã OTP');
        return true;
      } else {
        _setError('Gửi lại OTP thất bại');
        return false;
      }
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  /// ✅ CẢI TIẾN: Logout với xóa hoàn toàn cookies VÀ reset HomeController
  Future<void> logout() async {
    try {
      print('🚪 Đang đăng xuất...');

      // Bước 1: Gọi API logout
      try {
        await authRepository.logout();
        print('✅ Logout API call successful');
      } catch (e) {
        print('⚠️ Error calling logout API: $e');
      }

      // Bước 2: ✅ XÓA TẤT CẢ COOKIES
      await AuthDI.clearAllCookies();

      // Bước 3: ✅ RESET HOME CONTROLLER
      HomeDI.reset();
      print('✅ HomeController reset');

      // Bước 4: Xóa trạng thái đăng nhập
      await _storage.write(_isLoggedInKey, false);

      // Bước 5: Xóa user data
      await _clearUserData();

      print('✅ Logout completed - All data cleared');
    } catch (e) {
      print('❌ Logout error: $e');
      // Đảm bảo vẫn clear data ngay cả khi có lỗi
      await AuthDI.clearAllCookies();
      HomeDI.reset();
      await _storage.write(_isLoggedInKey, false);
      await _clearUserData();
    }
  }

  Future<void> fetchProfile() async {
    try {
      final user = await authRepository.getProfile();

      _currentUser = User(
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        phone: user.phone,
        image: user.image,
        token: _currentUser?.token,
      );

      await _saveUserToStorage(_currentUser!);
      notifyListeners();
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  // ========== PRIVATE METHODS ==========

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setSuccess(String? message) {
    _successMessage = message;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  Future<void> _saveUserToStorage(User user) async {
    final userJson = {
      'id': user.id,
      'fullName': user.fullName,
      'email': user.email,
      'phone': user.phone,
      'image': user.image,
      'token': user.token,
    };

    await _storage.write(_userKey, userJson);
    await _storage.write(_isLoggedInKey, true);

    print('💾 User saved to storage:');
    print('  - Email: ${user.email}');
    print('  - Token saved: ${user.token != null}');
  }

  Future<void> _loadUserFromStorage() async {
    print('🔄 Loading user from storage...');
    final userJson = _storage.read<Map<String, dynamic>>(_userKey);

    if (userJson != null) {
      print('📦 User JSON from storage found');

      _currentUser = User(
        id: userJson['id'],
        fullName: userJson['fullName'],
        email: userJson['email'],
        phone: userJson['phone'],
        image: userJson['image'],
        token: userJson['token'],
      );

      print('📱 User loaded:');
      print('  - Email: ${_currentUser?.email}');
      print('  - Has Token: ${_currentUser?.token != null}');

      notifyListeners();
    } else {
      print('📱 No user found in storage');
    }
  }

  Future<void> _clearUserData() async {
    await _storage.remove(_userKey);
    await _storage.remove(_isLoggedInKey);
    _currentUser = null;
    _currentOTP = null;
    _errorMessage = null;
    _successMessage = null;
    print('🗑️ All user data cleared');
    notifyListeners();
  }
}