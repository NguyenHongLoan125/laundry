import 'package:dio/dio.dart';

import '../models/clothing_item_model.dart';
import '../models/package.dart';
import '../models/order_model.dart';
import '../models/service_model.dart';
import '../models/user_profile_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<List<ClothingItemModel>> getClothingItems(String serviceId);
  Future<List<OrderModel>> getOrders();
  Future<List<LaundryPackageModel>> getPackages();
  Future<UserProfileModel> getProfile();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      print('🛠️ Fetching services...');
      final response = await dio.get('/service/listServices');

      print('✅ Services response: ${response.statusCode}');
      final List<dynamic> data = response.data['data'] ?? response.data['services'] ?? [];

      print('📊 Services count: ${data.length}');
      return data.map((json) => ServiceModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print('❌ Error fetching services: ${e.response?.statusCode}');
      print('❌ Error data: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw Exception('Token hết hạn. Vui lòng đăng nhập lại.');
      }

      throw Exception('Lấy danh sách dịch vụ thất bại: ${e.response?.data?['message'] ?? e.message}');
    }
  }

  @override
  Future<List<ClothingItemModel>> getClothingItems(String serviceId) async {
    try {
      print('👕 Fetching clothing items for service: $serviceId');
      final response = await dio.get('/clothingItem/listClothingItems/$serviceId');

      print('✅ Clothing items response: ${response.statusCode}');
      final List<dynamic> data = response.data['data'] ?? response.data['clothingItems'] ?? [];

      print('📊 Clothing items count: ${data.length}');
      return data.map((json) => ClothingItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print('❌ Error fetching clothing items: ${e.response?.statusCode}');
      print('❌ Error data: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw Exception('Token hết hạn. Vui lòng đăng nhập lại.');
      }

      throw Exception('Lấy danh sách quần áo thất bại: ${e.response?.data?['message'] ?? e.message}');
    }
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      print('📦 Fetching orders...');
      final response = await dio.get('/order/list');

      print('✅ Orders response: ${response.statusCode}');
      print('📄 Orders data: ${response.data}');

      final List<dynamic> data = response.data['data'] ?? response.data['orders'] ?? [];
      print('📊 Orders count: ${data.length}');

      if (data.isEmpty) {
        print('⚠️ No orders found in response');
        return [];
      }

      final orders = data.map((json) {
        print('📄 Parsing order: ${json['_id']}');
        return OrderModel.fromJson(json);
      }).toList();

      print('✅ Successfully parsed ${orders.length} orders');
      return orders;
    } on DioException catch (e) {
      print('❌ DioException fetching orders: ${e.response?.statusCode}');
      print('❌ Error data: ${e.response?.data}');
      print('❌ Error message: ${e.message}');

      if (e.response?.statusCode == 401) {
        throw Exception('Token hết hạn. Vui lòng đăng nhập lại.');
      }

      throw Exception('Lấy danh sách đơn hàng thất bại: ${e.response?.data?['message'] ?? e.message}');
    } catch (e, stackTrace) {
      print('❌ Unexpected error fetching orders: $e');
      print('📚 Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<List<LaundryPackageModel>> getPackages() async {
    try {
      print('📦 Fetching packages...');
      final response = await dio.get('/laundry-packages');

      print('✅ Packages response: ${response.statusCode}');
      final List<dynamic> data = response.data['data'] ?? response.data['packages'] ?? [];

      print('📊 Packages count: ${data.length}');
      return data.map((json) => LaundryPackageModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print('❌ Error fetching packages: ${e.response?.statusCode}');
      print('❌ Error data: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw Exception('Token hết hạn. Vui lòng đăng nhập lại.');
      }

      throw Exception('Lấy danh sách gói giặt thất bại: ${e.response?.data?['message'] ?? e.message}');
    }
  }

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      print('👤 Fetching profile...');
      print('🔗 Endpoint: /authentication/profile');

      final response = await dio.get('/authentication/profile');

      print('✅ Profile response: ${response.statusCode}');
      print('📄 Profile data: ${response.data}');

      final data = response.data['data'] ?? response.data['profile'] ?? response.data;

      print('✅ Profile parsed successfully');
      return UserProfileModel.fromJson(data);
    } on DioException catch (e) {
      print('❌ DioException getting profile: ${e.response?.statusCode}');
      print('❌ Error data: ${e.response?.data}');
      print('❌ Error message: ${e.message}');

      if (e.response?.statusCode == 401) {
        throw Exception('Token hết hạn. Vui lòng đăng nhập lại.');
      }

      throw Exception('Lấy thông tin profile thất bại: ${e.response?.data?['message'] ?? e.message}');
    } catch (e, stackTrace) {
      print('❌ Unexpected error getting profile: $e');
      print('📚 Stack trace: $stackTrace');
      rethrow;
    }
  }
}