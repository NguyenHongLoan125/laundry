import 'package:flutter/material.dart';

class LaundryPackageItem extends StatelessWidget {
  final String name;
  final String price;
  final VoidCallback? onTap;

  const LaundryPackageItem({
    super.key,
    required this.name,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFBEE3F8)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Color(0xFF2B6CB0),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                color: Color(0xFF2B6CB0),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
