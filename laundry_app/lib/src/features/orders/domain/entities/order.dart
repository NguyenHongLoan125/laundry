import 'order_item.dart';
import 'shipping_info.dart';
import 'payment_info.dart';

class Order {
  final String id;
  final String orderDate;
  final List<OrderItem> items;
  final ShippingInfo shipping;
  final PaymentInfo payment;
  final double total;
  final String status;

  Order({
    required this.id,
    required this.orderDate,
    required this.items,
    required this.shipping,
    required this.payment,
    required this.total,
    required this.status,
  });
}