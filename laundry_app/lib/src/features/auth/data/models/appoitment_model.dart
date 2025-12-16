class AppointmentModel {
  DateTime ? scheduleTime;
  DateTime ? rememberTime;
  String ? status;
  String ? _appointmentId;
  String ? note;

  AppointmentModel({
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