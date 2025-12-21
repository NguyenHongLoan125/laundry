class LaundryPackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discountPercent;
  final DateTime expiryDate;
  final bool isActive;

  const LaundryPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountPercent,
    required this.expiryDate,
    this.isActive = true,
  });
}