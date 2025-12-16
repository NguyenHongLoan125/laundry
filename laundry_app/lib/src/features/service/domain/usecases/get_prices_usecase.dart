import 'package:laundry_app/src/features/service/domain/entities/price.dart';
import 'package:laundry_app/src/features/service/domain/repositories/service_repository.dart';

class GetPricesUseCase {
  final ServiceRepository repository;

  GetPricesUseCase(this.repository);

  Future<List<Price>> call() async {
    return await repository.getPrices();
  }
}