import 'package:laundry_app/src/features/service/domain/entities/service.dart';
import 'package:laundry_app/src/features/service/domain/repositories/service_repository.dart';

class GetExtraServicesUseCase {
  final ServiceRepository repository;

  GetExtraServicesUseCase(this.repository);

  Future<List<Service>> call() async {
    return await repository.getExtraServices();
  }
}