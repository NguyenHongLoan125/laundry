class FabricSoftenerItem {
  final String id;
  final String name;
  final bool isSelected;

  FabricSoftenerItem({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  FabricSoftenerItem copyWith({
    String? id,
    String? name,
    bool? isSelected,
  }) {
    return FabricSoftenerItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}