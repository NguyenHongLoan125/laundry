import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách dịch vụ từ provider

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...services.map((service) {
          final isSelected = selectedService?.id == service.id;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => onServiceSelected(service),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.backgroundSecondary : Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: isSelected ? AppColors.textPrimary : AppColors.textThird,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: GoogleFonts.petrona(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service.description,
                            style: GoogleFonts.petrona(
                              fontSize: 12,
                              color: AppColors.textSecondary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${service.basePrice.toStringAsFixed(0)}đ',
                      style: GoogleFonts.petrona(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}