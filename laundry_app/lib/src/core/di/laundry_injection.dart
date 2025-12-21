import '../../features/laundry/data/datasources/laundry_local_data_source.dart';
import '../../features/laundry/data/datasources/laundry_remote_data_source.dart';
import '../../features/laundry/data/repositories/laundry_repository_impl.dart';
import '../../features/laundry/domain/repositories/laundry_repository.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/laundry_order_controller.dart';
import 'auth_dependency_injection.dart';


class LaundryOrderDI {
  // Lấy AuthController từ AuthDI
  static AuthController get _authController => AuthDI.getAuthController();

  // Repository - sử dụng Dio từ AuthDI
  static LaundryRepository get _laundryRepository => LaundryRepositoryImpl(
    remoteDataSource: LaundryRemoteDataSourceImpl(
      dio: AuthDI.dio, // Sử dụng getter dio
    ),
    localDataSource: LaundryLocalDataSourceImpl(),
  );

  // Controller
  static LaundryOrderController getLaundryOrderController() {
    return LaundryOrderController(
      repository: _laundryRepository,
      authController: _authController,
    );
  }
}