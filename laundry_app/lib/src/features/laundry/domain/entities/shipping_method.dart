class ShippingMethod {
  final String id;
  final String name;
  final String description;
  final double originalPrice;
  final double discountedPrice;
  final String? voucherInfo;

  const ShippingMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    this.voucherInfo,
  });
}