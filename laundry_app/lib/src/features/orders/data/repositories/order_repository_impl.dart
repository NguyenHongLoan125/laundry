import '../../domain/entities/order.dart';
import '../../domain/repository/order_repository.dart';
import '../datasources/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Order> getOrderDetail(String orderId) async {
    return await remoteDataSource.fetchOrderDetail(orderId);
  }
}