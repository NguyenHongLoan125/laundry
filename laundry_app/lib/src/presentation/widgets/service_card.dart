import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/features/service/data/models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  const ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundThird,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        children: [

          Image.asset(
            service.icon,
            width: 48,
            height: 48,
          ),

          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height: 4),
                Text(
                  service.description,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700]
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
