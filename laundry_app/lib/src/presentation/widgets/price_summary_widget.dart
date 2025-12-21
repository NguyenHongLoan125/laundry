import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart'; // Nếu cần

class PriceSummaryWidget extends StatelessWidget {
  final double totalPrice;
  final bool isSubmitting;
  final bool canSubmit;
  final VoidCallback onSubmit;

  const PriceSummaryWidget({
    Key? key,
    required this.totalPrice,
    required this.isSubmitting,
    required this.canSubmit,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tạm tính',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary, // Sử dụng AppColors.primary
                  ),
                ),
                Text(
                  '${totalPrice.toStringAsFixed(0)}đ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary, // Sử dụng AppColors.primary
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sử dụng PrimaryButton thay thế
            PrimaryButton(
              label: 'Đặt ngay',
              onPressed: canSubmit && !isSubmitting ? onSubmit : null,
              isLoading: isSubmitting,
              backgroundColor: AppColors.primary, // Màu nền
              textColor: AppColors.textThird, // Màu chữ
            ),
          ],
        ),
      ),
    );
  }
}

// PrimaryButton component (nên đặt trong file riêng)
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          label,
          style: GoogleFonts.pacifico(
            fontSize: 18,
            color: textColor ?? AppColors.textThird,
          ),
        ),
      ),
    );
  }
}