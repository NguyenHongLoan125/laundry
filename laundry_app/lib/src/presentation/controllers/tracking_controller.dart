import 'package:flutter/material.dart';
import '../../features/orders/domain/entities/order_tracking.dart';
import '../../features/orders/domain/usecases/get_order_tracking_usecase.dart';

class TrackingController extends ChangeNotifier {
  final GetOrderTrackingUsecase getOrderTracking;

  OrderTracking? tracking;
  bool isLoading = false;
  String? error;
  bool _disposed = false;

  TrackingController({required this.getOrderTracking});

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

  Future<void> loadTracking(String orderId) async {
    try {
      isLoading = true;
      error = null;
      _safeNotify();

      tracking = await getOrderTracking(orderId);
    } catch (e) {
      error = 'Không thể tải thông tin tracking: $e';
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }
}