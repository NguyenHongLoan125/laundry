import 'package:flutter/material.dart';
import '../../features/orders/domain/entities/tracking_step.dart';
import 'tracking_progress_bar.dart';
import 'tracking_timeline.dart';

class TrackingTabContent extends StatelessWidget {
  final List<TrackingStep> steps;

  const TrackingTabContent({Key? key, required this.steps}) : super(key: key);

  int _getCurrentStepIndex() {
    for (int i = 0; i < steps.length; i++) {
      if (steps[i].isCurrent) return i + 1;
    }
    // Nếu không có current, đếm số completed
    int completed = steps.where((s) => s.isCompleted).length;
    return completed;
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _getCurrentStepIndex();
    final totalSteps = steps.length;

    return Column(
      children: [
        TrackingProgressBar(
          currentStep: currentStep,
          totalSteps: totalSteps,
        ),
        Expanded(
          child: TrackingTimeline(steps: steps),
        ),
      ],
    );
  }
}