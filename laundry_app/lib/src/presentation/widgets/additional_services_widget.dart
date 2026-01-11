import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../features/laundry/domain/entities/additional_service.dart';

class AdditionalServicesWidget extends StatelessWidget {
  final List<AdditionalService> services;
  final Function(String) onToggle;

  const AdditionalServicesWidget({
    Key? key,
    required this.services,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: services.map((service) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ServiceItemCard(
                service: service,
                onToggle: () => onToggle(service.id),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ServiceItemCard extends StatelessWidget {
  final AdditionalService service;
  final VoidCallback onToggle;

  const _ServiceItemCard({
    required this.service,
    required this.onToggle,
  });

  bool _isImageUrl(String icon) {
    return icon.startsWith('http://') || icon.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            // Icon với ảnh nhỏ hơn và có margin
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF9F6),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4), // Thêm padding để tạo margin
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                ),
                clipBehavior: Clip.antiAlias,
                child: _isImageUrl(service.icon)
                    ? Image.network(
                  service.icon,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                    );
                  },
                )
                    : Center(
                  child: Text(
                    service.icon,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Name
            Expanded(
              child: Text(
                service.name,
                style: GoogleFonts.petrona(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Radio button
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:  AppColors.textPrimary,
                  width: 2,
                ),
              ),
              child: service.isSelected
                  ? const Center(
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor:AppColors.textPrimary,
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}