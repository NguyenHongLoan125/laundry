import '../entities/order.dart';

abstract class OrderRepository {
  Future<Order> getOrderDetail(String orderId);
}