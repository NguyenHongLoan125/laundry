import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../features/orders/domain/entities/shipping_info.dart';

class ReceiverInfoCard extends StatelessWidget {
  final ShippingInfo shipping;

  const ReceiverInfoCard({Key? key, required this.shipping}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorss.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColorss.primaryBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: AppColorss.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Địa chỉ nhận hàng',
                style: TextStyle(
                  color: AppColorss.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            shipping.fullName,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            shipping.phone,
            style: const TextStyle(
              color: AppColorss.textGrey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            shipping.address,
            style: const TextStyle(
              color: AppColorss.textGrey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}