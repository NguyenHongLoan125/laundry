import 'package:http/http.dart' as http;
import '../../features/orders/data/datasources/tracking_remote_data_source.dart';
import '../../features/orders/data/repositories/tracking_repository_impl.dart';
import '../../features/orders/domain/usecases/get_order_tracking_usecase.dart';
import '../../presentation/controllers/tracking_controller.dart';

class TrackingInjection {
  // ✅ CÁCH 1: Dùng API thật
  static TrackingController createTrackingControllerWithAPI(String baseUrl) {
    final dataSource = TrackingRemoteDataSourceImpl(
      client: http.Client(),
      baseUrl: baseUrl,
    );
    final repository = TrackingRepositoryImpl(remoteDataSource: dataSource);
    final getOrderTracking = GetOrderTrackingUsecase(repository);

    return TrackingController(getOrderTracking: getOrderTracking);
  }

  // ✅ CÁCH 2: Dùng mock data
  static TrackingController createTrackingControllerWithMock() {
    final dataSource = TrackingMockDataSource();
    final repository = TrackingRepositoryImpl(remoteDataSource: dataSource);
    final getOrderTracking = GetOrderTrackingUsecase(repository);

    return TrackingController(getOrderTracking: getOrderTracking);
  }

  // ✅ Universal method với flag
  static TrackingController createTrackingController({
    bool useMockData = true,
    String? apiBaseUrl,
  }) {
    if (useMockData) {
      return createTrackingControllerWithMock();
    } else {
      if (apiBaseUrl == null) {
        throw ArgumentError('API base URL is required when useMockData is false');
      }
      return createTrackingControllerWithAPI(apiBaseUrl);
    }
  }
}