import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/laundry_package.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/clothing_sub_item.dart';
import '../../domain/entities/detergent_item.dart';
import '../../domain/entities/fabric_softener_item.dart';
import '../models/laundry_order_model.dart';

abstract class LaundryRemoteDataSource {
  Future<List<LaundryPackage>> getPackages();
  Future<List<ClothingItem>> getClothingTypes();
  Future<List<DetergentItem>> getDetergents();
  Future<List<FabricSoftenerItem>> getFabricSofteners();
  Future<bool> submitOrder(LaundryOrderModel order);
}

// ============================================================
// CÁCH 1: LẤY TỪ API THẬT
// ============================================================
class LaundryRemoteDataSourceImpl implements LaundryRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  LaundryRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'https://api.example.com',
  });

  @override
  Future<List<LaundryPackage>> getPackages() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/laundry/packages'),
        headers: {'Authorization': 'Bearer YOUR_TOKEN'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final packages = (data['packages'] as List)
            .map((json) => LaundryPackage(
          id: json['id'],
          name: json['name'],
          description: json['description'],
          discount: (json['discount'] as num).toDouble(),
          expiryDate: DateTime.parse(json['expiry_date']),
        ))
            .toList();
        return packages;
      }
      throw Exception('Failed to load packages');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<List<ClothingItem>> getClothingTypes() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/laundry/clothing-types'),
        headers: {'Authorization': 'Bearer YOUR_TOKEN'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = (data['clothing_types'] as List)
            .map((json) => ClothingItem(
          id: json['id'],
          name: json['name'],
          icon: json['icon'],
          subItems: json['sub_items'] != null
              ? (json['sub_items'] as List)
              .map((sub) => ClothingSubItem(
            id: sub['id'],
            name: sub['name'],
          ))
              .toList()
              : [],
        ))
            .toList();
        return items;
      }
      throw Exception('Failed to load clothing types');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<List<DetergentItem>> getDetergents() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/laundry/detergents'),
        headers: {'Authorization': 'Bearer YOUR_TOKEN'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['detergents'] as List)
            .map((json) => DetergentItem(id: json['id'], name: json['name']))
            .toList();
      }
      throw Exception('Failed to load detergents');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<List<FabricSoftenerItem>> getFabricSofteners() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/laundry/fabric-softeners'),
        headers: {'Authorization': 'Bearer YOUR_TOKEN'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['fabric_softeners'] as List)
            .map((json) =>
            FabricSoftenerItem(id: json['id'], name: json['name']))
            .toList();
      }
      throw Exception('Failed to load fabric softeners');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<bool> submitOrder(LaundryOrderModel order) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/laundry/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN',
        },
        body: jsonEncode(order.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

// ============================================================
// CÁCH 2: LẤY DỮ LIỆU GIẢ (MOCK DATA)
// ============================================================
class LaundryMockDataSource implements LaundryRemoteDataSource {
  @override
  Future<List<LaundryPackage>> getPackages() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      LaundryPackage(
        id: '1',
        name: 'Gói giặt sấy 40kg',
        description: 'Bạn được giảm giá 20%',
        discount: 0.2,
        expiryDate: DateTime(2025, 12, 5),
      ),
    ];
  }

  @override
  Future<List<ClothingItem>> getClothingTypes() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      ClothingItem(
        id: '1',
        name: 'Quần áo',
        icon: '👔',
        subItems: [
          ClothingSubItem(id: '1-1', name: 'Quần áo thường'),
          ClothingSubItem(id: '1-2', name: 'Áo trắng'),
          ClothingSubItem(id: '1-3', name: 'Áo ra màu'),
          ClothingSubItem(id: '1-4', name: 'Áo khoác, áo lạnh dày'),
        ],
      ),
      ClothingItem(
        id: '2',
        name: 'Rèm cửa',
        icon: '🪟',
      ),
      ClothingItem(
        id: '3',
        name: 'Giày',
        icon: '👟',
      ),
      ClothingItem(
        id: '4',
        name: 'Gấu bông',
        icon: '🧸',
      ),
      ClothingItem(
        id: '5',
        name: 'Đồ đặt biệt',
        icon: '✨',
      ),
    ];
  }

  @override
  Future<List<DetergentItem>> getDetergents() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      DetergentItem(id: '1', name: 'Nước giặt 1'),
      DetergentItem(id: '2', name: 'Nước giặt 1'),
      DetergentItem(id: '3', name: 'Nước giặt 1'),
      DetergentItem(id: '4', name: 'Nước giặt 1'),
    ];
  }

  @override
  Future<List<FabricSoftenerItem>> getFabricSofteners() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      FabricSoftenerItem(id: '1', name: 'Nước xả 1'),
      FabricSoftenerItem(id: '2', name: 'Nước xả 1'),
      FabricSoftenerItem(id: '3', name: 'Nước xả 1'),
      FabricSoftenerItem(id: '4', name: 'Nước xả 1'),
    ];
  }

  @override
  Future<bool> submitOrder(LaundryOrderModel order) async {
    await Future.delayed(const Duration(seconds: 1));

    print('Mock: Order submitted');
    print('Address: ${order.address}');
    print('Package: ${order.package}');
    print('Service: ${order.serviceType}');
    print('Clothing items: ${order.clothingItems}');
    print('Detergents: ${order.detergents}');
    print('Fabric softeners: ${order.fabricSofteners}');

    return true;
  }
}