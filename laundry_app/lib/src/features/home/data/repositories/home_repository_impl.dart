import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/package.dart';
import '../../domain/entities/serrvice.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Service>> getServices() async {
    return await remoteDataSource.getServices();
  }

  @override
  Future<List<ClothingItem>> getClothingItems(String serviceId) async {
    return await remoteDataSource.getClothingItems(serviceId);
  }

  @override
  Future<List<Order>> getOrders() async {
    return await remoteDataSource.getOrders();
  }

  @override
  Future<List<LaundryPackage>> getPackages() async {
    return await remoteDataSource.getPackages();
  }

  @override
  Future<UserProfile> getProfile() async {
    return await remoteDataSource.getProfile();
  }
}