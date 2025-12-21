import '../../domain/entities/laundry_package.dart';

class LaundryPackageModel extends LaundryPackage {
  const LaundryPackageModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required double discountPercent,
    required DateTime expiryDate,
    bool isActive = true,
  }) : super(
    id: id,
    name: name,
    description: description,
    price: price,
    discountPercent: discountPercent,
    expiryDate: expiryDate,
    isActive: isActive,
  );

  factory LaundryPackageModel.fromJson(Map<String, dynamic> json) {
    return LaundryPackageModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercent: (json['discountPercent'] as num).toDouble(),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'discountPercent': discountPercent,
    'expiryDate': expiryDate.toIso8601String(),
    'isActive': isActive,
  };
}