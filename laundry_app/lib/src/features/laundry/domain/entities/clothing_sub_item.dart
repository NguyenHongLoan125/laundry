class ClothingSubItem {
  final String id;
  final String name;
  final int quantity;

  ClothingSubItem({
    required this.id,
    required this.name,
    this.quantity = 0,
  });

  ClothingSubItem copyWith({
    String? id,
    String? name,
    int? quantity,
  }) {
    return ClothingSubItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
    );
  }
}