import 'package:flutter/material.dart';
import '../../features/vouchers/domain/entities/voucher.dart';
import '../../features/vouchers/domain/usecases/get_my_vouchers_usecase.dart';
import '../../features/vouchers/domain/usecases/get_available_vouchers_usecase.dart';

class VoucherController extends ChangeNotifier {
  final GetMyVouchersUsecase getMyVouchers;
  final GetAvailableVouchersUsecase getAvailableVouchers;

  List<Voucher> myVouchers = [];
  List<Voucher> availableVouchers = [];
  bool isLoading = false;
  String? error;
  bool _disposed = false;

  VoucherController({
    required this.getMyVouchers,
    required this.getAvailableVouchers,
  });

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

  Future<void> loadMyVouchers() async {
    try {
      isLoading = true;
      error = null;
      _safeNotify();

      myVouchers = await getMyVouchers();
    } catch (e) {
      error = 'Không thể tải danh sách ưu đãi: $e';
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }

  Future<void> loadAvailableVouchers() async {
    try {
      isLoading = true;
      error = null;
      _safeNotify();

      availableVouchers = await getAvailableVouchers();
    } catch (e) {
      error = 'Không thể tải ưu đãi khả dụng: $e';
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }
}