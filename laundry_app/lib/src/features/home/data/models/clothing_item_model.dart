import '../../domain/entities/clothing_item.dart';

class ClothingItemModel extends ClothingItem {
  ClothingItemModel({
    required super.id,
    required super.name,
    required super.type,
    super.iconUrl,
  });

  factory ClothingItemModel.fromJson(Map<String, dynamic> json) {
    return ClothingItemModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      iconUrl: json['iconUrl'],
    );
  }
}