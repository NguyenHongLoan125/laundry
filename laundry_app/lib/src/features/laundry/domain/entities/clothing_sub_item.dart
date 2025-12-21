class ClothingSubItem {
  final String id;
  final String name;
  int quantity;
  final double price;
  final String serviceId;

  ClothingSubItem({
    required this.id,
    required this.name,
    this.quantity = 0,
    required this.price,
    required this.serviceId,
  });
}