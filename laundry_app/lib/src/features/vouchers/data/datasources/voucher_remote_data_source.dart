import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/voucher_model.dart';

abstract class VoucherRemoteDataSource {
  Future<List<VoucherModel>> fetchMyVouchers();
  Future<List<VoucherModel>> fetchAvailableVouchers();
}

// ✅ CÁCH 1: API THẬT
class VoucherRemoteDataSourceImpl implements VoucherRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  VoucherRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<VoucherModel>> fetchMyVouchers() async {
    final response = await client.get(
      Uri.parse('$baseUrl/vouchers/my-vouchers'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => VoucherModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch my vouchers: ${response.statusCode}');
    }
  }

  @override
  Future<List<VoucherModel>> fetchAvailableVouchers() async {
    final response = await client.get(
      Uri.parse('$baseUrl/vouchers/available'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => VoucherModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch available vouchers: ${response.statusCode}');
    }
  }
}

// ✅ CÁCH 2: DỮ LIỆU GIẢ (MOCK)
class VoucherMockDataSource implements VoucherRemoteDataSource {
  @override
  Future<List<VoucherModel>> fetchMyVouchers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      VoucherModel(
        id: 'voucher_1',
        title: 'Giảm 15,000đ phí giao hàng',
        discountAmount: 15000,
        minOrderAmount: 50000,
        expiryDate: '30-11-2025',
        isUsed: false,
        isExpired: false,
        description: 'Đơn tối thiểu 50,000đ',
      ),
      VoucherModel(
        id: 'voucher_2',
        title: 'Giảm 15,000đ phí giao hàng',
        discountAmount: 15000,
        minOrderAmount: 50000,
        expiryDate: '30-11-2025',
        isUsed: false,
        isExpired: false,
        description: 'Đơn tối thiểu 50,000đ',
      ),
      VoucherModel(
        id: 'voucher_3',
        title: 'Giảm 15,000đ phí giao hàng',
        discountAmount: 15000,
        minOrderAmount: 50000,
        expiryDate: '30-11-2025',
        isUsed: false,
        isExpired: false,
        description: 'Đơn tối thiểu 50,000đ',
      ),
      VoucherModel(
        id: 'voucher_4',
        title: 'Giảm 15,000đ phí giao hàng',
        discountAmount: 15000,
        minOrderAmount: 50000,
        expiryDate: '30-11-2025',
        isUsed: false,
        isExpired: false,
        description: 'Đơn tối thiểu 50,000đ',
      ),
      VoucherModel(
        id: 'voucher_5',
        title: 'Giảm 15,000đ phí giao hàng',
        discountAmount: 15000,
        minOrderAmount: 50000,
        expiryDate: '30-11-2025',
        isUsed: false,
        isExpired: false,
        description: 'Đơn tối thiểu 50,000đ',
      ),
      VoucherModel(
        id: 'voucher_6',
        title: 'Giảm 15,000đ phí giao hàng',
        discountAmount: 15000,
        minOrderAmount: 50000,
        expiryDate: '30-11-2025',
        isUsed: false,
        isExpired: false,
        description: 'Đơn tối thiểu 50,000đ',
      ),
    ];
  }

  @override
  Future<List<VoucherModel>> fetchAvailableVouchers() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      VoucherModel(
        id: 'available_1',
        title: 'Giảm 20,000đ cho đơn đầu tiên',
        discountAmount: 20000,
        minOrderAmount: 100000,
        expiryDate: '31-12-2025',
        isUsed: false,
        isExpired: false,
        description: 'Đơn tối thiểu 100,000đ',
      ),
      VoucherModel(
        id: 'available_2',
        title: 'Giảm 10,000đ phí ship',
        discountAmount: 10000,
        minOrderAmount: 30000,
        expiryDate: '15-12-2025',
        isUsed: false,
        isExpired: false,
        description: 'Đơn tối thiểu 30,000đ',
      ),
    ];
  }
}