import '../../domain/entities/clothing_item.dart';
import '../../domain/entities/clothing_sub_item.dart';
import 'clothing_sub_item_model.dart';

class ClothingItemModel extends ClothingItem {
  ClothingItemModel({
    required String id,
    required String name,
    required String icon,
    bool isSelected = false,
    bool isExpanded = false,
    required List<ClothingSubItem> subItems,
  }) : super(
    id: id,
    name: name,
    icon: icon,
    isSelected: isSelected,
    isExpanded: isExpanded,
    subItems: subItems,
  );

  factory ClothingItemModel.fromJson(Map<String, dynamic> json) {
    final subItemsJson = json['subItems'] as List<dynamic>;
    final subItems = subItemsJson
        .map((item) => ClothingSubItemModel.fromJson(item))
        .toList();

    return ClothingItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
      isExpanded: json['isExpanded'] as bool? ?? false,
      subItems: subItems,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'isSelected': isSelected,
    'isExpanded': isExpanded,
    'subItems': subItems.map((subItem) {
      if (subItem is ClothingSubItemModel) {
        return subItem.toJson();
      }
      return ClothingSubItemModel(
        id: subItem.id,
        name: subItem.name,
        quantity: subItem.quantity,
        price: subItem.price,
        serviceId: subItem.serviceId, // Thêm serviceId
      ).toJson();
    }).toList(),
  };
}