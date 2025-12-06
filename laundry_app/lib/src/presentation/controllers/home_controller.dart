import '../../features/auth/data/models/home_model.dart';

class HomeController {
  bool isLoading = true;
  List<Product>? services;
  List<Product>? clothes;

  HomeController() {
    loadData();
  }

  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 2)); // giả API

    services = [
      Product(name: "Giặt ủi", iconUrl: "https://via.placeholder.com/50"),
      Product(name: "Sấy khô"),
      Product(name: "Ủi đồ", iconUrl: null),
      Product(name: "Giặt hấp"),
    ];

    clothes = [
      Product(name: "Quần áo", iconUrl: "https://via.placeholder.com/50"),
      Product(name: "Đặt biệt"),
      Product(name: "Gấu bông", iconUrl: null),
      Product(name: "Chăn"),
      Product(name: "Rèm cửa")
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