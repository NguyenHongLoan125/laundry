import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/di/auth_dependency_injection.dart';
import '../../domain/entities/additional_service.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/clothing_sub_item.dart';
import '../../domain/entities/detergent_item.dart';
import '../../domain/entities/fabric_softener_item.dart';
import '../../domain/entities/laundry_service.dart';
import '../../domain/entities/laundry_service.dart' as entities;

abstract class LaundryRemoteDataSource {
  Future<List<ClothingItem>> getClothingItems(String serviceId);
  Future<List<AdditionalService>> getAdditionalServices();
  Future<List<Detergent>> getDetergents();
  Future<List<FabricSoftener>> getFabricSofteners();
  Future<List<LaundryService>> getLaundryServices();
  Future<String> submitOrder(Map<String, dynamic> orderData);
  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId);
}

class LaundryRemoteDataSourceImpl implements LaundryRemoteDataSource {
  final Dio? dio;

  LaundryRemoteDataSourceImpl({this.dio}) {
    if (dio != null) {
      _configureDio();
    }
  }

  void _configureDio() {
    if (dio == null) return;
    dio!.options.baseUrl = EnvironmentConfig.getBaseUrl();
    dio!.options.connectTimeout = const Duration(seconds: 30);
    dio!.options.receiveTimeout = const Duration(seconds: 30);
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    dio!.options.extra['withCredentials'] = true;

    dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );

