import '../entities/clothing_item.dart';
import '../entities/detergent_item.dart';
import '../entities/fabric_softener_item.dart';
import '../entities/laundry_package.dart';
import '../entities/additional_service.dart';
import '../entities/shipping_method.dart';
import '../entities/laundry_service.dart';

abstract class LaundryRepository {
  Future<List<ClothingItem>> getClothingItems(String serviceId); // Thêm tham số serviceId
  Future<List<LaundryPackage>> getAvailablePackages(String userId);
  Future<List<AdditionalService>> getAdditionalServices();
  Future<List<ShippingMethod>> getShippingMethods();
  Future<List<Detergent>> getDetergents();
  Future<List<FabricSoftener>> getFabricSofteners();
  Future<List<LaundryService>> getLaundryServices();
  Future<String> submitOrder(Map<String, dynamic> orderData);
  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId);
}