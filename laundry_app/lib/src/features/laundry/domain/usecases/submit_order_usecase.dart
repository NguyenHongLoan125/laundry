import 'package:dartz/dartz.dart';
import '../entities/laundry_order.dart';
import '../repositories/laundry_repository.dart';

class SubmitOrderUseCase {
  final LaundryRepository repository;

  SubmitOrderUseCase(this.repository);

  Future<Either<Exception, bool>> call(LaundryOrder order) {
    return repository.submitOrder(order);
  }
}