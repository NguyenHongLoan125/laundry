import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../features/orders/domain/entities/payment_info.dart';

class PaymentInfoCard extends StatelessWidget {
  final PaymentInfo payment;

  const PaymentInfoCard({Key? key, required this.payment}) : super(key: key);

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
          const Text(
            'Thông tin đơn hàng',
            style: TextStyle(
              color: AppColorss.primary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Chi nhánh', payment.branch),
          _buildInfoRow('Mã đơn hàng', payment.orderId),
          _buildInfoRow('Thời gian tạo đơn', payment.createdDate),
          _buildInfoRow('Phương thức thanh toán', payment.paymentMethod),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColorss.textGrey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}