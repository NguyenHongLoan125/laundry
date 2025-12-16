import 'package:dartz/dartz.dart';
import '../entities/laundry_order.dart';
import '../entities/laundry_package.dart';
import '../entities/clothing_item.dart';
import '../entities/detergent_item.dart';
import '../entities/fabric_softener_item.dart';

abstract class LaundryRepository {
  Future<Either<Exception, List<LaundryPackage>>> getPackages();
  Future<Either<Exception, List<ClothingItem>>> getClothingTypes();
  Future<Either<Exception, List<DetergentItem>>> getDetergents();
  Future<Either<Exception, List<FabricSoftenerItem>>> getFabricSofteners();
  Future<Either<Exception, bool>> submitOrder(LaundryOrder order);
}