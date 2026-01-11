// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../core/constants/app_colors.dart';
// import '../../features/laundry/domain/entities/laundry_service.dart';
//
// class ServiceSelectorWidget extends StatelessWidget {
//   final List<LaundryService> services;
//   final LaundryService? selectedService;
//   final Function(LaundryService) onServiceSelected;
//
//   const ServiceSelectorWidget({
//     Key? key,
//     required this.services,
//     required this.selectedService,
//     required this.onServiceSelected,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Lấy danh sách dịch vụ từ provider
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ...services.map((service) {
//           final isSelected = selectedService?.id == service.id;
//
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: InkWell(
//               onTap: () => onServiceSelected(service),
//               borderRadius: BorderRadius.circular(24),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: isSelected ? AppColors.backgroundSecondary : Colors.white,
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(
//                     color: isSelected ? AppColors.textPrimary : AppColors.textThird,
//                     width: isSelected ? 2 : 1,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             service.name,
//                             style: GoogleFonts.petrona(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.textSecondary,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             service.description,
//                             style: GoogleFonts.petrona(
//                               fontSize: 12,
//                               color: AppColors.textSecondary.withOpacity(0.7),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       '${service.basePrice.toStringAsFixed(0)}đ',
//                       style: GoogleFonts.petrona(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../features/laundry/domain/entities/laundry_service.dart';

class ServiceSelectorWidget extends StatelessWidget {
  final List<LaundryService> services;
  final LaundryService? selectedService;
  final Function(LaundryService) onServiceSelected;

  const ServiceSelectorWidget({
    Key? key,
    required this.services,
    required this.selectedService,
    required this.onServiceSelected,
  }) : super(key: key);

  // Hàm ánh xạ tên dịch vụ sang icon (bạn có thể điều chỉnh theo nhu cầu)
  IconData _getServiceIcon(String serviceName) {
    final lowerName = serviceName.toLowerCase();
    if (lowerName.contains('giặt sấy')) {
      return Icons.local_laundry_service;
    } else if (lowerName.contains('giặt hấp')) {
      return Icons.air;
    } else if (lowerName.contains('ủi')) {
      return Icons.iron;
    } else if (lowerName.contains('tẩy')) {
      return Icons.clean_hands;
    } else if (lowerName.contains('vá')) {
      return Icons.content_cut;
    } else {
      return Icons.cleaning_services; // Icon mặc định
    }
  }

  // Hàm tạo card dịch vụ
  Widget _buildServiceCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Color(0xFFE0E0E0),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cột
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9, // Tỷ lệ chiều rộng/chiều cao
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final isSelected = selectedService?.id == service.id;

        return _buildServiceCard(
          icon: _getServiceIcon(service.name),
          label: service.name,
          isSelected: isSelected,
          onTap: () => onServiceSelected(service),
        );
      },
    );
  }
}