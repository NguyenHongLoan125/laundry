class Product{
  String ? name;
  String ? iconUrl;

  Product({this.name, this.iconUrl});
}

class Appointment {
  DateTime ? scheduleTime;
  DateTime ? rememberTime;
  String ? status;
  String ? _appointmentId;
  String ? note;

  Appointment({
    this.scheduleTime,
    this.rememberTime,
    this.status,
    String? appointmentId
  }) : _appointmentId = appointmentId;

  String? get appointmentId => _appointmentId;

  set appointmentId(String ? value) {
    _appointmentId = value;
  }

}
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

class WashingPackageModel{
  String ? name;
  String ? description;
  String ? note;
  double ? price;

  WashingPackageModel({
      this.name,
      this.description,
      this.note,
      this.price
  });
}
