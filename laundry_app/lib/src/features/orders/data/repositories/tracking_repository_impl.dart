import '../../domain/entities/order_tracking.dart';
import '../../domain/repository/tracking_repository.dart';
import '../datasources/tracking_remote_data_source.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource remoteDataSource;

  TrackingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderTracking> getOrderTracking(String orderId) async {
    return await remoteDataSource.fetchOrderTracking(orderId);
  }
}