import '../../domain/entities/shipping_method.dart';

class ShippingMethodModel extends ShippingMethod {
  const ShippingMethodModel({
    required String id,
    required String name,
    required String description,
    required double originalPrice,
    required double discountedPrice,
    String? voucherInfo,
  }) : super(
    id: id,
    name: name,
    description: description,
    originalPrice: originalPrice,
    discountedPrice: discountedPrice,
    voucherInfo: voucherInfo,
  );

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) {
    return ShippingMethodModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num).toDouble(),
      voucherInfo: json['voucherInfo'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'originalPrice': originalPrice,
    'discountedPrice': discountedPrice,
    'voucherInfo': voucherInfo,
  };
}