    dio!.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('[Laundry API] $obj'),
      ),
    );
  }

  @override
  Future<List<LaundryService>> getLaundryServices() async {
    if (dio == null) {
      throw Exception('Dio is not initialized. Cannot load laundry services.');
    }
    try {
      final response = await dio!.get('/service/listServices');
      print('[Laundry Services] Response: ${response.data}');

      if (response.statusCode == 200 && response.data['code'] == 'success') {
        final List<dynamic> servicesData = response.data['data'] as List<dynamic>;

        if (servicesData.isEmpty) {
          throw Exception('No laundry services available');
        }

        return servicesData.map((json) {
          LaundryServiceType type = _mapServiceType(json['service_name'] ?? '');

          return LaundryService(
            id: json['_id'] ?? '',
            name: json['service_name'] ?? '',
            type: type,
            basePrice: (json['discount'] as num?)?.toDouble() ?? 0.0,
            description: json['service_duration'] ?? '',
          );
        }).toList();
      }

      throw Exception(response.data['message'] ?? 'Failed to load laundry services');
    } on DioException catch (e) {
      print('[Laundry Services] DioException: ${e.message}');
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Lỗi tải danh sách dịch vụ giặt');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      print('[Laundry Services] Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<AdditionalService>> getAdditionalServices() async {
    if (dio == null) {
      throw Exception('Dio is not initialized. Cannot load additional services.');
    }

    try {
      final response = await dio!.get('/service/listAddServices');

      print('[Additional Services] Response: ${response.data}');

      if (response.statusCode == 200 && response.data['code'] == 'success') {
        final List<dynamic> servicesData = response.data['data'] as List<dynamic>;

        if (servicesData.isEmpty) {
          throw Exception('No additional services available');
        }

        return servicesData.map((json) {
          // Lấy image URL từ backend (ưu tiên image, sau đó icon)
          String iconUrl = json['image'] ?? json['icon'] ?? '';

          // URL từ Cloudinary đã là full URL
          print('[Additional Services] Service: ${json['service_name']}, Image URL: $iconUrl');

          return AdditionalService(
            id: json['_id'] ?? '',
            name: json['service_name'] ?? '',
            icon: iconUrl.isNotEmpty ? iconUrl : _mapServiceIcon(json['service_name'] ?? ''),
            isSelected: false,
          );
        }).toList();
      }

      throw Exception(response.data['message'] ?? 'Failed to load additional services');
    } on DioException catch (e) {
      print('[Additional Services] DioException: ${e.message}');
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Lỗi tải danh sách dịch vụ đi kèm');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      print('[Additional Services] Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Detergent>> getDetergents() async {
    if (dio == null) {
      throw Exception('Dio is not initialized. Cannot load detergents.');
    }

    try {
      final response = await dio!.get('/detergents/listDetergents');

      print('[Detergents] Response: ${response.data}');

      if (response.statusCode == 200 && response.data['code'] == 'success') {
        final List<dynamic> detergentsData = response.data['data'] as List<dynamic>;

        if (detergentsData.isEmpty) {
          throw Exception('No detergents available');
        }

        final detergents = detergentsData.asMap().entries.map((entry) {
          final index = entry.key;
          final json = entry.value;

          return Detergent(
            id: json['_id'] ?? json['id'] ?? '',
            name: json['name'] ?? '',
            isSelected: index == 0, // Chọn item đầu tiên mặc định
          );
        }).toList();

        return detergents;
      }

      throw Exception(response.data['message'] ?? 'Failed to load detergents');
    } on DioException catch (e) {
      print('[Detergents] DioException: ${e.message}');
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Lỗi tải danh sách nước giặt');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      print('[Detergents] Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<FabricSoftener>> getFabricSofteners() async {
    if (dio == null) {
      throw Exception('Dio is not initialized. Cannot load fabric softeners.');
    }

    try {
      final response = await dio!.get('/fabricSofteners/listFabricSofteners');

      print('[Fabric Softeners] Response: ${response.data}');

      if (response.statusCode == 200 && response.data['code'] == 'success') {
        final List<dynamic> softenersData = response.data['data'] as List<dynamic>;

        if (softenersData.isEmpty) {
          throw Exception('No fabric softeners available');
        }

        final softeners = softenersData.asMap().entries.map((entry) {
          final index = entry.key;
          final json = entry.value;

          return FabricSoftener(
            id: json['_id'] ?? json['id'] ?? '',
            name: json['name'] ?? '',
            isSelected: index == 0, // Chọn item đầu tiên mặc định
          );
        }).toList();

        return softeners;
      }

      throw Exception(response.data['message'] ?? 'Failed to load fabric softeners');
    } on DioException catch (e) {
      print('[Fabric Softeners] DioException: ${e.message}');
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Lỗi tải danh sách nước xả');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      print('[Fabric Softeners] Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<ClothingItem>> getClothingItems(String serviceId) async {
    if (dio == null) {
      throw Exception('Dio is not initialized. Cannot load clothing items.');
    }

    try {
      // Sử dụng endpoint mới với serviceId
      final response = await dio!.get('/clothingItem/listClothingItems/$serviceId');

      print('[Clothing Items] Response: ${response.data}');

      if (response.statusCode == 200 && response.data['code'] == 'success') {
        final List<dynamic> itemsData = response.data['data'] as List<dynamic>;

        if (itemsData.isEmpty) {
          throw Exception('No clothing items available for service $serviceId');
        }

        return itemsData.map((json) {
          final type = json['type'] ?? '';

          // Lấy image URL từ backend (ưu tiên image, sau đó icon)
          String iconUrl = json['image'] ?? json['icon'] ?? '';

          // URL từ Cloudinary đã là full URL, không cần thêm base URL
          print('[Clothing Items] Type: $type, Image URL: $iconUrl');

          final List<dynamic> itemsList = json['items'] as List<dynamic>? ?? [];

          // Convert items to ClothingSubItem
          final subItems = itemsList.asMap().entries.map((entry) {
            final subJson = entry.value;
            return ClothingSubItem(
              id: '${json['_id']}-${entry.key}', // Tạo ID unique
              name: subJson['subname'] ?? '',
              price: (subJson['cost'] as num?)?.toDouble() ?? 0.0,
              quantity: 0, // Mặc định quantity = 0
              serviceId: serviceId,
            );
          }).toList();

          return ClothingItem(
            id: json['_id'] ?? '',
            name: type,
            icon: iconUrl.isNotEmpty ? iconUrl : _mapClothingIcon(type), // Ưu tiên icon từ backend
            isSelected: false,
            isExpanded: false,
            subItems: subItems,
          );
        }).toList();
      }

      throw Exception(response.data['message'] ?? 'Failed to load clothing items');
    } on DioException catch (e) {
      print('[Clothing Items] DioException: ${e.message}');
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Lỗi tải danh sách loại đồ');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      print('[Clothing Items] Error: $e');
      rethrow;
    }
  }

  // Helper: Map clothing type to icon (fallback nếu backend không có icon)
  String _mapClothingIcon(String type) {
    final lowerType = type.toLowerCase();

    // Áo
    if (lowerType.contains('áo sơ mi') || lowerType.contains('shirt')) {
      return '👔';
    }
    if (lowerType.contains('áo') || lowerType.contains('top')) {
      return '👕';
    }

    // Quần
    if (lowerType.contains('quần jean') || lowerType.contains('jeans')) {
      return '👖';
    }
    if (lowerType.contains('quần') || lowerType.contains('pants') || lowerType.contains('trousers')) {
      return '👖';
    }

    // Váy
    if (lowerType.contains('váy') || lowerType.contains('dress') || lowerType.contains('skirt')) {
      return '👗';
    }

    // Áo khoác
    if (lowerType.contains('áo khoác') || lowerType.contains('jacket') || lowerType.contains('coat')) {
      return '🧥';
    }

    // Đồ lót
    if (lowerType.contains('đồ lót') || lowerType.contains('underwear')) {
      return '🩲';
    }

    // Khăn
    if (lowerType.contains('khăn') || lowerType.contains('towel')) {
      return '🧣';
    }

    // Tất/vớ
    if (lowerType.contains('tất') || lowerType.contains('vớ') || lowerType.contains('socks')) {
      return '🧦';
    }

    // Chăn/ga/gối
    if (lowerType.contains('chăn') || lowerType.contains('ga') || lowerType.contains('gối') ||
        lowerType.contains('blanket') || lowerType.contains('pillow') || lowerType.contains('bedding')) {
      return '🛏️';
    }

    // Default icon
    return '👚';
  }

  LaundryServiceType _mapServiceType(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('giặt thường') || name.contains('washing')) {
      return entities.LaundryServiceType.washing;
    } else if (name.contains('giặt khô') || name.contains('dry')) {
      return entities.LaundryServiceType.dryCleaning;
    } else if (name.contains('ủi') || name.contains('iron')) {
      return entities.LaundryServiceType.ironing;
    } else if (name.contains('nhanh') || name.contains('express')) {
      return entities.LaundryServiceType.express;
    }
    return entities.LaundryServiceType.washing;
  }

  String _mapServiceIcon(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('giặt khô')) return '🧥';
    if (name.contains('nhanh')) return '⚡';
    if (name.contains('hấp') || name.contains('ủi')) return '👔';
    if (name.contains('giặt')) return '🧺';
    return '✨';
  }

  @override
  Future<String> submitOrder(Map<String, dynamic> orderData) async {
    if (dio == null) {
      throw Exception('Dio is not initialized. Cannot submit order to API.');
    }

    try {
      final cookieJar = AuthDI.cookieJar;
      final uri = Uri.parse(dio!.options.baseUrl);
      final cookies = await cookieJar.loadForRequest(uri);
      print('[Laundry Order] Current cookies: $cookies');

      final backendData = _convertToBackendFormat(orderData);
      print('[Laundry Order] Submitting order: $backendData');

      final response = await dio!.post(
        '/order/create',
        data: backendData,
      );

      print('[Laundry Order] Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['code'] == 'success') {
          return 'ORD-${DateTime.now().millisecondsSinceEpoch}';
        }
        throw Exception(data['message'] ?? 'Đặt đơn thất bại');
      }

      throw Exception('Đặt đơn thất bại: ${response.statusCode}');
    } on DioException catch (e) {
      print('[Laundry Order] Error: ${e.message}');
      if (e.response != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          throw Exception(errorData['message'] ?? 'Đặt đơn thất bại');
        }
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId) async {
    try {
      final response = await dio!.get('/laundryPackageOrder', queryParameters: {
        'userId': userId,
      });

      if (response.statusCode == 200) {
        return (response.data as List).cast<Map<String, dynamic>>();
      } else {
        throw Exception('Lấy danh sách đơn hàng thất bại');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi khi lấy đơn hàng: ${e.message}');
    }
  }


  Map<String, dynamic> _convertToBackendFormat(Map<String, dynamic> orderData) {
    final clothingItems = orderData['clothingItems'] as List<dynamic>? ?? [];
    final items = <Map<String, dynamic>>[];

    for (var item in clothingItems) {
      if (item is Map<String, dynamic>) {
        final name = item['name'] ?? '';
        final subItems = item['subItems'] as List<dynamic>? ?? [];

        if (subItems.isNotEmpty) {
          for (var subItem in subItems) {
            if (subItem is Map<String, dynamic>) {
              items.add({
                'type': name,
                'subType': subItem['name'],
                'quantity': subItem['quantity'],
                'price': subItem['price'],
              });
            }
          }
        } else {
          items.add({
            'type': name,
            'quantity': 1,
          });
        }
      }
    }

    final additionalServices = orderData['additionalServices'] as List<dynamic>? ?? [];
    final otherServices = <String>[];
    for (var service in additionalServices) {
      if (service is Map<String, dynamic>) {
        otherServices.add(service['name'] ?? '');
      }
    }

    final serviceData = orderData['service'] as Map<String, dynamic>?;
    final serviceName = serviceData?['name'] ?? '';

    final detergentData = orderData['detergent'] as Map<String, dynamic>?;
    final detergentName = detergentData?['name'] ?? '';

    final fabricSoftenerData = orderData['fabricSoftener'] as Map<String, dynamic>?;
    final softenerName = fabricSoftenerData?['name'] ?? '';

    // Lấy thông tin delivery method từ orderData
    final deliveryMethodData = orderData['deliveryMethod'] as Map<String, dynamic>?;
    final deliveryMethodName = deliveryMethodData?['name'] ?? 'Giao nhận tận nơi';

    return {
      'address': orderData['address'] ?? '',
      'pakage': '', // Bỏ gói giặt
      'service': serviceName,
      'items': items,
      'washingLiquid': detergentName,
      'softener': softenerName,
      'otherService': otherServices,
      'deliveryMethod': deliveryMethodName, // Sử dụng tên delivery method thực tế
      'note': orderData['notes'] ?? '',
      'voucher': '', // Bỏ voucher
      'payment': 'cashOnDelivery', // Chỉ COD
      'total': orderData['totalPrice']?.toString() ?? '0',

      // THÊM CÁC FIELD STATUS
      'status': orderData['status'] ?? 'chờ duyệt',
      'statusText': orderData['statusText'] ?? 'Chờ duyệt',
      'createdAt': orderData['createdAt'] ?? DateTime.now().toIso8601String(),
    };
  }}