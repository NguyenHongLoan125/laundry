import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel({
    required String id,
    required String name,
    required String unit,
    required String quantity,
    required double price,
  }) : super(
    id: id,
    name: name,
    unit: unit,
    quantity: quantity,
    price: price,
  );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'unit': unit,
    'quantity': quantity,
    'price': price,
  };
}