import '../../domain/entities/clothing_sub_item.dart';
class ClothingItem {
  final String id;
  final String name;
  final String icon;
  final bool isSelected;
  final bool isExpanded;
  final List<ClothingSubItem> subItems;

  ClothingItem({
    required this.id,
    required this.name,
    required this.icon,
    this.isSelected = false,
    this.isExpanded = false,
    this.subItems = const [],
  });

  ClothingItem copyWith({
    String? id,
    String? name,
    String? icon,
    bool? isSelected,
    bool? isExpanded,
    List<ClothingSubItem>? subItems,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
      isExpanded: isExpanded ?? this.isExpanded,
      subItems: subItems ?? this.subItems,
    );
  }
}