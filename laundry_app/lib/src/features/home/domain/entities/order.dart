class Order {
  final String id;
  final String address;
  final String package;
  final String service;
  final List<OrderItem> items;
  final String deliveryMethod;
  final String payment;
  final double total;
  final String? status;

  Order({
    required this.id,
    required this.address,
    required this.package,
    required this.service,
    required this.items,
    required this.deliveryMethod,
    required this.payment,
    required this.total,
    required this.status,
  });
}
class OrderItem {
  final String type;
  final String subType;
  final int quantity;
  final double price;

  OrderItem({
    required this.type,
    required this.subType,
    required this.quantity,
    required this.price,
  });
}