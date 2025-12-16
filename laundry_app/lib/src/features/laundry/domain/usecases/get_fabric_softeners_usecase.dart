import 'package:dartz/dartz.dart';
import '../entities/fabric_softener_item.dart';
import '../repositories/laundry_repository.dart';

class GetFabricSoftenersUseCase {
  final LaundryRepository repository;

  GetFabricSoftenersUseCase(this.repository);

  Future<Either<Exception, List<FabricSoftenerItem>>> call() {
    return repository.getFabricSofteners();
  }
}