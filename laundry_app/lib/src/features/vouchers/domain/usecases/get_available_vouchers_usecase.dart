import '../entities/voucher.dart';
import '../repositories/voucher_repository.dart';

class GetAvailableVouchersUsecase {
  final VoucherRepository repository;

  GetAvailableVouchersUsecase(this.repository);

  Future<List<Voucher>> call() async {
    return await repository.getAvailableVouchers();
  }
}