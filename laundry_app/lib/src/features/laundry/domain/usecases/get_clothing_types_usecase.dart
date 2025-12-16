import 'package:dartz/dartz.dart';
import '../entities/clothing_item.dart';
import '../repositories/laundry_repository.dart';

class GetClothingTypesUseCase {
  final LaundryRepository repository;

  GetClothingTypesUseCase(this.repository);

  Future<Either<Exception, List<ClothingItem>>> call() {
    return repository.getClothingTypes();
  }
}