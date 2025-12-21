import 'package:laundry_app/src/features/service/data/models/price_model.dart';
import 'package:laundry_app/src/features/service/data/models/service_model.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/price.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<List<ServiceModel>> getExtraServices();
  Future<List<Price>> getPrices(String serviceId);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final Dio dio;

  ServiceRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await dio.get('/service/listServices');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['code'] == 'success') {
          final List<dynamic> data = responseData['data'];
          return data.map((json) => ServiceModel.fromApiJson(json)).toList();
        } else {
          throw Exception('API error: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load services: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching services: $e');
    }
  }

  @override
  Future<List<ServiceModel>> getExtraServices() async {
    try {
      final response = await dio.get('/service/listAddServices');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['code'] == 'success') {
          final List<dynamic> data = responseData['data'];
          return data.map((json) => ServiceModel.fromApiJson(json)).toList();
        } else {
          throw Exception('API error: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load extra services: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching extra services: $e');
    }
  }

  @override
  Future<List<Price>> getPrices(String serviceId) async {
    try {
      // Ưu tiên gọi API laundryPackageOrder trước
      final response = await dio.get('/laundryPackageOrder/$serviceId');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['code'] == 'success') {
          final List<dynamic> data = responseData['data'];
          return _convertToPrice(serviceId, data, source: 'laundryPackageOrder');
        } else {
          throw Exception('API error: ${responseData['message']}');
        }
      } else {
        // Fallback về clothingItem API
        return await _getClothingItemsFallback(serviceId);
      }
    } catch (e) {
      print("Error calling laundryPackageOrder: $e");
      // Fallback về clothingItem API
      return await _getClothingItemsFallback(serviceId);
    }
  }

  // Fallback method: gọi API clothingItem
  Future<List<Price>> _getClothingItemsFallback(String serviceId) async {
    try {
      final response = await dio.get('/clothingItem/listClothingItems/$serviceId');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['code'] == 'success') {
          final List<dynamic> data = responseData['data'];
          return _convertToPrice(serviceId, data, source: 'clothingItem');
        } else {
          throw Exception('API error: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load clothing items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching clothing items: $e');
    }
  }

  // Helper method để convert dữ liệu từ API thành Price object
  List<Price> _convertToPrice(String serviceId, List<dynamic> data, {required String source}) {
    // Chuyển đổi List<dynamic> thành List<Map<String, dynamic>>
    final apiData = data.cast<Map<String, dynamic>>().toList();

    final categories = apiData.map((categoryData) {
      return PriceCategoryModel(
        name: _getCategoryName(categoryData, source),
        items: _getCategoryItems(categoryData, source),
      );
    }).toList();

    return [
      PriceModel.fromGroupedData(
        serviceId: serviceId,
        categories: categories,
      )
    ];
  }

  // Helper để lấy category name từ data
  String _getCategoryName(Map<String, dynamic> categoryData, String source) {
    if (source == 'laundryPackageOrder') {
      return categoryData['category_name'] ??
          categoryData['type'] ??
          'Loại đồ';
    } else {
      return categoryData['type'] ?? 'Loại đồ';
    }
  }

  // Helper để lấy category items từ data
  List<PriceItemModel> _getCategoryItems(Map<String, dynamic> categoryData, String source) {
    final itemsData = categoryData['items'] as List? ?? [];

    return itemsData.map((itemData) {
      if (source == 'laundryPackageOrder') {
        return PriceItemModel(
          subname: itemData['item_name'] ?? itemData['subname'] ?? '',
          cost: itemData['price'] ?? itemData['cost'] ?? 0,
          unit: itemData['unit'] ?? 'kg',
        );
      } else {
        return PriceItemModel(
          subname: itemData['subname'] ?? '',
          cost: itemData['cost'] ?? 0,
          unit: itemData['unit'] ?? 'kg',
        );
      }
    }).toList();
  }

  // Helper để lấy tên dịch vụ từ serviceId (nếu cần)
  String _getServiceName(String serviceId) {
    final serviceMap = {
      "69443a3bc497e2ae69d227c5": "Giặt sấy",
      // Thêm các serviceId khác nếu có
    };
    return serviceMap[serviceId] ?? "Dịch vụ";
  }
}