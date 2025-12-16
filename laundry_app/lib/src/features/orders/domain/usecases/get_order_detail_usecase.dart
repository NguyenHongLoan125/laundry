import '../entities/order.dart';
import '../repository/order_repository.dart';

class GetOrderDetailUsecase {
  final OrderRepository repository;

  GetOrderDetailUsecase(this.repository);

  Future<Order> call(String orderId) async {
    return await repository.getOrderDetail(orderId);
  }
}