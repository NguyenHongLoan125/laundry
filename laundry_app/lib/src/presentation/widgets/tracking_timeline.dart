import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../features/orders/domain/entities/tracking_step.dart';

class TrackingTimeline extends StatelessWidget {
  final List<TrackingStep> steps;

  const TrackingTimeline({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return _buildTimelineItem(step, isLast);
      },
    );
  }

  Widget _buildTimelineItem(TrackingStep step, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date/Time column
        SizedBox(
          width: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.date,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                step.time,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Timeline line and dot
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: step.isCompleted
                    ? AppColors.primary
                    : step.isCurrent
                    ? AppColors.primary
                    : Colors.grey[300],
                shape: BoxShape.circle,
                border: Border.all(
                  color: step.isCurrent ? AppColors.primary : Colors.transparent,
                  width: step.isCurrent ? 3 : 0,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 70,
                color: step.isCompleted ? AppColors.primary : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 12),
        // Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    color: step.isCompleted || step.isCurrent
                        ? Colors.grey[900]
                        : Colors.grey[500],
                    fontSize: 14,
                    fontWeight:
                    step.isCurrent ? FontWeight.w600 : FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                if (step.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    step.description!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}