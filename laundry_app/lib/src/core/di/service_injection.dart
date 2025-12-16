// lib/src/core/di/dependency_injection.dart

import 'package:laundry_app/src/features/service/data/datasources/service_remote_data_source.dart';
import 'package:laundry_app/src/features/service/data/repositories/service_repository_impl.dart';
import 'package:laundry_app/src/features/service/domain/repositories/service_repository.dart';
import 'package:laundry_app/src/features/service/domain/usecases/get_prices_usecase.dart';
import 'package:laundry_app/src/features/service/domain/usecases/get_services_usecase.dart';
import '../../presentation/controllers/service_controller.dart';

class ServiceDI {
  // Data Sources
  // CÁCH 1: Sử dụng API thật (uncomment khi có API)
  // static ServiceRemoteDataSource _remoteDataSource = ServiceRemoteDataSourceImpl();

  // CÁCH 2: Sử dụng Mock Data (để test)
  static ServiceRemoteDataSource _remoteDataSource = ServiceMockDataSource();

  // Repository
  static ServiceRepository _repository = ServiceRepositoryImpl(
    remoteDataSource: _remoteDataSource,
  );

  // Use Cases
  static GetServicesUseCase _getServicesUseCase = GetServicesUseCase(_repository);
  static GetPricesUseCase _getPricesUseCase = GetPricesUseCase(_repository);

  // Controller
  static ServiceController getServiceController() {
    return ServiceController(
      getServicesUseCase: _getServicesUseCase,
      getPricesUseCase: _getPricesUseCase,
    );
  }

  // Method để chuyển đổi giữa Mock và Real API
  static void useMockData() {
    _remoteDataSource = ServiceMockDataSource();
    _repository = ServiceRepositoryImpl(remoteDataSource: _remoteDataSource);
    _getServicesUseCase = GetServicesUseCase(_repository);
    _getPricesUseCase = GetPricesUseCase(_repository);
  }

  static void useRealAPI() {
    _remoteDataSource = ServiceRemoteDataSourceImpl();
    _repository = ServiceRepositoryImpl(remoteDataSource: _remoteDataSource);
    _getServicesUseCase = GetServicesUseCase(_repository);
    _getPricesUseCase = GetPricesUseCase(_repository);
  }
}