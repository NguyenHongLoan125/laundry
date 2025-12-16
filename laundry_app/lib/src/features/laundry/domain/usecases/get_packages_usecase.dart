import 'package:dartz/dartz.dart';
import '../entities/laundry_package.dart';
import '../repositories/laundry_repository.dart';

class GetPackagesUseCase {
  final LaundryRepository repository;

  GetPackagesUseCase(this.repository);

  Future<Either<Exception, List<LaundryPackage>>> call() {
    return repository.getPackages();
  }
}