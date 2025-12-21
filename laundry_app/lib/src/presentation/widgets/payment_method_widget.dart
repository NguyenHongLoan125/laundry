import 'package:flutter/material.dart';
import '../controllers/laundry_order_controller.dart';

class PaymentMethodWidget extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final Function(PaymentMethod) onSelectMethod;

  const PaymentMethodWidget({
    Key? key,
    required this.selectedMethod,
    required this.onSelectMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentOption(
          method: PaymentMethod.cashOnDelivery,
          icon: Icons.money,
          title: 'Thanh toán khi nhận hàng',
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          method: PaymentMethod.bankTransfer,
          icon: Icons.account_balance,
          title: 'Chuyển khoản qua ngân hàng',
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    required IconData icon,
    required String title,
  }) {
    final isSelected = selectedMethod == method;

    return InkWell(
      onTap: () => onSelectMethod(method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color(0xFF00BFA5) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Color(0xFFE0F7F4) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF00BFA5) : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Color(0xFF00BFA5) : Colors.black,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Color(0xFF00BFA5),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}