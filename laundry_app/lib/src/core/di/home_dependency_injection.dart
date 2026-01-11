// home_dependency_injection.dart
import 'package:dio/dio.dart';
import 'package:laundry_app/src/core/di/auth_dependency_injection.dart';
import 'package:laundry_app/src/features/home/data/datasources/home_remote_datasource.dart';
import 'package:laundry_app/src/features/home/data/repositories/home_repository_impl.dart';
import 'package:laundry_app/src/features/home/domain/repositories/home_repository.dart';
import 'package:laundry_app/src/presentation/controllers/home_controller.dart';

class HomeDI {
  static HomeController? _homeControllerInstance;

  static HomeController getHomeController() {
    if (_homeControllerInstance == null) {
      // Lấy Dio instance từ AuthDI (cùng instance, cùng cookies)
      final Dio dio = AuthDI.dio;

      // Tạo data source với Dio
      final dataSource = HomeRemoteDataSourceImpl(dio: dio);

      // Tạo repository
      final repository = HomeRepositoryImpl(remoteDataSource: dataSource);

      // Tạo controller - sẽ tự động gọi _initialize() trong constructor
      _homeControllerInstance = HomeController(repository: repository);
    }
    return _homeControllerInstance!;
  }

  static void reset() {
    _homeControllerInstance = null;
  }
}