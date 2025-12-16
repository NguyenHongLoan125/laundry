import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../features/orders/domain/entities/shipping_info.dart';

class ShippingInfoCard extends StatelessWidget {
  final ShippingInfo shipping;

  const ShippingInfoCard({Key? key, required this.shipping}) : super(key: key);

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
              Icon(Icons.local_shipping, color: AppColorss.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Thông tin vận chuyển',
                style: TextStyle(
                  color: AppColorss.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildShippingRow(
            Icons.inventory_2,
            shipping.estimatedDate,
            shipping.actualDate,
          ),
          const SizedBox(height: 12),
          _buildShippingRow(
            Icons.local_shipping,
            shipping.deliveryStatus,
            '${shipping.deliveryDate}\n${shipping.deliveryTime}',
          ),
        ],
      ),
    );
  }

  Widget _buildShippingRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColorss.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColorss.textGrey,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}