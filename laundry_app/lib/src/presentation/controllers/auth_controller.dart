import 'package:flutter/material.dart';
import 'package:laundry_app/src/features/auth/domain/entities/user.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/register_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/verify_otp_usecase.dart';

class AuthController extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;
  final ResendOTPUseCase resendOTPUseCase;

  AuthController({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOTPUseCase,
    required this.resendOTPUseCase,
  });

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  String? _currentOTP; // Lưu OTP từ response register
  String? get currentOTP => _currentOTP;

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

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    _setSuccess(null);

    try {
      final response = await loginUseCase.call(email, password);

      if (response.success) {
        _currentUser = response.user;
        _setSuccess(response.message);
        _setLoading(false);
        return true;
      } else {
        _setError(response.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);
    _setSuccess(null);

    try {
      final response = await registerUseCase.call(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );

      if (response.success) {
        _currentOTP = response.otp; // Lưu OTP để test
        _setSuccess(response.message);
        _setLoading(false);
        return true;
      } else {
        _setError(response.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOTP(String otp) async {
    _setLoading(true);
    _setError(null);
    _setSuccess(null);

    try {
      final response = await verifyOTPUseCase.call(otp);

      if (response.success) {
        _setSuccess(response.message);
        _setLoading(false);
        return true;
      } else {
        _setError(response.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Resend OTP
  Future<bool> resendOTP(String email) async {
    _setError(null);
    _setSuccess(null);

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

  // Logout
  void logout() {
    _currentUser = null;
    _currentOTP = null;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}