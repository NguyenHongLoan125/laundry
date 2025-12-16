import '../../domain/entities/voucher.dart';
import '../../domain/repositories/voucher_repository.dart';
import '../datasources/voucher_remote_data_source.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  final VoucherRemoteDataSource remoteDataSource;

  VoucherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Voucher>> getMyVouchers() async {
    return await remoteDataSource.fetchMyVouchers();
  }

  @override
  Future<List<Voucher>> getAvailableVouchers() async {
    return await remoteDataSource.fetchAvailableVouchers();
  }
}