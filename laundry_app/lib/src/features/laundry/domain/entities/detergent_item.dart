class DetergentItem {
  final String id;
  final String name;
  final bool isSelected;

  DetergentItem({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  DetergentItem copyWith({
    String? id,
    String? name,
    bool? isSelected,
  }) {
    return DetergentItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}