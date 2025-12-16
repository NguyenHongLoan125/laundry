
import '../../domain/entities/payment_info.dart';

class PaymentInfoModel extends PaymentInfo {
  PaymentInfoModel({
    required String branch,
    required String orderId,
    required String createdDate,
    required String paymentMethod,
  }) : super(
    branch: branch,
    orderId: orderId,
    createdDate: createdDate,
    paymentMethod: paymentMethod,
  );

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    return PaymentInfoModel(
      branch: json['branch'] as String,
      orderId: json['order_id'] as String,
      createdDate: json['created_date'] as String,
      paymentMethod: json['payment_method'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'branch': branch,
    'order_id': orderId,
    'created_date': createdDate,
    'payment_method': paymentMethod,
  };
}