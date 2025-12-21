import 'package:flutter/material.dart';

class DiscountCodeWidget extends StatelessWidget {
  final VoidCallback onOpenDiscountPage;
  final Map<String, dynamic>? appliedDiscount;

  const DiscountCodeWidget({
    super.key,
    required this.onOpenDiscountPage,
    this.appliedDiscount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mã giảm giá',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00BFA5),
              ),
            ),

            GestureDetector(
              onTap: onOpenDiscountPage, // mở màn hình mã giảm giá
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF9F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Text(
                      'Miễn phí vận chuyển',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00BFA5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Color(0xFF00BFA5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // HIỂN THỊ MÃ ĐÃ CHỌN
        if (appliedDiscount != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7F4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 18,
                  color: Color(0xFF00BFA5),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appliedDiscount!['title'] ??
                        'Đã áp dụng mã giảm giá',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF00BFA5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
