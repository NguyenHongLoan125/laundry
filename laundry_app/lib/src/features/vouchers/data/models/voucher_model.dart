import '../../domain/entities/voucher.dart';

class VoucherModel extends Voucher {
  VoucherModel({
    required String id,
    required String title,
    required double discountAmount,
    required double minOrderAmount,
    required String expiryDate,
    required bool isUsed,
    required bool isExpired,
    String? description,
  }) : super(
    id: id,
    title: title,
    discountAmount: discountAmount,
    minOrderAmount: minOrderAmount,
    expiryDate: expiryDate,
    isUsed: isUsed,
    isExpired: isExpired,
    description: description,
  );

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id'] as String,
      title: json['title'] as String,
      discountAmount: (json['discount_amount'] as num).toDouble(),
      minOrderAmount: (json['min_order_amount'] as num).toDouble(),
      expiryDate: json['expiry_date'] as String,
      isUsed: json['is_used'] as bool,
      isExpired: json['is_expired'] as bool,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'discount_amount': discountAmount,
    'min_order_amount': minOrderAmount,
    'expiry_date': expiryDate,
    'is_used': isUsed,
    'is_expired': isExpired,
    'description': description,
  };
}