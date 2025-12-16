class LaundryPackage {
  final String id;
  final String name;
  final String description;
  final double discount;
  final DateTime expiryDate;
  final bool isSelected;

  LaundryPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.discount,
    required this.expiryDate,
    this.isSelected = false,
  });

  LaundryPackage copyWith({
    String? id,
    String? name,
    String? description,
    double? discount,
    DateTime? expiryDate,
    bool? isSelected,
  }) {
    return LaundryPackage(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      discount: discount ?? this.discount,
      expiryDate: expiryDate ?? this.expiryDate,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}