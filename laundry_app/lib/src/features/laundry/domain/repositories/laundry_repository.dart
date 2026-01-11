import '../entities/clothing_item.dart';
import '../entities/detergent_item.dart';
import '../entities/fabric_softener_item.dart';
import '../entities/additional_service.dart';
import '../entities/laundry_service.dart';

abstract class LaundryRepository {
  Future<List<ClothingItem>> getClothingItems(String serviceId);
  Future<List<AdditionalService>> getAdditionalServices();
  Future<List<Detergent>> getDetergents();
  Future<List<FabricSoftener>> getFabricSofteners();
  Future<List<LaundryService>> getLaundryServices();
  Future<String> submitOrder(Map<String, dynamic> orderData);
  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId);
}