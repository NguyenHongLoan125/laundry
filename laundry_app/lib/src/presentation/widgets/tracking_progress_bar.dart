import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TrackingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const TrackingProgressBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = currentStep / totalSteps;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    return Container(
      color: AppColorss.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Background bar
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Progress bar
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // End dot
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: progress >= 1.0 ? AppColors.primary : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đã xác nhận đơn',
                style: TextStyle(
                  color: currentStep >= 1 ? AppColors.primary : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: currentStep >= 1 ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              Text(
                'Đang giao hàng',
                style: TextStyle(
                  color: currentStep >= totalSteps ~/ 2 ? AppColors.primary : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: currentStep >= totalSteps ~/ 2 ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              Text(
                'Đã nhận hàng',
                style: TextStyle(
                  color: currentStep >= totalSteps ? AppColors.primary : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: currentStep >= totalSteps ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}