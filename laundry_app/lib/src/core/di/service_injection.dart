import 'package:dio/dio.dart';
import 'package:laundry_app/src/features/service/data/datasources/service_remote_data_source.dart';
import 'package:laundry_app/src/features/service/data/repositories/service_repository_impl.dart';
import 'package:laundry_app/src/features/service/domain/repositories/service_repository.dart';
import 'package:laundry_app/src/features/service/domain/usecases/get_extra_services_usecase.dart';
import 'package:laundry_app/src/features/service/domain/usecases/get_prices_usecase.dart';
import 'package:laundry_app/src/features/service/domain/usecases/get_services_usecase.dart';
import '../../presentation/controllers/service_controller.dart';
import '../config/app_config.dart';

class ServiceDI {
  static Dio _createDio() {
    return Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  // Data Source với API thật
  static ServiceRemoteDataSource get _remoteDataSource {
    return ServiceRemoteDataSourceImpl(dio: _createDio());
  }

  // Repository
  static ServiceRepository get _repository {
    return ServiceRepositoryImpl(
      remoteDataSource: _remoteDataSource,
    );
  }

  // Use Cases
  static GetServicesUseCase get _getServicesUseCase {
    return GetServicesUseCase(_repository);
  }

  static GetExtraServicesUseCase get _getExtraServicesUseCase {
    return GetExtraServicesUseCase(_repository);
  }

  static GetPricesUseCase get _getPricesUseCase {
    return GetPricesUseCase(_repository);
  }

  // Controller
  static ServiceController getServiceController() {
    return ServiceController(
      getServicesUseCase: _getServicesUseCase,
      getExtraServicesUseCase: _getExtraServicesUseCase,
      getPricesUseCase: _getPricesUseCase,
    );
  }
}