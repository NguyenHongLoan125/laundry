import '../entities/voucher.dart';
import '../repositories/voucher_repository.dart';

class GetMyVouchersUsecase {
  final VoucherRepository repository;

  GetMyVouchersUsecase(this.repository);

  Future<List<Voucher>> call() async {
    return await repository.getMyVouchers();
  }
}