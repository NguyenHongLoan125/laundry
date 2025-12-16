import 'package:http/http.dart' as http;
import 'package:laundry_app/src/features/laundry/data/datasources/laundry_remote_data_source.dart';
import 'package:laundry_app/src/features/laundry/data/repositories/laundry_repository_impl.dart';
import 'package:laundry_app/src/features/laundry/domain/repositories/laundry_repository.dart';
import 'package:laundry_app/src/features/laundry/domain/usecases/get_packages_usecase.dart';
import 'package:laundry_app/src/features/laundry/domain/usecases/get_clothing_types_usecase.dart';
import 'package:laundry_app/src/features/laundry/domain/usecases/get_detergents_usecase.dart';
import 'package:laundry_app/src/features/laundry/domain/usecases/get_fabric_softeners_usecase.dart';
import 'package:laundry_app/src/features/laundry/domain/usecases/submit_order_usecase.dart';
import '../../presentation/controllers/laundry_order_controller.dart';


class LaundryDI {

  static LaundryRemoteDataSource _remoteDataSource = LaundryMockDataSource();
  static http.Client _client = http.Client();

  static LaundryRepository _repository =
  LaundryRepositoryImpl(remoteDataSource: _remoteDataSource);

  static GetPackagesUseCase _getPackagesUseCase =
  GetPackagesUseCase(_repository);

  static GetClothingTypesUseCase _getClothingTypesUseCase =
  GetClothingTypesUseCase(_repository);

  static GetDetergentsUseCase _getDetergentsUseCase =
  GetDetergentsUseCase(_repository);

  static GetFabricSoftenersUseCase _getFabricSoftenersUseCase =
  GetFabricSoftenersUseCase(_repository);

  static SubmitOrderUseCase _submitOrderUseCase =
  SubmitOrderUseCase(_repository);

  static LaundryOrderProvider getProvider() {
    return LaundryOrderProvider(
      getPackagesUseCase: _getPackagesUseCase,
      getClothingTypesUseCase: _getClothingTypesUseCase,
      getDetergentsUseCase: _getDetergentsUseCase,
      getFabricSoftenersUseCase: _getFabricSoftenersUseCase,
      submitOrderUseCase: _submitOrderUseCase,
    );
  }

  static void useMockData() {
    _remoteDataSource = LaundryMockDataSource();
    _reset();
  }

  static void useRealAPI(String baseUrl) {
    _remoteDataSource = LaundryRemoteDataSourceImpl(
      client: _client,
      baseUrl: baseUrl,
    );
    _reset();
  }

  static void _reset() {
    _repository = LaundryRepositoryImpl(
      remoteDataSource: _remoteDataSource,
    );

    _getPackagesUseCase = GetPackagesUseCase(_repository);
    _getClothingTypesUseCase = GetClothingTypesUseCase(_repository);
    _getDetergentsUseCase = GetDetergentsUseCase(_repository);
    _getFabricSoftenersUseCase = GetFabricSoftenersUseCase(_repository);
    _submitOrderUseCase = SubmitOrderUseCase(_repository);
  }
}

