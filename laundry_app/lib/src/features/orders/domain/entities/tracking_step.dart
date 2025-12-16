class TrackingStep {
  final String id;
  final String date;
  final String time;
  final String title;
  final String? description;
  final bool isCompleted;
  final bool isCurrent;

  TrackingStep({
    required this.id,
    required this.date,
    required this.time,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.isCurrent,
  });
}