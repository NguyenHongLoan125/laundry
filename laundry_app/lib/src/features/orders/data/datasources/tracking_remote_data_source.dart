import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_tracking_model.dart';
import '../models/tracking_step_model.dart';

abstract class TrackingRemoteDataSource {
  Future<OrderTrackingModel> fetchOrderTracking(String orderId);
}

// ✅ CÁCH 1: API THẬT
class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  TrackingRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<OrderTrackingModel> fetchOrderTracking(String orderId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/orders/$orderId/tracking'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return OrderTrackingModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch tracking: ${response.statusCode}');
    }
  }
}

// ✅ CÁCH 2: DỮ LIỆU GIẢ (MOCK)
class TrackingMockDataSource implements TrackingRemoteDataSource {
  @override
  Future<OrderTrackingModel> fetchOrderTracking(String orderId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return mock data
    return OrderTrackingModel(
      orderId: orderId,
      currentStatus: 'in_transit',
      totalSteps: 3,
      currentStep: 2,
      pickupTimeline: [
        TrackingStepModel(
          id: 'pickup_1',
          date: '03/11/21',
          time: '14:00',
          title: 'Đơn hàng đã đến tiệm',
          isCompleted: true,
          isCurrent: false,
        ),
        TrackingStepModel(
          id: 'pickup_2',
          date: '04/11/21',
          time: '09:30',
          title: 'Đơn vị vận chuyển đã lấy hàng thành công',
          isCompleted: true,
          isCurrent: false,
        ),
        TrackingStepModel(
          id: 'pickup_3',
          date: '04/11/21',
          time: '14:00',
          title: 'Đơn hàng đã được đóng gói, đang đợi đon vị vận chuyển',
          isCompleted: true,
          isCurrent: false,
        ),
        TrackingStepModel(
          id: 'pickup_4',
          date: '05/11/21',
          time: '08:00',
          title: 'Đơn hàng đã được đặt',
          isCompleted: true,
          isCurrent: false,
        ),
      ],
      deliveryTimeline: [
        TrackingStepModel(
          id: 'delivery_1',
          date: '05/11/21',
          time: '10:00',
          title: 'Giao thành công',
          isCompleted: true,
          isCurrent: false,
        ),
        TrackingStepModel(
          id: 'delivery_2',
          date: '05/11/21',
          time: '14:00',
          title: 'Đơn vị vận chuyển đã lấy hàng thành công. Đơn hàng đang trên đường giao đến bạn vui lòng chú ý điện thoại',
          isCompleted: false,
          isCurrent: true,
        ),
        TrackingStepModel(
          id: 'delivery_3',
          date: '05/11/21',
          time: '18:00',
          title: 'Đơn giặt đang trong giai đoạn đóng gói và chờ đơn vị vận chuyển.',
          isCompleted: false,
          isCurrent: false,
        ),
        TrackingStepModel(
          id: 'delivery_4',
          date: '05/11/21',
          time: '20:30',
          title: 'Đang trong giai đoạn ủi đồ',
          isCompleted: false,
          isCurrent: false,
        ),
        TrackingStepModel(
          id: 'delivery_5',
          date: '06/11/21',
          time: '08:30',
          title: 'Đang trong giai đoạn giặt',
          isCompleted: false,
          isCurrent: false,
        ),
        TrackingStepModel(
          id: 'delivery_6',
          date: '06/11/21',
          time: '14:00',
          title: 'Đơn hàng đã đến tiệm',
          isCompleted: false,
          isCurrent: false,
        ),
      ],
    );
  }
}