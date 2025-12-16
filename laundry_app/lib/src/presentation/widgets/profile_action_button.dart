import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.backgroundThird,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Column(
            children: [
              Icon(icon, size: 34, color: AppColors.primary),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
