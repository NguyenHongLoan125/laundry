import 'package:flutter/material.dart';
import '../../features/orders/domain/entities/order.dart';
import '../../features/orders/domain/usecases/get_order_detail_usecase.dart';

class OrderController extends ChangeNotifier {
  final GetOrderDetailUsecase getOrderDetail;

  Order? order;
  bool isLoading = false;
  String? error;
  bool _disposed = false;

  OrderController({required this.getOrderDetail});

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> loadOrder(String orderId) async {
    try {
      isLoading = true;
      error = null;
      _safeNotify();

      order = await getOrderDetail(orderId);
    } catch (e) {
      error = 'Không thể tải thông tin đơn hàng: $e';
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }
}