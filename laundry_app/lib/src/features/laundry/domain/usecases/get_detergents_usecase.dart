import 'package:dartz/dartz.dart';
import '../entities/detergent_item.dart';
import '../repositories/laundry_repository.dart';

class GetDetergentsUseCase {
  final LaundryRepository repository;

  GetDetergentsUseCase(this.repository);

  Future<Either<Exception, List<DetergentItem>>> call() {
    return repository.getDetergents();
  }
}