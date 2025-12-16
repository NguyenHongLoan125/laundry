import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final TextAlign textAlign;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label = "",
    this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: onTap != null,
      onTap: onTap,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: AppColors.primary,
      style: const TextStyle(color: AppColors.primary),
      textAlign: textAlign,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.backgroundSecondary,
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.textSecondary)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textPrimary, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}