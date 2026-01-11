// import 'package:flutter/material.dart';
// import 'package:laundry_app/src/core/constants/app_colors.dart';
//
// class ServiceTypeDropdown extends StatelessWidget {
//   final String? selectedValue;
//   final List<String> options;
//   final ValueChanged<String?> onChanged;
//
//   const ServiceTypeDropdown({
//     super.key,
//     required this.selectedValue,
//     required this.options,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: IntrinsicWidth(
//         child: DropdownButtonFormField<String>(
//           value: selectedValue,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: AppColors.backgroundSecondary,
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: AppColors.primary, width: 1.5),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: AppColors.primary, width: 2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           dropdownColor: AppColors.backgroundSecondary,
//           style: const TextStyle(
//             color: AppColors.primary,
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//           ),
//           items: options
//               .map((type) => DropdownMenuItem(
//             value: type,
//             child: Text(type),
//           ))
//               .toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';

class ServiceTypeDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String myFont = 'Pacifico';

  const ServiceTypeDropdown({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Chọn dịch vụ',
                style: TextStyle(
                  fontFamily: myFont,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primary.withOpacity(0.05),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              prefixIcon: Icon(
                Icons.local_laundry_service,
                color: AppColors.primary,
                size: 20,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            dropdownColor: Colors.white,
            style: TextStyle(
              fontFamily: myFont,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
            items: options
                .map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}