import 'package:laundry_app/src/features/service/data/datasources/service_remote_data_source.dart';
import 'package:laundry_app/src/features/service/domain/entities/price.dart';
import 'package:laundry_app/src/features/service/domain/entities/service.dart';
import 'package:laundry_app/src/features/service/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;

  ServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Service>> getServices() async {
    try {
      final serviceModels = await remoteDataSource.getServices();
      return serviceModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get services: $e');
    }
  }

  @override
  Future<List<Service>> getExtraServices() async {
    try {
      final serviceModels = await remoteDataSource.getExtraServices();
      return serviceModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get extra services: $e');
    }
  }

  @override
  Future<List<Price>> getPrices(String serviceId) async {
    try {
      return await remoteDataSource.getPrices(serviceId);
    } catch (e) {
      throw Exception('Failed to get prices: $e');
    }
  }
}