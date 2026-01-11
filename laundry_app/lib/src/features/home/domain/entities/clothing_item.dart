class ClothingItem {
  final String id;
  final String name;
  final String type;
  final String? iconUrl;

  ClothingItem({
    required this.id,
    required this.name,
    required this.type,
    this.iconUrl,
  });
}