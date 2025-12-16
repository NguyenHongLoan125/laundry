import '../../domain/entities/tracking_step.dart';

class TrackingStepModel extends TrackingStep {
  TrackingStepModel({
    required String id,
    required String date,
    required String time,
    required String title,
    String? description,
    required bool isCompleted,
    required bool isCurrent,
  }) : super(
    id: id,
    date: date,
    time: time,
    title: title,
    description: description,
    isCompleted: isCompleted,
    isCurrent: isCurrent,
  );

  factory TrackingStepModel.fromJson(Map<String, dynamic> json) {
    return TrackingStepModel(
      id: json['id'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['is_completed'] as bool,
      isCurrent: json['is_current'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'time': time,
    'title': title,
    'description': description,
    'is_completed': isCompleted,
    'is_current': isCurrent,
  };
}