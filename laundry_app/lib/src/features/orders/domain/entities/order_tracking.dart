import 'tracking_step.dart';

class OrderTracking {
  final String orderId;
  final String currentStatus;
  final int totalSteps;
  final int currentStep;
  final List<TrackingStep> pickupTimeline;
  final List<TrackingStep> deliveryTimeline;

  OrderTracking({
    required this.orderId,
    required this.currentStatus,
    required this.totalSteps,
    required this.currentStep,
    required this.pickupTimeline,
    required this.deliveryTimeline,
  });
}