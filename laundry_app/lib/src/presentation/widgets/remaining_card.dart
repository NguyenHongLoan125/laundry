import 'package:flutter/material.dart';

class RemainingCard extends StatelessWidget {
  final String weight;
  final VoidCallback onTap;

  const RemainingCard({
    super.key,
    required this.weight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2EC4B6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Số kg còn lại:",
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  weight,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
