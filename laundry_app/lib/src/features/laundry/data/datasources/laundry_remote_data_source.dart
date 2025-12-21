import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/di/auth_dependency_injection.dart';
import '../../domain/entities/additional_service.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/clothing_sub_item.dart';
import '../../domain/entities/detergent_item.dart';
import '../../domain/entities/fabric_softener_item.dart';
import '../../domain/entities/laundry_package.dart';
import '../../domain/entities/shipping_method.dart';
import '../../domain/entities/laundry_service.dart';
import '../../domain/entities/laundry_service.dart' as entities;

abstract class LaundryRemoteDataSource {
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

class LaundryRemoteDataSourceImpl implements LaundryRemoteDataSource {
  final Dio? dio;

  LaundryRemoteDataSourceImpl({this.dio}) {
    if (dio != null) {
      _configureDio();
    }
  }

  void _configureDio() {
    if (dio == null) return;
    // print('[Laundry API] ========= CONFIGURING DIO =========');
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
          // print('[Laundry API]  Sending ${options.method} request to: ${options.baseUrl}${options.path}');
          // print('[Laundry API] Headers: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // print('[Laundry API] Received response from: ${response.realUri}');
          // print('[Laundry API] Status: ${response.statusCode}');
          // print('[Laundry API] Data: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          // print('[Laundry API]  Error: ${error.message}');
          // print('[Laundry API] Error type: ${error.type}');
          // print('[Laundry API] Stack trace: ${error.stackTrace}');
          return handler.next(error);
        },
      ),
    );

    // Giữ lại LogInterceptor
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
          return AdditionalService(
            id: json['_id'] ?? '',
            name: json['service_name'] ?? '',
            icon: _mapServiceIcon(json['service_name'] ?? ''),
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

      // print('[Clothing Items] Response: ${response.data}');
      // print('[Clothing Items] Service ID: $serviceId');

      if (response.statusCode == 200 && response.data['code'] == 'success') {
        final List<dynamic> itemsData = response.data['data'] as List<dynamic>;

        if (itemsData.isEmpty) {
          throw Exception('No clothing items available for service $serviceId');
        }

        return itemsData.map((json) {
          final type = json['type'] ?? '';

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
            icon: _mapClothingIcon(type), // Map icon dựa trên type, do chưa có icon
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
// Helper: Map clothing type to icon
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
  Future<List<LaundryPackage>> getAvailablePackages(String userId) async {
    if (dio == null) {
      throw Exception('Dio is not initialized. Cannot load laundry packages.');
    }

    try {
      // print('[Laundry Packages] ========= START =========');
      // print('[Laundry Packages] UserId: $userId');

      // SỬA: Gọi endpoint lấy ORDERS của user
      final response = await dio!.get('/laundryPackageOrder/$userId');

      print('[Laundry Packages] Response status: ${response.statusCode}');
      print('[Laundry Packages] Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Kiểm tra cấu trúc response
        if (responseData is! Map<String, dynamic>) {
          print('[Laundry Packages]  Response is not a Map');
          throw Exception('Invalid response format');
        }

        // Lấy data array
        final List<dynamic> ordersData = responseData['data'] as List<dynamic>;
        print('[Laundry Packages] Found ${ordersData.length} orders');

        if (ordersData.isEmpty) {
          print('[Laundry Packages]  User has no orders');
          return []; // Trả về list rỗng nếu user chưa có order nào
        }

        // Lọc ra các package duy nhất từ orders (tránh trùng lặp)
        final Map<String, LaundryPackage> uniquePackages = {};

        for (final order in ordersData) {
          if (order is Map<String, dynamic>) {
            final packageData = order['laundry_package_id'];

            if (packageData != null && packageData is Map<String, dynamic>) {
              final packageId = packageData['_id']?.toString() ?? packageData['id']?.toString();

              if (packageId != null && !uniquePackages.containsKey(packageId)) {
                // Parse expiry_date từ package
                DateTime? expiryDate;
                if (packageData['expiry_date'] != null) {
                  try {
                    expiryDate = DateTime.parse(packageData['expiry_date'].toString());
                  } catch (e) {
                    print('[Laundry Packages] Error parsing expiry_date: $e');
                  }
                }

                // Parse expiry_date từ order (nếu package không có)
                if (expiryDate == null && order['pickup_date'] != null) {
                  try {
                    final orderDate = DateTime.parse(order['pickup_date'].toString());
                    // Thêm 30 ngày từ ngày pickup
                    expiryDate = orderDate.add(const Duration(days: 30));
                  } catch (e) {
                    print('[Laundry Packages] Error parsing pickup_date: $e');
                  }
                }

                // Kiểm tra trạng thái order
                final orderStatus = order['status']?.toString() ?? 'pending';
                final isActive = orderStatus != 'cancelled' && orderStatus != 'completed';

                final package = LaundryPackage(
                  id: packageId,
                  name: packageData['name']?.toString() ?? 'Unknown Package',
                  description: packageData['description']?.toString() ?? '',
                  price: (packageData['price'] as num?)?.toDouble() ?? 0.0,
                  expiryDate: expiryDate ?? DateTime.now().add(const Duration(days: 30)),
                  discountPercent: (packageData['discount_percent'] as num?)?.toDouble() ?? 0.0,
                  isActive: isActive,
                );

                uniquePackages[packageId] = package;
                print('[Laundry Packages] Added package: ${package.name} (Active: $isActive)');
              }
            }
          }
        }

        final packagesList = uniquePackages.values.toList();
        print('[Laundry Packages] Total unique packages: ${packagesList.length}');

        return packagesList;
      }

      throw Exception('Failed to load laundry packages: ${response.statusCode}');
    } on DioException catch (e) {
      print('[Laundry Packages] DioException: ${e.message}');
      print('[Laundry Packages] Error type: ${e.type}');

      if (e.response != null) {
        print('[Laundry Packages] Response status: ${e.response!.statusCode}');
        print('[Laundry Packages] Response data: ${e.response!.data}');

        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          throw Exception(errorData['message'] ?? 'Lỗi tải danh sách gói giặt');
        }
      }

      // Nếu có lỗi, trả về mock data cho packages user đã mua
      print('[Laundry Packages]  Returning mock packages for user: $userId');
      return _getMockPackagesForUser(userId);

    } catch (e, stackTrace) {
      print('[Laundry Packages] Unexpected error: $e');
      print('[Laundry Packages] Stack trace: $stackTrace');

      // Trả về mock data
      return _getMockPackagesForUser(userId);
    }
  }

// Mock data dựa trên response bạn có
  List<LaundryPackage> _getMockPackagesForUser(String userId) {
    print('[Laundry Packages]  Generating mock packages for user: $userId');

    return [
      LaundryPackage(
        id: '6946f8cd91621efddeff5831', // pkg_10kg
        name: 'Gói 440kg',
        description: 'Giặt - sấy khô - gấp gọn. Phù hợp nhu cầu giặt hằng tuần. Lưu ý: Không áp dụng cho chăn mền lớn.',
        price: 249000.0,
        expiryDate: DateTime.parse('2025-12-31T00:00:00.000Z'),
        discountPercent: 0.0,
        isActive: true, // pending order
      ),
      LaundryPackage(
        id: '6946f84691621efddeff582b', // pkg_40kg
        name: 'Gói giặt sấy 40kg',
        description: 'Sử dụng dòng máy giặt dân sinh cao cấp. Đồ sau khi giặt xong được sấy khô, diệt khuẩn và gấp gọn. Giặt riêng mỗi khách một máy.',
        price: 699000.0,
        expiryDate: DateTime.parse('2025-12-31T00:00:00.000Z'),
        discountPercent: 20.0,
        isActive: true, // pending order
      ),
    ];
  }
  @override
  Future<List<ShippingMethod>> getShippingMethods() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      ShippingMethod(
        id: '1',
        name: 'Tự giao nhận',
        description: 'Tự giao đồ tại cửa hàng và nhận lại',
        originalPrice: 0,
        discountedPrice: 0,
      ),
      ShippingMethod(
        id: '2',
        name: 'Giao nhận tận nơi',
        description: 'Nhân viên đến lấy đồ và giao lại tận nơi',
        originalPrice: 20000,
        discountedPrice: 0,
        voucherInfo: 'Miễn phí vận chuyển',
      ),
    ];
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
        // Xử lý response theo cấu trúc API của bạn
        return (response.data as List).cast<Map<String, dynamic>>();
      } else {
        throw Exception('Lấy danh sách đơn hàng thất bại');
      }
    } on DioException catch (e) {
      // Xử lý lỗi
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

    final packageData = orderData['package'] as Map<String, dynamic>?;
    final packageName = packageData?['name'] ?? '';

    final serviceData = orderData['service'] as Map<String, dynamic>?;
    final serviceName = serviceData?['name'] ?? '';

    final detergentData = orderData['detergent'] as Map<String, dynamic>?;
    final detergentName = detergentData?['name'] ?? '';

    final fabricSoftenerData = orderData['fabricSoftener'] as Map<String, dynamic>?;
    final softenerName = fabricSoftenerData?['name'] ?? '';

    final shippingMethodData = orderData['shippingMethod'] as Map<String, dynamic>?;
    final deliveryMethod = shippingMethodData?['name'] ?? '';

    return {
      'address': orderData['address'] ?? '',
      'pakage': packageName,
      'service': serviceName,
      'items': items,
      'washingLiquid': detergentName,
      'softener': softenerName,
      'otherService': otherServices,
      'deliveryMethod': deliveryMethod,
      'note': orderData['notes'] ?? '',
      'voucher': orderData['appliedDiscount']?['code'] ?? '',
      'payment': orderData['paymentMethod'] ?? 'cashOnDelivery',
      'total': orderData['totalPrice']?.toString() ?? '0',
    };
  }
}