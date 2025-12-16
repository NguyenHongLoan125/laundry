import 'package:laundry_app/src/features/service/domain/entities/service.dart';
import 'package:laundry_app/src/features/service/domain/repositories/service_repository.dart';

class GetServicesUseCase {
  final ServiceRepository repository;

  GetServicesUseCase(this.repository);

  Future<List<Service>> call() async {
    return await repository.getServices();
  }
}