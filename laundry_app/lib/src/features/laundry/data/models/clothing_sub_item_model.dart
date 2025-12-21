import '../../domain/entities/clothing_sub_item.dart';

class ClothingSubItemModel extends ClothingSubItem {
  ClothingSubItemModel({
    required String id,
    required String name,
    int quantity = 0,
    required double price,
    required String serviceId,
  }) : super(
    id: id,
    name: name,
    quantity: quantity,
    price: price,
    serviceId: serviceId,
  );

  factory ClothingSubItemModel.fromJson(Map<String, dynamic> json) {
    return ClothingSubItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num).toDouble(),
      serviceId: json['serviceId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'price': price,
    'serviceId': serviceId,
  };
}