import 'package:laundry_app/src/features/auth/data/models/cloths_model.dart';

import '../../features/auth/data/models/service_model.dart';

class HomeController {
  bool isLoading = true;
  List<ServiceModel>? services;
  List<ClothsModel>? clothes;

  HomeController() {
    loadData();
  }

  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 2)); // giả API

    services = [
      ServiceModel(name: "Giặt ủi", iconUrl: "https://via.placeholder.com/50"),
      ServiceModel(name: "Sấy khô"),
      ServiceModel(name: "Ủi đồ", iconUrl: null),
      ServiceModel(name: "Giặt hấp"),
    ];

    clothes = [
      ClothsModel(name: "Quần áo", iconUrl: "https://via.placeholder.com/50"),
      ClothsModel(name: "Đặt biệt"),
      ClothsModel(name: "Gấu bông", iconUrl: null),
      ClothsModel(name: "Chăn"),
      ClothsModel(name: "Rèm cửa")
    ];

    isLoading = false;
  }
}

List<OrderModel> _fakeOrders() {
  return [
    OrderModel(
      id: '#00000001',
      date: DateTime(2025, 11, 3),
      price: 200000,
      status: OrderStatus.cancelled,
    ),
    OrderModel(
      id: '#00000002',
      date: DateTime(2025, 11, 5),
      price: 350000,
      status: OrderStatus.processing,
    ),
    OrderModel(
      id: '#00000003',
      date: DateTime(2025, 11, 9),
      price: 120000,
      status: OrderStatus.completed,
    ),
  ];
}