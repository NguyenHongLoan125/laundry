class Voucher {
  final String id;
  final String title;
  final double discountAmount;
  final double minOrderAmount;
  final String expiryDate;
  final bool isUsed;
  final bool isExpired;
  final String? description;

  Voucher({
    required this.id,
    required this.title,
    required this.discountAmount,
    required this.minOrderAmount,
    required this.expiryDate,
    required this.isUsed,
    required this.isExpired,
    this.description,
  });
}