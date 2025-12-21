import '../../domain/entities/detergent_item.dart';
import '../../domain/entities/fabric_softener_item.dart';
import '../../domain/repositories/laundry_repository.dart';
import '../datasources/laundry_remote_data_source.dart';
import '../datasources/laundry_local_data_source.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/laundry_package.dart';
import '../../domain/entities/additional_service.dart';
import '../../domain/entities/shipping_method.dart';
import '../../domain/entities/laundry_service.dart';

class LaundryRepositoryImpl implements LaundryRepository {
  final LaundryRemoteDataSource remoteDataSource;
  final LaundryLocalDataSource? localDataSource;

  LaundryRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<List<ClothingItem>> getClothingItems(String serviceId) async { // Thêm tham số serviceId
    return await remoteDataSource.getClothingItems(serviceId);
  }

  @override
  Future<List<LaundryPackage>> getAvailablePackages(String userId) async {
    return await remoteDataSource.getAvailablePackages(userId);
  }

  @override
  Future<List<AdditionalService>> getAdditionalServices() async {
    return await remoteDataSource.getAdditionalServices();
  }

  @override
  Future<List<ShippingMethod>> getShippingMethods() async {
    return await remoteDataSource.getShippingMethods();
  }

  @override
  Future<List<Detergent>> getDetergents() async {
    return await remoteDataSource.getDetergents();
  }

  @override
  Future<List<FabricSoftener>> getFabricSofteners() async {
    return await remoteDataSource.getFabricSofteners();
  }

  @override
  Future<List<LaundryService>> getLaundryServices() async {
    return await remoteDataSource.getLaundryServices();
  }

  @override
  Future<String> submitOrder(Map<String, dynamic> orderData) async {
    return await remoteDataSource.submitOrder(orderData);
  }

  @override
  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId) async {
    return await remoteDataSource.getOrdersByUserId(userId);
  }
}