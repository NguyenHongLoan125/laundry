import 'clothing_sub_item.dart';

class ClothingItem {
  final String id;
  final String name;
  final String icon;
  bool isSelected;
  bool isExpanded;
  final List<ClothingSubItem> subItems;

  ClothingItem({
    required this.id,
    required this.name,
    required this.icon,
    this.isSelected = false,
    this.isExpanded = false,
    required this.subItems,
  });
}