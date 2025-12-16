import 'package:http/http.dart' as http;
import '../../features/orders/data/datasources/order_remote_data_source.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/usecases/get_order_detail_usecase.dart';
import '../../presentation/controllers/order_controller.dart';

class OrderInjection {
  // ✅ CÁCH 1: Dùng API thật
  static OrderController createOrderControllerWithAPI(String baseUrl) {
    final dataSource = OrderRemoteDataSourceImpl(
      client: http.Client(),
      baseUrl: baseUrl,
    );
    final repository = OrderRepositoryImpl(remoteDataSource: dataSource);
    final getOrderDetail = GetOrderDetailUsecase(repository);

    return OrderController(getOrderDetail: getOrderDetail);
  }

  // ✅ CÁCH 2: Dùng mock data
  static OrderController createOrderControllerWithMock() {
    final dataSource = OrderMockDataSource();
    final repository = OrderRepositoryImpl(remoteDataSource: dataSource);
    final getOrderDetail = GetOrderDetailUsecase(repository);

    return OrderController(getOrderDetail: getOrderDetail);
  }

  // ✅ Universal method với flag
  static OrderController createOrderController({
    bool useMockData = true,
    String? apiBaseUrl,
  }) {
    if (useMockData) {
      return createOrderControllerWithMock();
    } else {
      if (apiBaseUrl == null) {
        throw ArgumentError('API base URL is required when useMockData is false');
      }
      return createOrderControllerWithAPI(apiBaseUrl);
    }
  }
}