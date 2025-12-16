import 'package:http/http.dart' as http;
import '../../features/vouchers/data/datasources/voucher_remote_data_source.dart';
import '../../features/vouchers/data/repositories/voucher_repository_impl.dart';
import '../../features/vouchers/domain/usecases/get_my_vouchers_usecase.dart';
import '../../features/vouchers/domain/usecases/get_available_vouchers_usecase.dart';
import '../../presentation/controllers/voucher_controller.dart';

class VoucherInjection {
  // ✅ CÁCH 1: Dùng API thật
  static VoucherController createVoucherControllerWithAPI(String baseUrl) {
    final dataSource = VoucherRemoteDataSourceImpl(
      client: http.Client(),
      baseUrl: baseUrl,
    );
    final repository = VoucherRepositoryImpl(remoteDataSource: dataSource);
    final getMyVouchers = GetMyVouchersUsecase(repository);
    final getAvailableVouchers = GetAvailableVouchersUsecase(repository);

    return VoucherController(
      getMyVouchers: getMyVouchers,
      getAvailableVouchers: getAvailableVouchers,
    );
  }

  // ✅ CÁCH 2: Dùng mock data
  static VoucherController createVoucherControllerWithMock() {
    final dataSource = VoucherMockDataSource();
    final repository = VoucherRepositoryImpl(remoteDataSource: dataSource);
    final getMyVouchers = GetMyVouchersUsecase(repository);
    final getAvailableVouchers = GetAvailableVouchersUsecase(repository);

    return VoucherController(
      getMyVouchers: getMyVouchers,
      getAvailableVouchers: getAvailableVouchers,
    );
  }

  // ✅ Universal method
  static VoucherController createVoucherController({
    bool useMockData = true,
    String? apiBaseUrl,
  }) {
    if (useMockData) {
      return createVoucherControllerWithMock();
    } else {
      if (apiBaseUrl == null) {
        throw ArgumentError('API base URL is required when useMockData is false');
      }
      return createVoucherControllerWithAPI(apiBaseUrl);
    }
  }
}