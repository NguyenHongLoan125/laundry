import '../../domain/entities/order.dart';
import 'order_item_model.dart';
import 'shipping_info_model.dart';
import 'payment_info_model.dart';

class OrderModel extends Order {
  OrderModel({
    required String id,
    required String orderDate,
    required List<OrderItemModel> items,
    required ShippingInfoModel shipping,
    required PaymentInfoModel payment,
    required double total,
    required String status,
  }) : super(
    id: id,
    orderDate: orderDate,
    items: items,
    shipping: shipping,
    payment: payment,
    total: total,
    status: status,
  );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderDate: json['order_date'] as String,
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      shipping: ShippingInfoModel.fromJson(json['shipping']),
      payment: PaymentInfoModel.fromJson(json['payment']),
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_date': orderDate,
    'items': items.map((e) => (e as OrderItemModel).toJson()).toList(),
    'shipping': (shipping as ShippingInfoModel).toJson(),
    'payment': (payment as PaymentInfoModel).toJson(),
    'total': total,
    'status': status,
  };
}