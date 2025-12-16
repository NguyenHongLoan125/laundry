import 'package:dartz/dartz.dart';
import '../../domain/entities/laundry_order.dart';
import '../../domain/entities/laundry_package.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/detergent_item.dart';
import '../../domain/entities/fabric_softener_item.dart';
import '../../domain/repositories/laundry_repository.dart';
import '../datasources/laundry_remote_data_source.dart';
import '../models/laundry_order_model.dart';

class LaundryRepositoryImpl implements LaundryRepository {
  final LaundryRemoteDataSource remoteDataSource;

  LaundryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, List<LaundryPackage>>> getPackages() async {
    try {
      final packages = await remoteDataSource.getPackages();
      return Right(packages);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<ClothingItem>>> getClothingTypes() async {
    try {
      final items = await remoteDataSource.getClothingTypes();
      return Right(items);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<DetergentItem>>> getDetergents() async {
    try {
      final detergents = await remoteDataSource.getDetergents();
      return Right(detergents);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<FabricSoftenerItem>>>
  getFabricSofteners() async {
    try {
      final softeners = await remoteDataSource.getFabricSofteners();
      return Right(softeners);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> submitOrder(LaundryOrder order) async {
    try {
      final orderModel = LaundryOrderModel.fromEntity(order);
      final result = await remoteDataSource.submitOrder(orderModel);
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}