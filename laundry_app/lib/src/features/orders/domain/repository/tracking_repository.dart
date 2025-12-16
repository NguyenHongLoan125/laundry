import '../entities/order_tracking.dart';

abstract class TrackingRepository {
  Future<OrderTracking> getOrderTracking(String orderId);
}