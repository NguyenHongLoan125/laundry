import '../../domain/entities/shipping_info.dart';

class ShippingInfoModel extends ShippingInfo {
  ShippingInfoModel({
    required String fullName,
    required String phone,
    required String address,
    required String estimatedDate,
    required String actualDate,
    required String deliveryStatus,
    required String deliveryDate,
    required String deliveryTime,
  }) : super(
    fullName: fullName,
    phone: phone,
    address: address,
    estimatedDate: estimatedDate,
    actualDate: actualDate,
    deliveryStatus: deliveryStatus,
    deliveryDate: deliveryDate,
    deliveryTime: deliveryTime,
  );

  factory ShippingInfoModel.fromJson(Map<String, dynamic> json) {
    return ShippingInfoModel(
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      estimatedDate: json['estimated_date'] as String,
      actualDate: json['actual_date'] as String,
      deliveryStatus: json['delivery_status'] as String,
      deliveryDate: json['delivery_date'] as String,
      deliveryTime: json['delivery_time'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'phone': phone,
    'address': address,
    'estimated_date': estimatedDate,
    'actual_date': actualDate,
    'delivery_status': deliveryStatus,
    'delivery_date': deliveryDate,
    'delivery_time': deliveryTime,
  };
}