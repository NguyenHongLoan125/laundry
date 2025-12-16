import '../entities/order_tracking.dart';
import '../repository/tracking_repository.dart';

class GetOrderTrackingUsecase {
  final TrackingRepository repository;

  GetOrderTrackingUsecase(this.repository);

  Future<OrderTracking> call(String orderId) async {
    return await repository.getOrderTracking(orderId);
  }
}