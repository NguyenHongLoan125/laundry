enum OrderStatus {
  cancelled,
  completed,
  processing
}

class OrderModel {
  String ? id;
  DateTime ? date;
  double ? price;
  OrderStatus ? status;

  OrderModel({
    this.id,
    this.date,
    this.price,
    this.status,
  });
}