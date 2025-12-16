import '../entities/voucher.dart';

abstract class VoucherRepository {
  Future<List<Voucher>> getMyVouchers();
  Future<List<Voucher>> getAvailableVouchers();
}