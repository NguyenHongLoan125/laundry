import '../../domain/entities/package.dart';

class LaundryPackageModel extends LaundryPackage {
  LaundryPackageModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.weight,
  });

  factory LaundryPackageModel.fromJson(Map<String, dynamic> json) {
    return LaundryPackageModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      weight: json['weight'] ?? '',
    );
  }
}