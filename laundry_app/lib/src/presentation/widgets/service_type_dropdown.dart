import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';

class ServiceTypeDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const ServiceTypeDropdown({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IntrinsicWidth(
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backgroundSecondary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          dropdownColor: AppColors.backgroundSecondary,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          items: options
              .map((type) => DropdownMenuItem(
            value: type,
            child: Text(type),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}