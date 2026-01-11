
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> fetchOrderDetail(String orderId);
}

//  CÁCH 1: API THẬT
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  OrderRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<OrderModel> fetchOrderDetail(String orderId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/orders/$orderId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return OrderModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch order: ${response.statusCode}');
    }
  }
}

// ✅ CÁCH 2: DỮ LIỆU GIẢ (MOCK)
class OrderMockDataSource implements OrderRemoteDataSource {
  @override
  Future<OrderModel> fetchOrderDetail(String orderId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return mock data
    return OrderModel.fromJson({
      'id': orderId,
      'order_date': '03/11/2025',
      'status': 'Hoàn thành',
      'total': 151.000,
      'items': [
        {
          'id': 'item_1',
          'name': 'Loại sách vụ',
          'unit': 'Gói sấy',
          'quantity': '3kg',
          'price': 38.000,
        },
        {
          'id': 'item_2',
          'name': 'Quần áo thường',
          'unit': '',
          'quantity': '3kg',
          'price': 38.000,
        },
        {
          'id': 'item_3',
          'name': 'Quần áo trẻ em/vải',
          'unit': '',
          'quantity': '1 bộ',
          'price': 45.000,
        },
        {
          'id': 'item_4',
          'name': 'Ủi áo',
          'unit': '',
          'quantity': '3kg',
          'price': 30.000,
        },
        {
          'id': 'item_5',
          'name': 'Gối ôm',
          'unit': '',
          'quantity': '1 cái',
          'price': 25.000,
        },
        {
          'id': 'item_6',
          'name': 'Phí giao hàng',
          'unit': '',
          'quantity': '',
          'price': 15.000,
        },
        {
          'id': 'item_7',
          'name': 'Giảm giá',
          'unit': '',
          'quantity': '',
          'price': -45,
        },
      ],
      'shipping': {
        'full_name': 'Lộng Loan',
        'phone': '(+84) 123 456 789',
        'address':
        '116/3C 1G 3/4 tp2, Phường Tân Chánh Hiệp, Quận 12, TP Hồ Chí Minh',
        'estimated_date': 'Chờ đưa đồ',
        'actual_date': '08-11-2025 13:00',
        'delivery_status': 'Chờ nhận đồ',
        'delivery_date': 'Giao thành công',
        'delivery_time': '08-11-2025 13:00',
      },
      'payment': {
        'branch': 'Khổng có',
        'order_id': orderId,
        'created_date': 'Hôm nay 11:03',
        'payment_method': 'Tiền mặt',
      },
    });
  }
}