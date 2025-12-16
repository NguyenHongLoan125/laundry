import '../../domain/entities/order_tracking.dart';
import 'tracking_step_model.dart';

class OrderTrackingModel extends OrderTracking {
  OrderTrackingModel({
    required String orderId,
    required String currentStatus,
    required int totalSteps,
    required int currentStep,
    required List<TrackingStepModel> pickupTimeline,
    required List<TrackingStepModel> deliveryTimeline,
  }) : super(
    orderId: orderId,
    currentStatus: currentStatus,
    totalSteps: totalSteps,
    currentStep: currentStep,
    pickupTimeline: pickupTimeline,
    deliveryTimeline: deliveryTimeline,
  );

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingModel(
      orderId: json['order_id'] as String,
      currentStatus: json['current_status'] as String,
      totalSteps: json['total_steps'] as int,
      currentStep: json['current_step'] as int,
      pickupTimeline: (json['pickup_timeline'] as List)
          .map((e) => TrackingStepModel.fromJson(e))
          .toList(),
      deliveryTimeline: (json['delivery_timeline'] as List)
          .map((e) => TrackingStepModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'current_status': currentStatus,
    'total_steps': totalSteps,
    'current_step': currentStep,
    'pickup_timeline': pickupTimeline
        .map((e) => (e as TrackingStepModel).toJson())
        .toList(),
    'delivery_timeline': deliveryTimeline
        .map((e) => (e as TrackingStepModel).toJson())
        .toList(),
  };
}