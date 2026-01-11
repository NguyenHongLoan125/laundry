import '../../domain/entities/order.dart';
class OrderModel extends Order {
  OrderModel({
    required super.id,
    required super.address,
    required super.package,
    required super.service,
    required super.items,
    required super.deliveryMethod,
    required super.payment,
    required super.total,
    required super.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List?)?.map((item) {
      return OrderItem(
        type: item['type'] ?? '',
        subType: item['subType'] ?? '',
        quantity: item['quantity'] ?? 0,
        price: (item['price'] ?? 0).toDouble(),
      );
    }).toList() ?? [];

    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      address: json['address'] ?? '',
      package: json['pakage'] ?? json['package'] ?? '',
      service: json['service'] ?? '',
      items: itemsList,
      deliveryMethod: json['deliveryMethod'] ?? '',
      payment: json['payment'] ?? '',
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? '',

    );
  }
}