import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatter.dart';
import '../../features/orders/domain/entities/order_item.dart';

class OrderItemsCard extends StatelessWidget {
  final List<OrderItem> items;
  final double total;

  const OrderItemsCard({
    Key? key,
    required this.items,
    required this.total,
  }) : super(key: key);

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
            'Tóm tắt đơn hàng',
            style: TextStyle(
              color: AppColorss.primary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      if (item.unit.isNotEmpty)
                        Text(
                          ' ${item.unit}',
                          style: const TextStyle(
                            color: AppColorss.textGrey,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                if (item.quantity.isNotEmpty)
                  Text(
                    item.quantity,
                    style: const TextStyle(
                      color: AppColorss.textGrey,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 80,
                  child: Text(
                    CurrencyFormatter.format(item.price.abs()),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: item.price < 0
                          ? AppColorss.discount
                          : AppColorss.textDark,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                CurrencyFormatter.format(total),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}