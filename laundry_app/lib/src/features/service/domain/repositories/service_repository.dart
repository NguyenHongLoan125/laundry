import 'package:laundry_app/src/features/service/domain/entities/price.dart';
import 'package:laundry_app/src/features/service/domain/entities/service.dart';

abstract class ServiceRepository {
  Future<List<Service>> getServices();
  Future<List<Service>> getExtraServices();
  Future<List<Price>> getPrices(String serviceId);
}