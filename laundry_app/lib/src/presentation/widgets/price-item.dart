import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/features/service/domain/entities/price.dart';

class PriceGroupWidget extends StatelessWidget {
  final PriceCategory group;

  const PriceGroupWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8),
        ...group.items.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.subname,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  "${item.cost}đ/${item.unit ?? 'kg'}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        SizedBox(height: 16),
      ],
    );
  }
}