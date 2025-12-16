import 'package:laundry_app/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:laundry_app/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:laundry_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/register_usecase.dart';
import 'package:laundry_app/src/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:laundry_app/src/presentation/controllers/auth_controller.dart';

class AuthDI {
  // Data Sources
  // CÁCH 1: Sử dụng API thật (uncomment khi có API)
  // static AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSourceImpl();

  // CÁCH 2: Sử dụng Mock Data (để test)
  static AuthRemoteDataSource _remoteDataSource = AuthMockDataSource();

  // Repository
  static AuthRepository _repository = AuthRepositoryImpl(
    remoteDataSource: _remoteDataSource,
  );

  // Use Cases
  static LoginUseCase _loginUseCase = LoginUseCase(_repository);
  static RegisterUseCase _registerUseCase = RegisterUseCase(_repository);
  static VerifyOTPUseCase _verifyOTPUseCase = VerifyOTPUseCase(_repository);
  static ResendOTPUseCase _resendOTPUseCase = ResendOTPUseCase(_repository);

  // Controller
  static AuthController getAuthController() {
    return AuthController(
      loginUseCase: _loginUseCase,
      registerUseCase: _registerUseCase,
      verifyOTPUseCase: _verifyOTPUseCase,
      resendOTPUseCase: _resendOTPUseCase,
    );
  }

  // Method để chuyển đổi giữa Mock và Real API
  static void useMockData() {
    _remoteDataSource = AuthMockDataSource();
    _repository = AuthRepositoryImpl(remoteDataSource: _remoteDataSource);
    _loginUseCase = LoginUseCase(_repository);
    _registerUseCase = RegisterUseCase(_repository);
    _verifyOTPUseCase = VerifyOTPUseCase(_repository);
    _resendOTPUseCase = ResendOTPUseCase(_repository);
  }

  static void useRealAPI() {
    _remoteDataSource = AuthRemoteDataSourceImpl();
    _repository = AuthRepositoryImpl(remoteDataSource: _remoteDataSource);
    _loginUseCase = LoginUseCase(_repository);
    _registerUseCase = RegisterUseCase(_repository);
    _verifyOTPUseCase = VerifyOTPUseCase(_repository);
    _resendOTPUseCase = ResendOTPUseCase(_repository);
  }
}