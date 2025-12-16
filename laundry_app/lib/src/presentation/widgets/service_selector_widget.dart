import 'package:flutter/material.dart';
import '../../features/laundry/domain/entities/laundry_service.dart';
import '_selectable_item.dart';

class ServiceSelectorWidget extends StatelessWidget {
  final ServiceType selectedService;
  final Function(ServiceType) onServiceSelected;

  const ServiceSelectorWidget({
    Key? key,
    required this.selectedService,
    required this.onServiceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại dịch vụ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00BFA5),
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: ServiceCard(
                title: 'Giặt sấy',
                icon: Icons.dry_cleaning,
                isSelected: selectedService == ServiceType.washDry,
                onTap: () => onServiceSelected(ServiceType.washDry),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ServiceCard(
                title: 'Giặt hấp',
                icon: Icons.iron,
                isSelected: selectedService == ServiceType.washIron,
                onTap: () => onServiceSelected(ServiceType.washIron),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
