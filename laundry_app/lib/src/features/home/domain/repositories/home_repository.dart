import '../entities/clothing_item.dart';
import '../entities/order.dart';
import '../entities/package.dart';
import '../entities/serrvice.dart';
import '../entities/user_profile.dart';

abstract class HomeRepository {
  Future<List<Service>> getServices();
  Future<List<ClothingItem>> getClothingItems(String serviceId);
  Future<List<Order>> getOrders();
  Future<List<LaundryPackage>> getPackages();
  Future<UserProfile> getProfile();
}